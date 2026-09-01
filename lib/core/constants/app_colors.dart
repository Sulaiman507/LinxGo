import 'package:flutter/material.dart';

/// Luxury color palette for LinxGo
class AppColors {
  // Light Theme
  static const Color lightPrimary = Color(0xFF1A1A2E);
  static const Color lightSecondary = Color(0xFF16213E);
  static const Color lightAccent = Color(0xFFE94560);
  static const Color lightGold = Color(0xFFC9A96E);
  static const Color lightBackground = Color(0xFFF8F6F0);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1A1A2E);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // Dark Theme
  static const Color darkPrimary = Color(0xFF0F0F23);
  static const Color darkSecondary = Color(0xFF1A1A2E);
  static const Color darkAccent = Color(0xFFE94560);
  static const Color darkGold = Color(0xFFC9A96E);
  static const Color darkBackground = Color(0xFF0A0A1A);
  static const Color darkSurface = Color(0xFF161633);
  static const Color darkText = Color(0xFFF8F6F0);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // Shared
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFE94560), Color(0xFFFF6B6B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFC9A96E), Color(0xFFE8D5A3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
