import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _host = 'localhost';
  int _port = 6080;
  int _vncPort = 5901;
  String _password = '';
  int _resWidth = 1280;
  int _resHeight = 720;
  int _colorDepth = 24;
  bool _autoStart = true;
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚙️ Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveSettings(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Connection', isDark, [
            _buildTextField('Host', _host, (v) => _host = v, isDark),
            _buildNumberField('WebSocket Port', _port, (v) => _port = v, isDark),
            _buildNumberField('VNC Port', _vncPort, (v) => _vncPort = v, isDark),
            _buildTextField('Password', _password, (v) => _password = v, isDark, obscure: true),
          ]),
          const SizedBox(height: 16),
          _buildSection('Display', isDark, [
            _buildDropdown('Resolution', ['1280x720', '1920x1080', '800x600'], '1280x720', isDark),
            _buildDropdown('Color Depth', ['16-bit', '24-bit', '32-bit'], '24-bit', isDark),
            _buildDropdown('Quality', ['Low', 'Medium', 'High'], 'Medium', isDark),
          ]),
          const SizedBox(height: 16),
          _buildSection('Performance', isDark, [
            _buildToggle('Auto-Start VNC', _autoStart, (v) => setState(() => _autoStart = v), isDark),
            _buildDropdown('CPU Limit', ['50%', '80%', '100%'], '80%', isDark),
            _buildDropdown('RAM Limit', ['512MB', '1GB', '1.5GB', '2GB'], '1.5GB', isDark),
          ]),
          const SizedBox(height: 16),
          _buildSection('Theme', isDark, [
            _buildToggle('Dark Mode', _isDark, (v) => setState(() => _isDark = v), isDark),
          ]),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildActionButton('Reset Settings', Icons.refresh, () => _resetSettings(), isDark)),
              const SizedBox(width: 12),
              Expanded(child: _buildActionButton('Export Config', Icons.download, () {}, isDark)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, bool isDark, List<Widget> children) {
    return Card(
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String value, Function(String) onChanged, bool isDark, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: TextEditingController(text: value),
        obscureText: obscure,
        style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNumberField(String label, int value, Function(int) onChanged, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: TextEditingController(text: value.toString()),
        keyboardType: TextInputType.number,
        style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
        ),
        onChanged: (v) => onChanged(int.tryParse(v) ?? value),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText)),
          DropdownButton<String>(
            value: value,
            dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }

  Widget _buildToggle(String label, bool value, Function(bool) onChanged, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText)),
          Switch(
            value: value,
            activeColor: isDark ? AppColors.darkAccent : AppColors.lightAccent,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onPressed, bool isDark) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        foregroundColor: isDark ? AppColors.darkText : AppColors.lightText,
        elevation: 2,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }

  void _saveSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved!'), backgroundColor: AppColors.success),
    );
  }

  void _resetSettings() {
    setState(() {
      _host = 'localhost';
      _port = 6080;
      _vncPort = 5901;
      _password = '';
      _autoStart = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings reset!'), backgroundColor: AppColors.warning),
    );
  }
}
