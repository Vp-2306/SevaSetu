import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/primary_button.dart';

class SurveyReviewScreen extends StatefulWidget {
  final Map<String, dynamic>? extractedData;
  const SurveyReviewScreen({super.key, this.extractedData});
  @override
  State<SurveyReviewScreen> createState() => _SurveyReviewScreenState();
}

class _SurveyReviewScreenState extends State<SurveyReviewScreen> {
  String _category = 'food';
  final _descController = TextEditingController(text: 'Food distribution needed for families in the area');
  double _urgency = 4;
  final _countController = TextEditingController(text: '150');
  final _locationController = TextEditingController(text: 'Dharavi, Mumbai');
  final categories = ['food', 'health', 'education', 'shelter', 'water', 'other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.pop()),
        title: const Text('Review Survey'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 16),
            Text('Category', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary))
                .animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: categories.map((cat) {
              final selected = cat == _category;
              return GestureDetector(
                onTap: () => setState(() => _category = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.categoryColor(cat).withValues(alpha: 0.2) : AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: selected ? AppColors.categoryColor(cat) : AppColors.border),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(AppColors.categoryIcon(cat), size: 16,
                      color: selected ? AppColors.categoryColor(cat) : AppColors.textMuted),
                    const SizedBox(width: 6),
                    Text(cat[0].toUpperCase() + cat.substring(1),
                      style: AppTextStyles.labelLarge.copyWith(
                        color: selected ? AppColors.categoryColor(cat) : AppColors.textMuted)),
                  ]),
                ),
              );
            }).toList()),
            const SizedBox(height: 24),
            Text('Description', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            TextField(controller: _descController, maxLines: 3, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),
            Text('Urgency: ${_urgency.round()}/5', style: AppTextStyles.labelLarge.copyWith(
              color: AppColors.textSecondary)),
            Slider(
              value: _urgency, min: 1, max: 5, divisions: 4,
              activeColor: _urgency >= 4 ? AppColors.danger : (_urgency >= 3 ? AppColors.warning : AppColors.success),
              onChanged: (v) => setState(() => _urgency = v),
            ),
            const SizedBox(height: 24),
            Text('Estimated People Affected', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            TextField(controller: _countController, keyboardType: TextInputType.number, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 24),
            Text('Location', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            TextField(controller: _locationController, style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(suffixIcon: IconButton(icon: const Icon(Icons.my_location),
                onPressed: () => _locationController.text = 'Andheri West, Mumbai'))),
            const SizedBox(height: 40),
            PrimaryButton(text: AppStrings.submit, onPressed: () {
              _showSuccess(context);
            }).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }

  void _showSuccess(BuildContext context) {
    showDialog(
      context: context, barrierDismissible: false,
      builder: (_) => Center(child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(16)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.check_circle, color: AppColors.success, size: 64)
              .animate().scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 16),
          Text('Survey Submitted!', style: AppTextStyles.titleLarge),
          const SizedBox(height: 8),
          Text('Awaiting coordinator review', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        ]),
      )),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) { Navigator.of(context).pop(); context.go(AppRoutes.surveyorHome); }
    });
  }
}
