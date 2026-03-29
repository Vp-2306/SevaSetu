import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CreditBadge extends StatelessWidget {
  final int credits;
  const CreditBadge({super.key, required this.credits});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.stars, size: 14, color: AppColors.warning),
        const SizedBox(width: 4),
        Text('+$credits', style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.warning, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}
