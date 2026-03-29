import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/volunteer_provider.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vol = ref.watch(volunteerProvider);
    final profile = vol.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppStrings.profile),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(children: [
          const SizedBox(height: 24),
          // Avatar
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
            child: Center(child: Text(profile.initials,
              style: AppTextStyles.headlineLarge.copyWith(color: Colors.white))),
          ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.8, 0.8)),
          const SizedBox(height: 16),
          Text(profile.name, style: AppTextStyles.headlineMedium),
          const SizedBox(height: 4),
          if (profile.isVerified)
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.verified, size: 16, color: AppColors.primary),
              const SizedBox(width: 4),
              Text('Verified Volunteer', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
            ]),
          const SizedBox(height: 32),
          // Stats row
          Row(children: [
            _StatItem(label: 'Tasks', value: '${profile.completedTasks}', icon: Icons.task_alt),
            _StatItem(label: 'Credits', value: '${profile.credits}', icon: Icons.stars),
            _StatItem(label: 'Rating', value: profile.rating.toStringAsFixed(1), icon: Icons.star),
            _StatItem(label: 'Streak', value: '${profile.streakDays}', icon: Icons.local_fire_department),
          ]).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          const SizedBox(height: 32),
          // Skills
          _SectionHeader(title: 'Skills'),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: profile.skills.map((s) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.primary.withValues(alpha: 0.3))),
            child: Text(s, style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
          )).toList()),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Availability'),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: profile.availableDays.map((d) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.accent.withValues(alpha: 0.3))),
            child: Text(d, style: AppTextStyles.labelLarge.copyWith(color: AppColors.accent)),
          )).toList()),
          const SizedBox(height: 40),
        ]),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border)),
      child: Column(children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.titleLarge.copyWith(fontSize: 18)),
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
      ]),
    ));
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: Text(title, style: AppTextStyles.titleLarge),
  );
}
