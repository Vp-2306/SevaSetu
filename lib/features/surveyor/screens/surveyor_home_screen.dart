import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_bottom_nav.dart';
import '../widgets/survey_card.dart';
import '../providers/surveyor_provider.dart';
import 'survey_history_screen.dart';
import '../../../features/volunteer/screens/my_profile_screen.dart';

class SurveyorHomeScreen extends ConsumerWidget {
  const SurveyorHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(surveyorTabIndexProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: tabIndex,
        children: [
          _SurveyorDashboard(),
          const SurveyHistoryScreen(),
          const MyProfileScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: tabIndex,
        onTap: (i) => ref.read(surveyorTabIndexProvider.notifier).state = i,
        items: const [
          BottomNavItem(icon: Icons.home_outlined, label: 'Home'),
          BottomNavItem(icon: Icons.history, label: 'History'),
          BottomNavItem(icon: Icons.person_outline, label: 'Profile'),
        ],
      ),
    );
  }
}

class _SurveyorDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surveyor = ref.watch(surveyorProvider);
    final now = DateTime.now();
    final greeting = now.hour < 12 ? 'Good morning' : (now.hour < 17 ? 'Good afternoon' : 'Good evening');

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$greeting, Arjun', style: AppTextStyles.headlineMedium)
                          .animate().fadeIn(duration: 400.ms),
                      Text(DateFormat('EEEE, d MMMM yyyy').format(now),
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(
                          color: AppColors.success, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text(AppStrings.synced, style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.success)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Stats row
              Row(
                children: [
                  _StatCard(label: AppStrings.today, value: '${surveyor.todayCount}', color: AppColors.primary),
                  const SizedBox(width: 12),
                  _StatCard(label: AppStrings.thisWeek, value: '${surveyor.weekCount}', color: AppColors.accent),
                  const SizedBox(width: 12),
                  _StatCard(label: AppStrings.pendingReview, value: '${surveyor.pendingCount}', color: AppColors.warning),
                ].animate(interval: 80.ms).fadeIn(duration: 400.ms).slideY(begin: 0.05),
              ),
              const SizedBox(height: 24),
              // Big action card
              GestureDetector(
                onTap: () => context.push(AppRoutes.newSurvey),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.startNewSurvey, style: AppTextStyles.titleLarge.copyWith(color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(AppStrings.voicePhotoOrManual, style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.8))),
                      const SizedBox(height: 16),
                      Row(children: [
                        Icon(Icons.mic, color: Colors.white.withValues(alpha: 0.9), size: 28),
                        const SizedBox(width: 12),
                        Icon(Icons.camera_alt, color: Colors.white.withValues(alpha: 0.9), size: 28),
                        const SizedBox(width: 12),
                        Icon(Icons.edit_note, color: Colors.white.withValues(alpha: 0.9), size: 28),
                      ]),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.05),
              const SizedBox(height: 32),
              Text(AppStrings.recentSurveys, style: AppTextStyles.titleLarge),
              const SizedBox(height: 16),
              ...List.generate(surveyor.surveys.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SurveyCard(survey: surveyor.surveys[index]),
                ).animate(delay: (index * 80).ms).fadeIn(duration: 400.ms).slideY(begin: 0.05);
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(value, style: AppTextStyles.headlineLarge.copyWith(color: color)),
            const SizedBox(height: 4),
            Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted),
              textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
