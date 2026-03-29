import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class HeatmapScreen extends StatelessWidget {
  const HeatmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Phase 2: Replace with google_maps_flutter widget
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Need Heatmap'), automaticallyImplyLeading: false),
      body: Stack(children: [
        // Placeholder map
        Container(
          width: double.infinity, height: double.infinity,
          color: const Color(0xFF0D1117),
          child: CustomPaint(painter: _MockMapPainter()),
        ),
        // Legend
        Positioned(top: 16, left: 16, right: 16, child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(color: AppColors.surface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _LegendItem(color: AppColors.danger, label: 'Critical'),
            _LegendItem(color: AppColors.warning, label: 'Moderate'),
            _LegendItem(color: AppColors.success, label: 'Resolved'),
          ]),
        ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1)),
        // Zone info panels
        Positioned(left: 60, top: 180, child: _ZoneCircle(color: AppColors.danger, size: 100, label: 'Dharavi', count: 5)),
        Positioned(right: 80, top: 250, child: _ZoneCircle(color: AppColors.warning, size: 70, label: 'Bandra', count: 2)),
        Positioned(left: 100, bottom: 280, child: _ZoneCircle(color: AppColors.success, size: 55, label: 'Andheri', count: 0)),
        Positioned(right: 60, bottom: 200, child: _ZoneCircle(color: AppColors.warning, size: 80, label: 'Kurla', count: 3)),
        // My location button
        Positioned(right: 16, top: 80, child: Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: AppColors.surface, shape: BoxShape.circle,
            border: Border.all(color: AppColors.border)),
          child: const Icon(Icons.my_location, color: AppColors.primary),
        )),
        // Bottom panel
        Positioned(left: 0, right: 0, bottom: 0, child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            border: const Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(
              color: AppColors.textMuted, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _ZoneStat(label: 'Zones', value: '4', color: AppColors.primary),
              _ZoneStat(label: 'Open Needs', value: '10', color: AppColors.danger),
              _ZoneStat(label: 'Resolved', value: '7', color: AppColors.success),
            ]),
          ]),
        ).animate().fadeIn(duration: 400.ms, delay: 300.ms).slideY(begin: 0.2)),
      ]),
    );
  }
}

class _MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFF1A1F2E)..style = PaintingStyle.stroke..strokeWidth = 0.5;
    // Draw grid lines as mock map
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ZoneCircle extends StatelessWidget {
  final Color color;
  final double size;
  final String label;
  final int count;
  const _ZoneCircle({required this.color, required this.size, required this.label, required this.count});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.2),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 2),
        ),
        child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(label, style: AppTextStyles.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
          if (count > 0) Text('$count', style: AppTextStyles.labelSmall.copyWith(color: color)),
        ])),
      ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.5, 0.5)),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendItem({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
    ]);
  }
}

class _ZoneStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _ZoneStat({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: AppTextStyles.headlineLarge.copyWith(color: color)),
      Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
    ]);
  }
}
