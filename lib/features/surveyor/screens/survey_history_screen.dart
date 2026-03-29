import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../widgets/survey_card.dart';
import '../providers/surveyor_provider.dart';

class SurveyHistoryScreen extends ConsumerWidget {
  const SurveyHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surveyor = ref.watch(surveyorProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppStrings.surveyHistory),
        automaticallyImplyLeading: false,
      ),
      body: surveyor.surveys.isEmpty
          ? Center(child: Text(AppStrings.noData, style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary)))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: surveyor.surveys.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SurveyCard(survey: surveyor.surveys[index]),
                ).animate(delay: (index * 80).ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.05);
              },
            ),
    );
  }
}
