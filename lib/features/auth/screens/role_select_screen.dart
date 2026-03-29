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
        icon: Icons.camera_alt,
        color: AppColors.accent,
        title: AppStrings.fieldSurveyor,
        subtitle: AppStrings.surveyorSubtitle,
        role: 'surveyor',
      ),
      _RoleData(
        icon: Icons.volunteer_activism,
        color: AppColors.secondary,
        title: AppStrings.volunteer,
        subtitle: AppStrings.volunteerSubtitle,
        role: 'volunteer',
      ),
      _RoleData(
        icon: Icons.dashboard,
        color: AppColors.primary,
        title: AppStrings.ngoCoordinator,
        subtitle: AppStrings.coordinatorSubtitle,
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
              const SizedBox(height: 60),
              Text(
                AppStrings.whoAreYou,
                style: AppTextStyles.headlineLarge.copyWith(fontSize: 32),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 8),
              Text(
                AppStrings.selectRole,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              const SizedBox(height: 40),
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
  final Color color;
  final String title;
  final String subtitle;
  final String role;

  const _RoleData({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
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
        splashColor: AppColors.primary.withValues(alpha: 0.2),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: data.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(data.icon, color: data.color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.subtitle,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
