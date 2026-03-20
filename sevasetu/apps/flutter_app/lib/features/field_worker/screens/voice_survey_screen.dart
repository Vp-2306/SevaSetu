import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

// ---------------------------------------------------------------------------
// Language chip data
// ---------------------------------------------------------------------------

const _languages = [
  ('Hi', 'Hindi'),
  ('Kn', 'Kannada'),
  ('Ta', 'Tamil'),
  ('Te', 'Telugu'),
  ('Mr', 'Marathi'),
  ('Bn', 'Bengali'),
];

// ---------------------------------------------------------------------------
// Waveform painter
// ---------------------------------------------------------------------------

class _WaveformPainter extends CustomPainter {
  final double animValue;
  final bool active;
  final int barCount;

  _WaveformPainter({
    required this.animValue,
    required this.active,
    this.barCount = 20,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barW = size.width / (barCount * 2 - 1);
    final maxH = size.height;
    final midY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final phase = i / barCount * math.pi * 4;
      final height = active
          ? maxH * 0.15 + maxH * 0.7 * ((math.sin(animValue * math.pi * 4 + phase) + 1) / 2)
          : maxH * 0.08 + maxH * 0.04 * math.sin(phase);

      final x = i * barW * 2;
      final t = animValue;
      final hue = (200 + 60 * t).clamp(0.0, 360.0);
      final paint = Paint()
        ..color = active
            ? HSLColor.fromAHSL(0.9, hue, 0.85, 0.65).toColor()
            : AppColors.textMuted.withValues(alpha: 0.5)
        ..style = PaintingStyle.fill;

      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, midY - height / 2, barW, height),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter old) => true;
}

// ---------------------------------------------------------------------------
// Enum states
// ---------------------------------------------------------------------------

enum _SurveyState { idle, recording, processing, result, success }

// ---------------------------------------------------------------------------
// Mock result
// ---------------------------------------------------------------------------

class _SurveyResult {
  final String category;
  final String urgency;
  final String location;
  final int people;
  final String transcription;

  const _SurveyResult({
    required this.category,
    required this.urgency,
    required this.location,
    required this.people,
    required this.transcription,
  });
}

const _mockResult = _SurveyResult(
  category: 'Health',
  urgency: 'HIGH',
  location: 'Ward 7, Sector B',
  people: 12,
  transcription:
      'Yahan paani mein kuch dik raha hai. Kafi log bimar ho gaye. Karib 12 log affected hain Ward saat mein.',
);

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class VoiceSurveyScreen extends StatefulWidget {
  const VoiceSurveyScreen({super.key});

  @override
  State<VoiceSurveyScreen> createState() => _VoiceSurveyScreenState();
}

class _VoiceSurveyScreenState extends State<VoiceSurveyScreen>
    with TickerProviderStateMixin {
  _SurveyState _state = _SurveyState.idle;
  int _langIndex = 0;
  late final AnimationController _waveController;
  late final AnimationController _spinController;
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void dispose() {
    _waveController.dispose();
    _spinController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() => _state = _SurveyState.recording);
    _waveController.repeat();
    _glowController.repeat(reverse: true);
  }

  void _stopRecording() {
    _waveController.stop();
    _glowController.stop();
    setState(() => _state = _SurveyState.processing);
    _spinController.repeat();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _spinController.stop();
        setState(() => _state = _SurveyState.result);
      }
    });
  }

  void _submit() {
    setState(() => _state = _SurveyState.success);
  }

  void _reRecord() {
    setState(() => _state = _SurveyState.idle);
  }

  @override
  Widget build(BuildContext context) {
    if (_state == _SurveyState.success) {
      return _buildSuccess(context);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.go('/field-worker'),
        ),
        title: const Text('Voice Survey'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _LanguageSelector(
              selected: _langIndex,
              onChanged: (i) => setState(() => _langIndex = i),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Status label
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                _state == _SurveyState.idle
                    ? 'Tap the mic to begin'
                    : _state == _SurveyState.recording
                        ? 'Recording... tap to stop'
                        : 'Structuring your survey…',
                key: ValueKey(_state),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _state == _SurveyState.recording
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
              ),
            ),
            const SizedBox(height: 32),

            // Waveform
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: AnimatedBuilder(
                  animation: _waveController,
                  builder: (_, __) => CustomPaint(
                    painter: _WaveformPainter(
                      animValue: _waveController.value,
                      active: _state == _SurveyState.recording,
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 40),

            // Processing spinner or mic button
            if (_state == _SurveyState.processing)
              _buildProcessingRing()
            else
              _buildMicButton(),

            const SizedBox(height: 32),

            // Transcription
            if (_state == _SurveyState.recording)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  _mockResult.transcription,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                ).animate().fadeIn(delay: 500.ms, duration: 600.ms),
              ),

            // Result card
            if (_state == _SurveyState.result)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: _buildResultCard(context),
                ),
              ),

            if (_state != _SurveyState.result) const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMicButton() {
    final isRecording = _state == _SurveyState.recording;
    return AnimatedBuilder(
      animation: _glowController,
      builder: (_, child) {
        final glow = isRecording ? _glowController.value : 0.0;
        return GestureDetector(
          onTap: isRecording ? _stopRecording : _startRecording,
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.9),
                  AppColors.secondary.withValues(alpha: 0.9),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3 + 0.3 * glow),
                  blurRadius: 24 + 16 * glow,
                  spreadRadius: 2 + 4 * glow,
                ),
              ],
            ),
            child: Icon(
              isRecording ? Icons.stop : Icons.mic,
              color: Colors.white,
              size: 42,
            ),
          ),
        );
      },
    ).animate().scale(
          begin: const Offset(0.8, 0.8),
          duration: 400.ms,
          curve: Curves.easeOutBack,
        );
  }

  Widget _buildProcessingRing() {
    return AnimatedBuilder(
      animation: _spinController,
      builder: (_, child) => Transform.rotate(
        angle: _spinController.value * 2 * math.pi,
        child: child,
      ),
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: SweepGradient(
            colors: [
              AppColors.primary,
              AppColors.secondary,
              AppColors.primary.withValues(alpha: 0),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 24,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
            ),
            child: const Icon(Icons.auto_awesome,
                color: AppColors.primary, size: 36),
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _Chip(
                label: _mockResult.category,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              _Chip(
                label: _mockResult.urgency,
                color: const Color(0xFFEF4444),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: _mockResult.location,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.people_outline,
            label: 'People Affected',
            value: '${_mockResult.people} individuals',
          ),
          const SizedBox(height: 16),
          Text(
            'Transcription',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 6),
          Text(
            _mockResult.transcription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 20),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _reRecord,
                  child: Container(
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: Text('Re-record',
                          style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: _submit,
                  child: Container(
                    height: 48,
                    decoration: AppColors.gradientBoxDecoration(
                        borderRadius: 12),
                    child: const Center(
                      child: Text('Submit Report',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.15, duration: 400.ms, curve: Curves.easeOut);
  }

  Widget _buildSuccess(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success.withValues(alpha: 0.15),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  size: 56,
                  color: Color(0xFF22C55E),
                ),
              )
                  .animate()
                  .scale(
                    begin: const Offset(0.3, 0.3),
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 300.ms),
              const SizedBox(height: 24),
              Text(
                'Report Submitted!',
                style: Theme.of(context).textTheme.headlineSmall,
              ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
              const SizedBox(height: 8),
              Text(
                'Your field report has been structured and\nqueued for NGO review.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ).animate().fadeIn(delay: 450.ms, duration: 400.ms),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: GestureDetector(
                  onTap: () => context.go('/field-worker'),
                  child: Container(
                    height: 52,
                    decoration:
                        AppColors.gradientBoxDecoration(borderRadius: 14),
                    child: const Center(
                      child: Text(
                        'Back to Home',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Language selector
// ---------------------------------------------------------------------------

class _LanguageSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _LanguageSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: _languages.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final isSelected = i == selected;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Text(
                _languages[i].$1,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helper widgets
// ---------------------------------------------------------------------------

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
