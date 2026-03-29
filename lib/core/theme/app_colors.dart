import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color primaryMid = Color(0xFF93C5FD);
  static const Color primaryMedium = Color(0xFF93C5FD);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // Secondary — energetic purple
  static const Color secondary = Color(0xFF7C3AED);
  static const Color secondaryLight = Color(0xFFF5F3FF);
  static const Color secondaryMid = Color(0xFFC4B5FD);

  // Accent — teal/cyan
  static const Color accent = Color(0xFF0891B2);
  static const Color accentLight = Color(0xFFECFEFF);

  // Semantic colors
  static const Color success = Color(0xFF059669);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color danger = Color(0xFFDC2626);
  static const Color dangerLight = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF0284C7);
  static const Color infoLight = Color(0xFFE0F2FE);

  // Category colors
  static const Color food = Color(0xFFEA580C);
  static const Color foodLight = Color(0xFFFFF7ED);
  static const Color health = Color(0xFF0F766E);
  static const Color healthLight = Color(0xFFF0FDFA);
  static const Color education = Color(0xFF7C3AED);
  static const Color educationLight = Color(0xFFF5F3FF);
  static const Color shelter = Color(0xFF1D4ED8);
  static const Color shelterLight = Color(0xFFEFF6FF);
  static const Color water = Color(0xFF0891B2);
  static const Color waterLight = Color(0xFFECFEFF);

  // Legacy category color names (backward compat)
  static const Color categoryFood = food;
  static const Color categoryHealth = health;
  static const Color categoryEducation = education;
  static const Color categoryShelter = shelter;
  static const Color categoryWater = water;
  static const Color categoryOther = Color(0xFF6B7280);

  // Light theme backgrounds
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color surfaceElevated = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Borders and dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderFocus = Color(0xFF2563EB);
  static const Color divider = Color(0xFFF1F5F9);

  // Gradients
  static const List<Color> gradientPrimary = [Color(0xFF2563EB), Color(0xFF7C3AED)];
  static const List<Color> gradientWarm = [Color(0xFFEA580C), Color(0xFFD97706)];
  static const List<Color> gradientSuccess = [Color(0xFF059669), Color(0xFF0891B2)];
  static const List<Color> gradientSurveyor = [Color(0xFF0891B2), Color(0xFF0F766E)];
  static const List<Color> gradientVolunteer = [Color(0xFF7C3AED), Color(0xFF2563EB)];
  static const List<Color> gradientCoordinator = [Color(0xFF2563EB), Color(0xFF0891B2)];

  // Legacy gradient objects for backward compat
  static const LinearGradient primaryGradient = LinearGradient(
    colors: gradientPrimary,
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: gradientPrimary,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static BoxShadow get cardShadow => BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 16,
        offset: const Offset(0, 4),
      );

  // Category color helpers
  static Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return food;
      case 'health':
        return health;
      case 'education':
        return education;
      case 'shelter':
        return shelter;
      case 'water':
        return water;
      default:
        return primary;
    }
  }

  static Color categoryColorLight(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return foodLight;
      case 'health':
        return healthLight;
      case 'education':
        return educationLight;
      case 'shelter':
        return shelterLight;
      case 'water':
        return waterLight;
      default:
        return primaryLight;
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

  static List<Color> categoryGradient(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return gradientWarm;
      case 'health':
        return gradientSurveyor;
      case 'education':
        return gradientVolunteer;
      case 'shelter':
        return gradientCoordinator;
      case 'water':
        return [water, accent];
      default:
        return gradientPrimary;
    }
  }
}
