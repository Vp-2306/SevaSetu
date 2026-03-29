import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/primary_button.dart';
import '../widgets/volunteer_assignment_card.dart';
import '../providers/coordinator_provider.dart';

class SurveyReviewDetailScreen extends ConsumerStatefulWidget {
  final String surveyId;
  const SurveyReviewDetailScreen({super.key, required this.surveyId});
  @override
  ConsumerState<SurveyReviewDetailScreen> createState() => _SurveyReviewDetailScreenState();
}

class _SurveyReviewDetailScreenState extends ConsumerState<SurveyReviewDetailScreen> {
  bool _showMatches = false;
  double _urgencyOverride = 0;
  final _rejectReasonController = TextEditingController();

  @override
  void dispose() {
    _rejectReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coord = ref.watch(coordinatorProvider);
    final survey = coord.pendingSurveys.where((s) => s.id == widget.surveyId).firstOrNull;
    if (survey == null) {
      return Scaffold(backgroundColor: AppColors.background,
        appBar: AppBar(backgroundColor: Colors.transparent,
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.pop())),
        body: Center(child: Text('Survey not found or already reviewed',
          style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary))));
    }
    final data = survey.aiExtracted!;
    if (_urgencyOverride == 0) _urgencyOverride = data.urgency.toDouble();
    final color = AppColors.categoryColor(data.category);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.pop()),
        title: const Text('Review Survey')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 16),
          // Survey source
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Icon(survey.inputType == 'voice' ? Icons.mic : (survey.inputType == 'photo' ? Icons.camera_alt : Icons.edit),
                color: AppColors.textMuted),
              const SizedBox(width: 8),
              Text('${survey.inputType[0].toUpperCase()}${survey.inputType.substring(1)} survey',
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
              const Spacer(),
              Text(_timeAgo(survey.submittedAt), style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
            ]),
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 16),
          // Raw text (expandable)
          ExpansionTile(
            title: Text('Raw Transcript / OCR Text', style: AppTextStyles.labelLarge),
            tilePadding: EdgeInsets.zero,
            childrenPadding: const EdgeInsets.only(bottom: 16),
            children: [
              Container(padding: const EdgeInsets.all(12), width: double.infinity,
                decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
                child: Text(survey.rawText, style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary, fontStyle: FontStyle.italic))),
            ],
          ),
          const SizedBox(height: 16),
          // AI Extracted fields (editable)
          Text('AI Extracted Data', style: AppTextStyles.titleLarge),
          const SizedBox(height: 16),
          // Category
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(AppColors.categoryIcon(data.category), size: 18, color: color),
              const SizedBox(width: 8),
              Text(data.category[0].toUpperCase() + data.category.substring(1),
                style: AppTextStyles.bodyLarge.copyWith(color: color, fontWeight: FontWeight.w600)),
            ])),
          const SizedBox(height: 16),
          Text(data.description, style: AppTextStyles.bodyLarge),
          const SizedBox(height: 16),
          Row(children: [
            Icon(Icons.people, size: 16, color: AppColors.textMuted), const SizedBox(width: 6),
            Text('${data.estimatedCount} people affected', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            Icon(Icons.location_on, size: 16, color: AppColors.textMuted), const SizedBox(width: 6),
            Expanded(child: Text(data.location.address, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary))),
          ]),
          const SizedBox(height: 24),
          // Urgency override
          Text('Urgency Override: ${_urgencyOverride.round()}/5',
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
          Slider(value: _urgencyOverride, min: 1, max: 5, divisions: 4,
            activeColor: _urgencyOverride >= 4 ? AppColors.danger : AppColors.warning,
            onChanged: (v) => setState(() => _urgencyOverride = v)),
          const SizedBox(height: 32),
          // Action buttons
          if (!_showMatches) ...[
            PrimaryButton(text: AppStrings.approveAndCreateTask, icon: Icons.check_circle,
              color: AppColors.success, isLoading: coord.isLoading,
              onPressed: () async {
                final updatedData = data.copyWith(urgency: _urgencyOverride.round());
                await ref.read(coordinatorProvider).approveSurvey(survey.id, updatedData);
                if (mounted) setState(() => _showMatches = true);
              }),
            const SizedBox(height: 12),
            PrimaryButton(text: AppStrings.reject, isOutlined: true, color: AppColors.danger,
              onPressed: () => _showRejectDialog(context, survey.id)),
          ],
          if (_showMatches) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12)),
              child: Row(children: [
                Icon(Icons.check_circle, color: AppColors.success),
                const SizedBox(width: 8),
                Expanded(child: Text(AppStrings.taskCreated, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success))),
              ]),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 24),
            Text(AppStrings.topMatches, style: AppTextStyles.titleLarge),
            const SizedBox(height: 12),
            ...ref.read(coordinatorProvider).volunteers.take(3).toList().asMap().entries.map((entry) {
              final v = entry.value;
              final score = (0.6 + entry.key * 0.1);
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: VolunteerAssignmentCard(
                  volunteer: v, matchScore: 1.0 - score * 0.3,
                  onAssign: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Assigned to ${v.name}! 🎉')));
                    context.pop();
                  },
                ),
              ).animate(delay: (entry.key * 100).ms).fadeIn(duration: 400.ms).slideY(begin: 0.1);
            }),
            const SizedBox(height: 12),
            PrimaryButton(text: AppStrings.autoAssignBest, onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Auto-assigned to best match! 🎉')));
              context.pop();
            }),
          ],
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  void _showRejectDialog(BuildContext context, String surveyId) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(AppStrings.reject),
      content: TextField(controller: _rejectReasonController, maxLines: 3,
        decoration: InputDecoration(hintText: AppStrings.rejectReason)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.cancel)),
        ElevatedButton(
          onPressed: () {
            ref.read(coordinatorProvider).rejectSurvey(surveyId, _rejectReasonController.text);
            Navigator.pop(context);
            context.pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
          child: Text(AppStrings.reject),
        ),
      ],
    ));
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
