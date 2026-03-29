import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/models/volunteer_model.dart';

class VolunteerAssignmentCard extends StatelessWidget {
  final VolunteerModel volunteer;
  final double matchScore;
  final VoidCallback? onAssign;
  const VolunteerAssignmentCard({super.key, required this.volunteer, required this.matchScore, this.onAssign});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
          child: Center(child: Text(volunteer.initials,
            style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w700))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(volunteer.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(children: [
            Icon(Icons.star, size: 14, color: AppColors.warning),
            Text(' ${volunteer.rating}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
            const SizedBox(width: 8),
            Text('${volunteer.completedTasks} tasks', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
          ]),
          const SizedBox(height: 6),
          // Match score bar
          Row(children: [
            Text('Match:', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
            const SizedBox(width: 8),
            Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: matchScore, minHeight: 6,
                backgroundColor: AppColors.surfaceElevated,
                color: matchScore > 0.7 ? AppColors.success : AppColors.warning))),
            const SizedBox(width: 8),
            Text('${(matchScore * 100).round()}%', style: AppTextStyles.labelSmall.copyWith(
              color: matchScore > 0.7 ? AppColors.success : AppColors.warning)),
          ]),
        ])),
        const SizedBox(width: 8),
        SizedBox(height: 36, child: ElevatedButton(
          onPressed: onAssign,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
          child: Text('Assign', style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
        )),
      ]),
    );
  }
}
