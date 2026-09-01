import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ControlsScreen extends StatefulWidget {
  const ControlsScreen({super.key});

  @override
  State<ControlsScreen> createState() => _ControlsScreenState();
}

class _ControlsScreenState extends State<ControlsScreen> {
  double _mouseSensitivity = 50;
  double _scrollSpeed = 3;
  bool _hapticFeedback = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('🎮 Controls')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mouse Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 16),
            _buildSlider('Mouse Sensitivity', _mouseSensitivity, '%', (v) => setState(() => _mouseSensitivity = v), isDark),
            const SizedBox(height: 12),
            _buildSlider('Scroll Speed', _scrollSpeed, '', (v) => setState(() => _scrollSpeed = v), isDark),
            const SizedBox(height: 12),
            _buildToggle('Haptic Feedback', _hapticFeedback, (v) => setState(() => _hapticFeedback = v), isDark),
            const SizedBox(height: 24),
            Text(
              'Keyboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 16),
            _buildDropdown('Keyboard Layout', ['QWERTY', 'AZERTY', 'DVORAK'], 'QWERTY', isDark),
            const SizedBox(height: 24),
            Text(
              'Touchpad Mode',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            const SizedBox(height: 16),
            _buildDropdown('Mode', ['Direct Touch', 'Touchpad'], 'Direct Touch', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, double value, String unit, Function(double) onChanged, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText)),
            Text('${value.toStringAsFixed(0)}$unit', style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: label.contains('Speed') ? 10 : 100,
          divisions: 10,
          activeColor: isDark ? AppColors.darkAccent : AppColors.lightAccent,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildToggle(String label, bool value, Function(bool) onChanged, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: isDark ? AppColors.darkText : AppColors.lightText)),
        Switch(
          value: value,
          activeColor: isDark ? AppColors.darkAccent : AppColors.lightAccent,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, bool isDark) {
    return Row(
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
    );
  }
}
