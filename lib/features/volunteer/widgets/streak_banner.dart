import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class StreakBanner extends StatelessWidget {
  final int streakDays;
  const StreakBanner({super.key, required this.streakDays});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        Text('🔥', style: TextStyle(fontSize: 24)),
        const SizedBox(width: 8),
        Text(
          '$streakDays-day streak! Keep going!',
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.warning),
        ),
      ]),
    ).animate().shimmer(duration: 2000.ms, color: AppColors.warning.withValues(alpha: 0.2));
  }
}
