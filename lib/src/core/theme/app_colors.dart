import 'package:flutter/material.dart';

/// Premium color palette using HSL-based colors
class AppColors {
  AppColors._();

  // Light theme colors
  static const Color lightPrimary = Color(0xFF6366F1); // Indigo
  static const Color lightSecondary = Color(0xFF8B5CF6); // Purple
  static const Color lightAccent = Color(0xFF06B6D4); // Cyan
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Colors.white;
  static const Color lightOnSurface = Color(0xFF1E293B);
  static const Color lightCardShadow = Color(0x1A000000);

  // Dark theme colors
  static const Color darkPrimary = Color(0xFF818CF8); // Light Indigo
  static const Color darkSecondary = Color(0xFFA78BFA); // Light Purple
  static const Color darkAccent = Color(0xFF22D3EE); // Light Cyan
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkOnSurface = Color(0xFFF1F5F9);
  static const Color darkCardShadow = Color(0x33000000);

  // Category colors
  static const Color categoryFood = Color(0xFFEF4444);
  static const Color categoryTransport = Color(0xFFF59E0B);
  static const Color categoryShopping = Color(0xFF8B5CF6);
  static const Color categoryEntertainment = Color(0xFFEC4899);
  static const Color categoryBills = Color(0xFF3B82F6);
  static const Color categoryOther = Color(0xFF6B7280);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkPrimaryGradient = LinearGradient(
    colors: [Color(0xFF818CF8), Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Animated background gradients
  static const List<Color> lightBackgroundGradient = [
    Color(0xFFF8FAFC),
    Color(0xFFEEF2FF),
    Color(0xFFF5F3FF),
  ];

  static const List<Color> darkBackgroundGradient = [
    Color(0xFF0F172A),
    Color(0xFF1E1B4B),
    Color(0xFF312E81),
  ];
}
