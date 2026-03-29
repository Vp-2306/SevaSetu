import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF1A56DB);
  static const Color primaryDark = Color(0xFF1240A8);

  // Secondary
  static const Color secondary = Color(0xFF5B21B6);

  // Accent
  static const Color accent = Color(0xFF0F766E);

  // Semantic
  static const Color success = Color(0xFF166534);
  static const Color warning = Color(0xFF92400E);
  static const Color danger = Color(0xFF991B1B);

  // Surfaces
  static const Color background = Color(0xFF0A0F1E);
  static const Color surface = Color(0xFF0F172A);
  static const Color surfaceElevated = Color(0xFF1E293B);

  // Text
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF475569);

  // Border
  static const Color border = Color(0x14FFFFFF);

  // Category colors
  static const Color categoryFood = Color(0xFFEA580C);
  static const Color categoryHealth = Color(0xFFDC2626);
  static const Color categoryEducation = Color(0xFF2563EB);
  static const Color categoryShelter = Color(0xFF7C3AED);
  static const Color categoryWater = Color(0xFF0891B2);
  static const Color categoryOther = Color(0xFF6B7280);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static BoxShadow get cardShadow => BoxShadow(
        color: Colors.blue.withValues(alpha: 0.15),
        blurRadius: 20,
        offset: const Offset(0, 4),
      );

  static Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return categoryFood;
      case 'health':
        return categoryHealth;
      case 'education':
        return categoryEducation;
      case 'shelter':
        return categoryShelter;
      case 'water':
        return categoryWater;
      default:
        return categoryOther;
    }
  }

  static IconData categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'health':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      case 'shelter':
        return Icons.home;
      case 'water':
        return Icons.water_drop;
      default:
        return Icons.more_horiz;
    }
  }
}
