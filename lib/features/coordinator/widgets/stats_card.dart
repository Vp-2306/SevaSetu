import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;
  const StatsCard({super.key, required this.title, required this.value, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 18),
        ),
        const Spacer(),
        Text(value, style: AppTextStyles.headlineLarge.copyWith(color: color, fontSize: 24)),
        const SizedBox(height: 2),
        Text(title, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted),
          maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
    );
  }
}
