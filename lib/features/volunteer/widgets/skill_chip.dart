import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SkillChip extends StatelessWidget {
  final String skill;
  final bool selected;
  final VoidCallback? onTap;

  const SkillChip({super.key, required this.skill, this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.2) : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Text(skill, style: AppTextStyles.labelSmall.copyWith(
          color: selected ? AppColors.primary : AppColors.textSecondary)),
      ),
    );
  }
}
