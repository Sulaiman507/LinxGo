import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  final List<String> _history = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _history.addAll([
      '🐧 LinxGo Terminal v1.0.0',
      'Debian 12 (Bookworm) on Android',
      'user@linxgo:~\$ _',
    ]);
  }

  void _executeCommand() {
    final cmd = _inputController.text.trim();
    if (cmd.isEmpty) return;

    setState(() {
      _history.add('user@linxgo:~\$ $cmd');
      _history.add(_simulateCommand(cmd));
      _history.add('user@linxgo:~\$ _');
      _inputController.clear();
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  String _simulateCommand(String cmd) {
    switch (cmd) {
      case 'clear':
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() => _history.clear());
        });
        return '';
      case 'ls':
        return 'Documents  Downloads  Music  Pictures  Desktop  .config';
      case 'pwd':
        return '/home/user';
      case 'whoami':
        return 'user';
      case 'date':
        return DateTime.now().toString();
      case 'uname -a':
        return 'Linux linxgo 5.15.0-android12-8-g5a9931b-dirty #1 SMP PREEMPT aarch64 GNU/Linux';
      case 'free -h':
        return '              total    used    free  shared  buff/cache  available\nMem:          4.0Gi   1.2Gi   2.1Gi   100Mi   700Mi   2.8Gi';
      case 'df -h':
        return 'Filesystem  Size  Used  Avail  Use%  Mounted on\n/dev/sda1    16G  2.1G   13G   14%  /';
      case 'neofetch':
        return '''       .-/+oossssoo+/-.      user@linxgo
    `:+ssssssssssssssssss+:`   OS: Debian 12
  -+ssssssssssssssssssyyssss+- Kernel: 5.15.0
.ossssssssssssssssss+.  `+sss.  Shell: bash 5.2
/sssssssssssssssssssss-   `+/   Terminal: xfce4-terminal
+ssssssssssssssssssss+:--`    CPU: ARMv8
/sssssssssssssssssssss+-       Memory: 1200MiB / 4000MiB
.sssssssssssssssssssss:
  +ssssssssssssssss+-`
    -/ossssso/-                    🐧 LinxGo v1.0.0''';
      case 'help':
        return 'Available commands: ls, pwd, whoami, date, uname, free, df, neofetch, clear, help';
      default:
        return 'bash: $cmd: command not found (simulated terminal)';
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('💻 Terminal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.content_copy),
            onPressed: () {
              final text = _history.join('\n');
              Clipboard.setData(ClipboardData(text: text));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Terminal output copied!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () => setState(() => _history.clear()),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: const Color(0xFF0A0A0A),
              padding: const EdgeInsets.all(12),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final line = _history[index];
                  final isPrompt = line.contains('\$');
                  final isError = line.contains('command not found');

                  return Text(
                    line,
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 13,
                      color: isError
                          ? Colors.redAccent
                          : isPrompt
                              ? Colors.greenAccent
                              : Colors.white.withOpacity(0.85),
                      height: 1.5,
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildKey('Tab', () {
                  _inputController.text += '    ';
                  _inputController.selection = TextSelection.collapsed(
                    offset: _inputController.text.length,
                  );
                }),
                _buildKey('Ctrl', () {}),
                _buildKey('Alt', () {}),
                _buildKey('Esc', () {}),
                _buildKey('↑', () {}),
                _buildKey('↓', () {}),
                _buildKey('Enter', _executeCommand),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKey(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: AppColors.lightAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
