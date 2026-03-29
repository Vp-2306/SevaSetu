import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/models/survey_model.dart';

class NeedApprovalCard extends StatelessWidget {
  final SurveyModel survey;
  final VoidCallback? onTap;
  const NeedApprovalCard({super.key, required this.survey, this.onTap});

  @override
  Widget build(BuildContext context) {
    final data = survey.aiExtracted;
    final cat = data?.category ?? 'other';
    final color = AppColors.categoryColor(cat);
    final timeAgo = _formatTimeAgo(survey.submittedAt);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(AppColors.categoryIcon(cat), color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data?.description ?? survey.rawText, style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(children: [
              Text('Surveyor', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
              const SizedBox(width: 8),
              Text('•', style: TextStyle(color: AppColors.textMuted)),
              const SizedBox(width: 8),
              Text(timeAgo, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
              const Spacer(),
              if (data != null) Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  color: data.urgency >= 4 ? AppColors.danger : AppColors.warning,
                  shape: BoxShape.circle),
              ),
              const SizedBox(width: 4),
              if (data != null) Text('${data.urgency}', style: AppTextStyles.labelSmall.copyWith(
                color: data.urgency >= 4 ? AppColors.danger : AppColors.warning)),
            ]),
          ])),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
        ]),
      ),
    );
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
