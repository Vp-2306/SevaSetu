import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_bottom_nav.dart';
import '../widgets/task_card.dart';
import '../widgets/streak_banner.dart';
import '../providers/volunteer_provider.dart';
import 'heatmap_screen.dart';
import 'my_credits_screen.dart';
import 'my_profile_screen.dart';

class VolunteerHomeScreen extends ConsumerWidget {
  const VolunteerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(volunteerTabIndexProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: tabIndex, children: [
        _VolunteerDashboard(),
        const HeatmapScreen(),
        const MyCreditsScreen(),
        const MyProfileScreen(),
      ]),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: tabIndex,
        onTap: (i) => ref.read(volunteerTabIndexProvider.notifier).state = i,
        items: const [
          BottomNavItem(icon: Icons.task_alt, label: 'Tasks'),
          BottomNavItem(icon: Icons.map_outlined, label: 'Heatmap'),
          BottomNavItem(icon: Icons.stars, label: 'Credits'),
          BottomNavItem(icon: Icons.person_outline, label: 'Profile'),
        ],
      ),
    );
  }
}

class _VolunteerDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vol = ref.watch(volunteerProvider);
    final profile = vol.profile;
    final filters = [AppStrings.all, AppStrings.food, AppStrings.health, AppStrings.education, AppStrings.shelter];

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient header
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.gradientVolunteer,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            profile.initials,
                            style: AppTextStyles.labelLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hi, ${profile.name.split(' ').first}!',
                              style: AppTextStyles.titleLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Row(children: [
                              Icon(Icons.local_fire_department,
                                  size: 14, color: Colors.amber.shade300),
                              const SizedBox(width: 4),
                              Text(
                                '${AppStrings.credits}: ${profile.credits}',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                  if (profile.streakDays > 0) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(children: [
                        const Text('🔥', style: TextStyle(fontSize: 18)),
                        const SizedBox(width: 8),
                        Text(
                          '${profile.streakDays}-day streak! Keep going!',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ]),
                    ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Urgent banner
                  if (vol.matchedTasks.any((t) => t.urgency >= 5))
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.dangerLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.danger.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(children: [
                        Icon(Icons.warning, color: AppColors.danger, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${AppStrings.urgent} need nearby — tap to help',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.danger,
                            ),
                          ),
                        ),
                      ]),
                    ).animate().fadeIn().shimmer(
                          duration: 2000.ms,
                          color: AppColors.danger.withValues(alpha: 0.2),
                        ),
                  // Filter chips
                  Row(children: [
                    Text(AppStrings.tasksMatchedForYou, style: AppTextStyles.titleLarge),
                    const Spacer(),
                    Icon(Icons.filter_list, color: AppColors.textMuted, size: 20),
                  ]),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: filters.map((f) {
                        final selected = f == vol.selectedFilter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: GestureDetector(
                            onTap: () => ref.read(volunteerProvider).setFilter(f),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: selected
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                f,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: selected
                                      ? Colors.white
                                      : AppColors.textMuted,
                                  fontWeight: selected
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tasks list
                  if (vol.matchedTasks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48),
                      child: Center(
                        child: Column(children: [
                          Icon(Icons.search_off,
                              size: 64, color: AppColors.textMuted),
                          const SizedBox(height: 16),
                          Text(
                            AppStrings.noTasksMatch,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ]),
                      ),
                    )
                  else
                    ...List.generate(
                      vol.matchedTasks.length,
                      (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TaskCard(
                          need: vol.matchedTasks[i],
                          onAccept: () => ref
                              .read(volunteerProvider)
                              .acceptTask(vol.matchedTasks[i].id),
                          onTap: () => context.push(
                              '/volunteer/task/${vol.matchedTasks[i].id}'),
                        ),
                      ).animate(delay: (i * 80).ms).fadeIn(duration: 400.ms).slideY(begin: 0.05),
                    ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
