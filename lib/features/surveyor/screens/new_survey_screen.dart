import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';

class NewSurveyScreen extends StatelessWidget {
  const NewSurveyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.pop()),
        title: Text(AppStrings.startNewSurvey),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(AppStrings.chooseHowToReport, style: AppTextStyles.headlineMedium)
                  .animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 32),
              _MethodCard(
                icon: Icons.mic,
                color: AppColors.primary,
                title: AppStrings.recordVoiceSurvey,
                subtitle: AppStrings.speakInAnyLanguage,
                isGradientBorder: true,
                onTap: () => context.push(AppRoutes.voiceSurvey),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms).slideY(begin: 0.1),
              const SizedBox(height: 16),
              _MethodCard(
                icon: Icons.camera_alt,
                color: AppColors.accent,
                title: AppStrings.uploadSurveyPhoto,
                subtitle: AppStrings.takePhotoOfForm,
                onTap: () => context.push(AppRoutes.photoSurvey),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.1),
              const SizedBox(height: 16),
              _MethodCard(
                icon: Icons.edit_note,
                color: AppColors.secondary,
                title: AppStrings.typeManually,
                subtitle: AppStrings.enterDetailsDirectly,
                onTap: () => context.push(AppRoutes.surveyReview),
              ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1),
            ],
          ),
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final bool isGradientBorder;
  final VoidCallback onTap;

  const _MethodCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.isGradientBorder = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
          border: isGradientBorder ? null : Border.all(color: AppColors.border),
          gradient: isGradientBorder ? null : null,
          boxShadow: isGradientBorder ? [BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 16)] : null,
        ),
        foregroundDecoration: isGradientBorder
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 1.5),
              )
            : null,
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600, height: 1.2)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: AppTextStyles.labelLarge.copyWith(color: AppColors.textMuted)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}
