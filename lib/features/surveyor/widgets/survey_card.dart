import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/models/survey_model.dart';

class SurveyCard extends StatelessWidget {
  final SurveyModel survey;
  const SurveyCard({super.key, required this.survey});

  @override
  Widget build(BuildContext context) {
    final cat = survey.aiExtracted?.category ?? 'other';
    final color = AppColors.categoryColor(cat);
    final statusColor = switch (survey.status) {
      'approved' => AppColors.success,
      'rejected' => AppColors.danger,
      _ => AppColors.warning,
    };
    final statusLabel = switch (survey.status) {
      'pending_review' => 'Pending',
      'approved' => 'Approved',
      'rejected' => 'Rejected',
      _ => survey.status,
    };
    final timeAgo = _formatTimeAgo(survey.submittedAt);

    return Container(
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
          Text(
            survey.aiExtracted?.description ?? survey.rawText,
            style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w500),
            maxLines: 1, overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Row(children: [
            if (survey.aiExtracted != null) ...[
              Container(
                width: 6, height: 6,
                decoration: BoxDecoration(
                  color: survey.aiExtracted!.urgency >= 4 ? AppColors.danger : AppColors.warning,
                  shape: BoxShape.circle),
              ),
              const SizedBox(width: 4),
              Text('${survey.aiExtracted!.urgency}', style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textMuted)),
              const SizedBox(width: 12),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(statusLabel, style: AppTextStyles.labelSmall.copyWith(color: statusColor)),
            ),
            const Spacer(),
            Text(timeAgo, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
          ]),
        ])),
      ]),
    );
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
