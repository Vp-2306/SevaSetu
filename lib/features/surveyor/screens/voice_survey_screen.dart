import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/primary_button.dart';
import '../widgets/waveform_widget.dart';
import '../widgets/extracted_data_card.dart';
import '../providers/surveyor_provider.dart';

class VoiceSurveyScreen extends ConsumerStatefulWidget {
  const VoiceSurveyScreen({super.key});
  @override
  ConsumerState<VoiceSurveyScreen> createState() => _VoiceSurveyScreenState();
}

class _VoiceSurveyScreenState extends ConsumerState<VoiceSurveyScreen>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  bool _isProcessing = false;
  bool _hasResult = false;
  String _selectedLanguage = 'Hindi';
  String _transcript = '';
  late AnimationController _pulseController;

  final _mockTranscripts = [
    'Dharavi area mein lagbhag 150 families ko urgently food distribution chahiye. Bahut din se ration nahi mila hai.',
    'Yahan ke bacchon ko school supplies ki zaroorat hai. Nearly 40 children are affected in this area.',
    'Medical camp lagana chahiye, bahut se elderly log hain jinke paas doctor ki facility nahi hai.',
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final surveyor = ref.watch(surveyorProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.pop()),
        title: Text(AppStrings.recordVoiceSurvey),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(children: [
            const SizedBox(height: 16),
            // Language selector
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: AppStrings.supportedLanguages.map((lang) {
                  final selected = lang == _selectedLanguage;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedLanguage = lang),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
                        ),
                        child: Text(lang, style: AppTextStyles.labelLarge.copyWith(
                          color: selected ? Colors.white : AppColors.textMuted)),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 48),
            // Waveform
            SizedBox(
              height: 120,
              child: WaveformWidget(isRecording: _isRecording),
            ),
            const SizedBox(height: 40),
            // Mic button
            GestureDetector(
              onTap: _toggleRecording,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording ? AppColors.primary : AppColors.surface,
                      border: Border.all(
                        color: _isRecording
                            ? AppColors.primary.withValues(alpha: 0.3 + _pulseController.value * 0.4)
                            : AppColors.border,
                        width: _isRecording ? 4 : 2,
                      ),
                      boxShadow: _isRecording ? [BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 20 + _pulseController.value * 10,
                      )] : null,
                    ),
                    child: Icon(
                      Icons.mic,
                      size: 36,
                      color: _isRecording ? Colors.white : AppColors.textSecondary,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _isRecording ? AppStrings.recording : AppStrings.tapToRecord,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),
            // Transcript
            if (_transcript.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(_transcript, style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary)),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
            if (_transcript.isNotEmpty && !_isRecording && !_hasResult) ...[
              const SizedBox(height: 24),
              PrimaryButton(
                text: AppStrings.process,
                isLoading: _isProcessing,
                onPressed: _processTranscript,
              ),
            ],
            if (_hasResult && surveyor.lastExtraction != null) ...[
              const SizedBox(height: 24),
              ExtractedDataCard(data: surveyor.lastExtraction!),
              const SizedBox(height: 16),
              Text(AppStrings.looksRight, style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              PrimaryButton(text: AppStrings.submit, onPressed: () => _submitSurvey(context)),
              const SizedBox(height: 12),
              PrimaryButton(text: AppStrings.reRecord, isOutlined: true, onPressed: _reset),
            ],
            const SizedBox(height: 40),
          ]),
        ),
      ),
    );
  }

  void _toggleRecording() {
    if (_isRecording) {
      setState(() {
        _isRecording = false;
        _transcript = _mockTranscripts[Random().nextInt(_mockTranscripts.length)];
      });
    } else {
      setState(() {
        _isRecording = true;
        _hasResult = false;
        _transcript = '';
      });
      // Simulate recording for 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isRecording) {
          setState(() {
            _isRecording = false;
            _transcript = _mockTranscripts[Random().nextInt(_mockTranscripts.length)];
          });
        }
      });
    }
  }

  Future<void> _processTranscript() async {
    setState(() => _isProcessing = true);
    await ref.read(surveyorProvider).processVoiceSurvey(_transcript, _selectedLanguage);
    if (mounted) setState(() { _isProcessing = false; _hasResult = true; });
  }

  void _submitSurvey(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.check_circle, color: AppColors.success, size: 64)
                .animate().scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            Text(AppStrings.success, style: AppTextStyles.titleLarge),
          ]),
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
        context.go(AppRoutes.surveyorHome);
      }
    });
  }

  void _reset() {
    setState(() { _transcript = ''; _hasResult = false; });
  }
}
