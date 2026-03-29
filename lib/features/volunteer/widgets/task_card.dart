import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/models/need_model.dart';

class TaskCard extends StatelessWidget {
  final NeedModel need;
  final VoidCallback? onAccept;
  final VoidCallback? onTap;
  const TaskCard({super.key, required this.need, this.onAccept, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.categoryColor(need.category);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: IntrinsicHeight(
          child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(width: 4, decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(need.description, style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis)),
                if (need.isUrgent) Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.danger.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4)),
                  child: Text(AppStrings.urgent, style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.danger, fontSize: 9, fontWeight: FontWeight.w700)),
                ),
              ]),
              const SizedBox(height: 8),
              Row(children: [
                Icon(Icons.location_on, size: 14, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Expanded(child: Text(need.location.address, style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4)),
                  child: Text('2.3 ${AppStrings.kmAway}', style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textSecondary)),
                ),
              ]),
              const SizedBox(height: 8),
              if (need.requiredSkills.isNotEmpty) Wrap(spacing: 6, runSpacing: 4, children: [
                ...need.requiredSkills.take(2).map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(6)),
                  child: Text(s, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
                )),
                if (need.requiredSkills.length > 2) Text('+${need.requiredSkills.length - 2} more',
                  style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
              ]),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: SizedBox(height: 36, child: ElevatedButton(
                  onPressed: onAccept,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.zero),
                  child: Text(AppStrings.acceptTask, style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
                ))),
                const SizedBox(width: 8),
                SizedBox(height: 36, child: TextButton(
                  onPressed: () {},
                  child: Text(AppStrings.skip, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
                )),
              ]),
            ])),
          ]),
        ),
      ),
    );
  }
}
