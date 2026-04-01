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
    final greeting = now.hour < 12
        ? 'Good morning'
        : (now.hour < 17 ? 'Good afternoon' : 'Good evening');

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gradient header
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppColors.gradientSurveyor,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$greeting, Arjun',
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: Colors.white,
                              ),
                            ).animate().fadeIn(duration: 400.ms),
                            Text(
                              DateFormat('EEEE, d MMMM yyyy').format(now),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4ADE80),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                AppStrings.synced,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Stats row on header
                    Row(
                      children: [
                        _StatChip(
                          label: AppStrings.today,
                          value: '${surveyor.todayCount}',
                        ),
                        const SizedBox(width: 10),
                        _StatChip(
                          label: AppStrings.thisWeek,
                          value: '${surveyor.weekCount}',
                        ),
                        const SizedBox(width: 10),
                        _StatChip(
                          label: AppStrings.pendingReview,
                          value: '${surveyor.pendingCount}',
                          highlight: true,
                        ),
                      ],
                    ).animate(delay: 80.ms).fadeIn(duration: 400.ms),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Big action card
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.newSurvey),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [AppColors.cardShadow],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: AppColors.gradientSurveyor,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.add_circle_outline,
                                  color: Colors.white, size: 26),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppStrings.startNewSurvey,
                                    style: AppTextStyles.labelLarge.copyWith(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    AppStrings.voicePhotoOrManual,
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(children: [
                                    _MethodPill(icon: Icons.mic, label: 'Voice'),
                                    const SizedBox(width: 6),
                                    _MethodPill(icon: Icons.camera_alt, label: 'Photo'),
                                    const SizedBox(width: 6),
                                    _MethodPill(icon: Icons.edit_note, label: 'Manual'),
                                  ]),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right,
                                color: AppColors.textMuted),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms).slideY(begin: 0.05),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppStrings.recentSurveys, style: AppTextStyles.titleLarge),
                        Text(
                          'View All',
                          style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.accent),
                        ),
                      ],
                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _StatChip({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: highlight
              ? Colors.white.withValues(alpha: 0.25)
              : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: highlight
              ? Border.all(color: Colors.white.withValues(alpha: 0.5))
              : null,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.headlineMedium.copyWith(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
            Text(
              label,
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MethodPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.textSecondary),
          const SizedBox(width: 3),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
