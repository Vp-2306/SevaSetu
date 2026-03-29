import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../widgets/credit_badge.dart';
import '../providers/volunteer_provider.dart';

class MyCreditsScreen extends ConsumerWidget {
  const MyCreditsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vol = ref.watch(volunteerProvider);
    final profile = vol.profile;
    final milestones = [
      (100, 'Starter', Icons.emoji_events, AppColors.textMuted),
      (250, 'Bronze', Icons.emoji_events, const Color(0xFFCD7F32)),
      (500, 'Silver', Icons.emoji_events, const Color(0xFFC0C0C0)),
      (1000, 'Gold', Icons.emoji_events, const Color(0xFFFFD700)),
    ];
    final currentMilestone = milestones.lastWhere((m) => profile.credits >= m.$1, orElse: () => milestones[0]);
    final nextMilestone = milestones.firstWhere((m) => profile.credits < m.$1, orElse: () => milestones.last);
    final progress = profile.credits / nextMilestone.$1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(AppStrings.myCredits), automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(children: [
          const SizedBox(height: 16),
          // Total credits
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: profile.credits),
            duration: const Duration(milliseconds: 1500),
            builder: (_, value, __) => Text('$value',
              style: AppTextStyles.displayLarge.copyWith(color: AppColors.warning)),
          ).animate().fadeIn(duration: 400.ms),
          Text(AppStrings.totalCredits, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          // Progress bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${currentMilestone.$2} → ${nextMilestone.$2}', style: AppTextStyles.labelLarge),
                Text('${profile.credits}/${nextMilestone.$1}', style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textMuted)),
              ]),
              const SizedBox(height: 8),
              ClipRRect(borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: progress.clamp(0.0, 1.0),
                  backgroundColor: AppColors.surfaceElevated, color: nextMilestone.$4, minHeight: 8)),
            ]),
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          const SizedBox(height: 24),
          // Impact Certificate
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradientVertical,
              borderRadius: BorderRadius.circular(16)),
            child: Column(children: [
              Icon(Icons.workspace_premium, size: 48, color: Colors.white.withValues(alpha: 0.9)),
              const SizedBox(height: 12),
              Text(AppStrings.yourImpactCertificate, style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
              const SizedBox(height: 4),
              Text(profile.name, style: AppTextStyles.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.8))),
              Text('${profile.completedTasks} tasks completed',
                style: AppTextStyles.labelSmall.copyWith(color: Colors.white.withValues(alpha: 0.6))),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                _SmallButton(label: AppStrings.downloadPdf, icon: Icons.download, onTap: () {}),
                const SizedBox(width: 12),
                _SmallButton(label: AppStrings.shareToLinkedIn, icon: Icons.share, onTap: () {}),
              ]),
            ]),
          ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
          const SizedBox(height: 24),
          // Completed tasks
          Align(alignment: Alignment.centerLeft,
            child: Text(AppStrings.completedTasks, style: AppTextStyles.titleLarge)),
          const SizedBox(height: 12),
          ...vol.completedTasksList.map((task) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border)),
            child: Row(children: [
              Container(width: 40, height: 40,
                decoration: BoxDecoration(
                  color: AppColors.categoryColor(task.category).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10)),
                child: Icon(AppColors.categoryIcon(task.category), size: 20,
                  color: AppColors.categoryColor(task.category)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(task.description, style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${_daysAgo(task.createdAt)}', style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.textMuted)),
              ])),
              CreditBadge(credits: 25),
            ]),
          )),
          // Streak calendar
          const SizedBox(height: 24),
          Align(alignment: Alignment.centerLeft, child: Text('Activity Streak', style: AppTextStyles.titleLarge)),
          const SizedBox(height: 12),
          _StreakCalendar(streakDays: profile.streakDays),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }

  String _daysAgo(DateTime dt) {
    final d = DateTime.now().difference(dt).inDays;
    return d == 0 ? 'Today' : '$d days ago';
  }
}

class _SmallButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _SmallButton({required this.label, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: Colors.white),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: Colors.white)),
      ]),
    ));
  }
}

class _StreakCalendar extends StatelessWidget {
  final int streakDays;
  const _StreakCalendar({required this.streakDays});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 4),
      itemCount: 28,
      itemBuilder: (_, i) {
        final isActive = i >= (28 - streakDays);
        return Container(
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary.withValues(alpha: 0.6) : AppColors.surface,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.border)),
        );
      },
    );
  }
}
