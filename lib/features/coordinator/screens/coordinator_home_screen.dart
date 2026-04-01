import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/widgets/custom_bottom_nav.dart';
import '../widgets/need_approval_card.dart';
import '../widgets/stats_card.dart';
import '../providers/coordinator_provider.dart';
import 'pending_surveys_screen.dart';
import 'active_tasks_screen.dart';
import 'volunteer_management_screen.dart';
import 'analytics_screen.dart';

class CoordinatorHomeScreen extends ConsumerWidget {
  const CoordinatorHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(coordinatorTabIndexProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(index: tabIndex, children: [
        _CoordinatorDashboard(),
        const PendingSurveysScreen(),
        const ActiveTasksScreen(),
        const VolunteerManagementScreen(),
        const AnalyticsScreen(),
      ]),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: tabIndex,
        onTap: (i) => ref.read(coordinatorTabIndexProvider.notifier).state = i,
        items: const [
          BottomNavItem(icon: Icons.dashboard_outlined, label: 'Dashboard'),
          BottomNavItem(icon: Icons.rate_review_outlined, label: 'Surveys'),
          BottomNavItem(icon: Icons.task_outlined, label: 'Tasks'),
          BottomNavItem(icon: Icons.people_outline, label: 'Volunteers'),
          BottomNavItem(icon: Icons.analytics_outlined, label: 'Analytics'),
        ],
      ),
    );
  }
}

class _CoordinatorDashboard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coord = ref.watch(coordinatorProvider);
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gradient header
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.gradientCoordinator,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SevaSetu NGO',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          Text(
                            'Dr. Garvit Surana',
                            style: AppTextStyles.headlineMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Badge(
                      label: Text(
                        '${coord.pendingSurveyCount}',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                      backgroundColor: AppColors.danger,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_outlined,
                            color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => _showCrisisDialog(context, ref),
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        AppStrings.crisis,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ]).animate().fadeIn(duration: 400.ms),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dashboard grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      StatsCard(
                        title: AppStrings.openNeeds,
                        value: '${coord.openNeedsCount}',
                        color: AppColors.primary,
                        icon: Icons.assignment,
                      ),
                      StatsCard(
                        title: AppStrings.pendingSurveyReviews,
                        value: '${coord.pendingSurveyCount}',
                        color: AppColors.warning,
                        icon: Icons.rate_review,
                      ),
                      StatsCard(
                        title: AppStrings.activeVolunteers,
                        value: '${coord.activeVolunteerCount}',
                        color: AppColors.success,
                        icon: Icons.people,
                      ),
                      StatsCard(
                        title: AppStrings.tasksCompletedWeek,
                        value: '${coord.completedThisWeek}',
                        color: AppColors.secondary,
                        icon: Icons.check_circle,
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                  const SizedBox(height: 28),
                  Text(AppStrings.surveysAwaitingReview, style: AppTextStyles.titleLarge),
                  const SizedBox(height: 16),
                  ...List.generate(coord.pendingSurveys.length, (i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: NeedApprovalCard(
                      survey: coord.pendingSurveys[i],
                      onTap: () => context.push(
                          '${AppRoutes.coordinatorReview}/${coord.pendingSurveys[i].id}'),
                    ),
                  ).animate(delay: (i * 80).ms).fadeIn(duration: 400.ms).slideY(begin: 0.05)),
                  const SizedBox(height: 28),
                  Text(AppStrings.recentActivity, style: AppTextStyles.titleLarge),
                  const SizedBox(height: 12),
                  ..._buildActivityFeed(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActivityFeed() {
    final activities = [
      ('Volunteer Priya accepted Task #34', Icons.check, AppColors.success, '2 min ago'),
      ('New survey submitted by Arjun', Icons.add_circle, AppColors.primary, '15 min ago'),
      ('Task #31 completed — Food distribution', Icons.celebration, AppColors.warning, '1 hr ago'),
      ('Volunteer Rahul started medical camp', Icons.play_arrow, AppColors.accent, '3 hrs ago'),
    ];
    return activities.map((a) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: a.$3.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(a.$2, size: 18, color: a.$3),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(a.$1, style: AppTextStyles.bodyMedium)),
        Text(a.$4,
            style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textMuted)),
      ]),
    )).toList();
  }

  void _showCrisisDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(children: [
          Icon(Icons.warning, color: AppColors.danger),
          const SizedBox(width: 8),
          Text(AppStrings.crisis),
        ]),
        content: Text(AppStrings.crisisConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Emergency broadcast sent to all volunteers!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            child: Text(AppStrings.confirm),
          ),
        ],
      ),
    );
  }
}
