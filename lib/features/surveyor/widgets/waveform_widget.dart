import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class WaveformWidget extends StatefulWidget {
  final bool isRecording;
  const WaveformWidget({super.key, required this.isRecording});
  @override
  State<WaveformWidget> createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 150))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: Size(double.infinity, 120),
          painter: _WaveformPainter(
            isRecording: widget.isRecording,
            random: _random,
          ),
        );
      },
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final bool isRecording;
  final Random random;

  _WaveformPainter({required this.isRecording, required this.random});

  @override
  void paint(Canvas canvas, Size size) {
    final barCount = 30;
    final barWidth = size.width / (barCount * 2);
    final maxHeight = size.height * 0.8;
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final height = isRecording
          ? maxHeight * (0.2 + random.nextDouble() * 0.8)
          : maxHeight * 0.3;

      final x = (i * 2 + 0.5) * barWidth;
      final gradient = LinearGradient(
        colors: [AppColors.primary, AppColors.secondary],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

      final rect = Rect.fromCenter(
        center: Offset(x, centerY),
        width: barWidth * 0.7,
        height: height,
      );

      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(barWidth * 0.35)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) => isRecording;
}
