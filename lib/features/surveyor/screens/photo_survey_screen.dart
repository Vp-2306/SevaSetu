import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/primary_button.dart';
import '../widgets/extracted_data_card.dart';
import '../providers/surveyor_provider.dart';

class PhotoSurveyScreen extends ConsumerStatefulWidget {
  const PhotoSurveyScreen({super.key});
  @override
  ConsumerState<PhotoSurveyScreen> createState() => _PhotoSurveyScreenState();
}

class _PhotoSurveyScreenState extends ConsumerState<PhotoSurveyScreen> {
  bool _hasImage = false;
  bool _isProcessing = false;
  bool _hasResult = false;

  @override
  void initState() {
    super.initState();
    _pickImage();
  }

  Future<void> _pickImage() async {
    // Mock: simulate image pick
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) setState(() => _hasImage = true);
    _processImage();
  }

  Future<void> _processImage() async {
    setState(() => _isProcessing = true);
    await ref.read(surveyorProvider).processPhotoSurvey([0, 1, 2]); // mock bytes
    if (mounted) setState(() { _isProcessing = false; _hasResult = true; });
  }

  @override
  Widget build(BuildContext context) {
    final surveyor = ref.watch(surveyorProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.pop()),
        title: Text(AppStrings.uploadSurveyPhoto),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            const SizedBox(height: 24),
            // Mock image display
            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: _hasImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(fit: StackFit.expand, children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.secondary.withValues(alpha: 0.1)],
                              begin: Alignment.topLeft, end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Center(child: Icon(Icons.description, size: 64, color: AppColors.textMuted)),
                        ),
                      ]))
                  : const Center(child: CircularProgressIndicator()),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 24),
            if (_isProcessing)
              Column(children: [
                const SizedBox(height: 32),
                const CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: 16),
                Text(AppStrings.processingWithGemini, style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary)),
              ]).animate().fadeIn(duration: 400.ms),
            if (_hasResult && surveyor.lastExtraction != null) ...[
              ExtractedDataCard(data: surveyor.lastExtraction!)
                  .animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
              const SizedBox(height: 16),
              Text(AppStrings.looksRight, style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              PrimaryButton(text: AppStrings.submit, onPressed: () {
                context.go(AppRoutes.surveyorHome);
              }),
              const SizedBox(height: 12),
              PrimaryButton(text: 'Retake Photo', isOutlined: true, onPressed: _pickImage),
            ],
            const SizedBox(height: 40),
          ]),
        ),
      ),
    );
  }
}
