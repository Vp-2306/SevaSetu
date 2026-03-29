import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/models/survey_model.dart';

class ExtractedDataCard extends StatelessWidget {
  final AiExtractedData data;
  const ExtractedDataCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.categoryColor(data.category);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('AI Extracted Data', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        // Category chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(AppColors.categoryIcon(data.category), size: 16, color: color),
            const SizedBox(width: 6),
            Text(data.category[0].toUpperCase() + data.category.substring(1),
              style: AppTextStyles.labelLarge.copyWith(color: color)),
          ]),
        ),
        const SizedBox(height: 12),
        // Urgency
        Row(children: [
          Text('Urgency: ', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textMuted)),
          ...List.generate(5, (i) => Icon(
            i < data.urgency ? Icons.star : Icons.star_border,
            size: 18,
            color: data.urgency >= 4 ? AppColors.danger : AppColors.warning,
          )),
        ]),
        const SizedBox(height: 12),
        Text(data.description, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 12),
        Row(children: [
          Icon(Icons.people, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Text('${data.estimatedCount} people affected',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ]),
        const SizedBox(height: 8),
        Row(children: [
          Icon(Icons.location_on, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 6),
          Expanded(child: Text(data.location.address,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))),
        ]),
        if (data.confidence < 0.8) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(children: [
              Icon(Icons.warning_amber, size: 16, color: AppColors.warning),
              const SizedBox(width: 6),
              Text('Low confidence — please verify',
                style: AppTextStyles.labelSmall.copyWith(color: AppColors.warning)),
            ]),
          ),
        ],
      ]),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
  }
}
