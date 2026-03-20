import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1A56DB);
  static const Color secondary = Color(0xFF5B21B6);
  static const Color tertiary = Color(0xFF0F766E);
  static const Color success = Color(0xFF166534);
  static const Color warning = Color(0xFF92400E);
  static const Color background = Color(0xFF0A0F1E);
  static const Color surface = Color(0xFF0F172A);
  static const Color surfaceVariant = Color(0xFF1E293B);
  static const Color border = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF475569);

  // Role badge colours
  static const Color fieldWorkerColor = Color(0xFF0F766E); // teal
  static const Color coordinatorColor = Color(0xFF1A56DB); // blue
  static const Color volunteerColor = Color(0xFF5B21B6); // purple
  static const Color communityColor = Color(0xFF166534); // green
  static const Color govAdminColor = Color(0xFF92400E); // amber

  // Gradient presets
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static BoxDecoration gradientBoxDecoration({
    double borderRadius = 16,
    List<Color> colors = const [primary, secondary],
  }) {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: colors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(borderRadius),
    );
  }
}
