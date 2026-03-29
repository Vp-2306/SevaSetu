import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _dateRange = '7 days';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(AppStrings.analytics), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 16),
          // Date range picker
          Row(children: ['7 days', '30 days', 'Custom'].map((r) {
            final selected = r == _dateRange;
            return Padding(padding: const EdgeInsets.only(right: 8), child: GestureDetector(
              onTap: () => setState(() => _dateRange = r),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: selected ? AppColors.primary : AppColors.border)),
                child: Text(r, style: AppTextStyles.labelLarge.copyWith(
                  color: selected ? Colors.white : AppColors.textMuted)),
              ),
            ));
          }).toList()).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 32),
          // Line chart: needs submitted vs resolved
          Text('Needs: Submitted vs Resolved', style: AppTextStyles.titleLarge),
          const SizedBox(height: 16),
          Container(
            height: 220,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border)),
            child: LineChart(LineChartData(
              gridData: FlGridData(show: true,
                getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border, strokeWidth: 0.5),
                getDrawingVerticalLine: (_) => FlLine(color: AppColors.border, strokeWidth: 0.5)),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30,
                  getTitlesWidget: (v, _) => Text('${v.toInt()}', style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted)))),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 24,
                  getTitlesWidget: (v, _) {
                    final days = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
                    return Text(v.toInt() < days.length ? days[v.toInt()] : '',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted));
                  })),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [FlSpot(0,3),FlSpot(1,5),FlSpot(2,4),FlSpot(3,7),FlSpot(4,6),FlSpot(5,8),FlSpot(6,5)],
                  color: AppColors.primary, barWidth: 3, dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: AppColors.primary.withValues(alpha: 0.1)),
                ),
                LineChartBarData(
                  spots: [FlSpot(0,2),FlSpot(1,3),FlSpot(2,3),FlSpot(3,5),FlSpot(4,4),FlSpot(5,6),FlSpot(6,4)],
                  color: AppColors.success, barWidth: 3, dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: AppColors.success.withValues(alpha: 0.1)),
                ),
              ],
            )),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
          const SizedBox(height: 12),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            _LegendDot(color: AppColors.primary, label: 'Submitted'),
            const SizedBox(width: 24),
            _LegendDot(color: AppColors.success, label: 'Resolved'),
          ]),
          const SizedBox(height: 32),
          // Bar chart: by category
          Text('Needs by Category', style: AppTextStyles.titleLarge),
          const SizedBox(height: 16),
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border)),
            child: BarChart(BarChartData(
              gridData: FlGridData(show: true,
                getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border, strokeWidth: 0.5)),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30,
                  getTitlesWidget: (v, _) => Text('${v.toInt()}', style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.textMuted)))),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 24,
                  getTitlesWidget: (v, _) {
                    final cats = ['Food', 'Health', 'Edu', 'Shelter', 'Water'];
                    return Text(v.toInt() < cats.length ? cats[v.toInt()] : '',
                      style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted));
                  })),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                _bar(0, 12, AppColors.categoryFood),
                _bar(1, 8, AppColors.categoryHealth),
                _bar(2, 5, AppColors.categoryEducation),
                _bar(3, 7, AppColors.categoryShelter),
                _bar(4, 3, AppColors.categoryWater),
              ],
            )),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          const SizedBox(height: 32),
          // Volunteer stats
          Text('Volunteer Overview', style: AppTextStyles.titleLarge),
          const SizedBox(height: 12),
          Row(children: [
            _MiniStat(label: 'Total', value: '4', color: AppColors.primary),
            const SizedBox(width: 12),
            _MiniStat(label: 'Active', value: '3', color: AppColors.success),
            const SizedBox(width: 12),
            _MiniStat(label: 'Inactive', value: '1', color: AppColors.textMuted),
          ]).animate().fadeIn(duration: 400.ms, delay: 300.ms),
          const SizedBox(height: 32),
          // Export button
          OutlinedButton.icon(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Summary copied to clipboard!'))),
            icon: const Icon(Icons.ios_share),
            label: const Text('Export Summary'),
            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 48)),
          ),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  BarChartGroupData _bar(int x, double y, Color color) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(toY: y, color: color, width: 20,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
    ]);
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    const SizedBox(width: 6),
    Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondary)),
  ]);
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Expanded(child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border)),
    child: Column(children: [
      Text(value, style: AppTextStyles.headlineLarge.copyWith(color: color)),
      Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
    ]),
  ));
}
