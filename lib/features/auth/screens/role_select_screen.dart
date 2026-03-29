import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/auth_provider.dart';

class RoleSelectScreen extends ConsumerWidget {
  const RoleSelectScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = [
      _RoleData(
        icon: Icons.camera_alt_rounded,
        gradientColors: AppColors.gradientSurveyor,
        title: AppStrings.fieldSurveyor,
        subtitle: AppStrings.surveyorSubtitle,
        features: ['Voice & photo surveys', 'AI data extraction', 'Offline capable'],
        role: 'surveyor',
      ),
      _RoleData(
        icon: Icons.volunteer_activism_rounded,
        gradientColors: AppColors.gradientVolunteer,
        title: AppStrings.volunteer,
        subtitle: AppStrings.volunteerSubtitle,
        features: ['Skill-matched tasks', 'Credits & streaks', 'Impact certificate'],
        role: 'volunteer',
      ),
      _RoleData(
        icon: Icons.dashboard_rounded,
        gradientColors: AppColors.gradientCoordinator,
        title: AppStrings.ngoCoordinator,
        subtitle: AppStrings.coordinatorSubtitle,
        features: ['Review surveys', 'Assign volunteers', 'Analytics dashboard'],
        role: 'coordinator',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              Text(
                'Welcome to',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ).animate().fadeIn(duration: 400.ms),
              Text(
                AppStrings.appName,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 50.ms),
              const SizedBox(height: 8),
              Text(
                AppStrings.selectRole,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              const SizedBox(height: 32),
              ...List.generate(roles.length, (index) {
                final role = roles[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _RoleCard(
                    data: role,
                    onTap: () {
                      ref.read(authProvider).selectRole(role.role);
                      context.push(AppRoutes.login, extra: role.role);
                    },
                  ),
                ).animate(delay: (100 * (index + 1)).ms)
                    .fadeIn(duration: 400.ms)
                    .slideY(begin: 0.1, end: 0);
              }),
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () => context.push(AppRoutes.login, extra: 'volunteer'),
                  child: RichText(
                    text: TextSpan(
                      text: AppStrings.alreadyHaveAccount,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: AppStrings.signIn,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleData {
  final IconData icon;
  final List<Color> gradientColors;
  final String title;
  final String subtitle;
  final List<String> features;
  final String role;

  const _RoleData({
    required this.icon,
    required this.gradientColors,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.role,
  });
}

class _RoleCard extends StatelessWidget {
  final _RoleData data;
  final VoidCallback onTap;

  const _RoleCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
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
                  gradient: LinearGradient(
                    colors: data.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(data.icon, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: data.features.map((f) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          f,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      )).toList(),
                    ),
                  ],
                ),
              ),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: data.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chevron_right, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
