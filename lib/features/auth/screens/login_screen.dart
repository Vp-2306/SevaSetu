import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _otpSent = false;
  final _otpController = TextEditingController();

  bool get isCoordinator => widget.role == 'coordinator';

  List<Color> get _gradientColors {
    switch (widget.role) {
      case 'surveyor':
        return AppColors.gradientSurveyor;
      case 'coordinator':
        return AppColors.gradientCoordinator;
      default:
        return AppColors.gradientVolunteer;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Gradient header
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isCoordinator ? 'Coordinator Login' : 'Welcome Back',
                            style: AppTextStyles.headlineLarge.copyWith(
                              color: Colors.white,
                            ),
                          ).animate().fadeIn(duration: 400.ms),
                          const SizedBox(height: 6),
                          Text(
                            isCoordinator
                                ? 'Sign in with your NGO email'
                                : 'Sign in with your phone number',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Form card
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [AppColors.cardShadow],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isCoordinator) ...[
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          hintText: AppStrings.enterEmail,
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                        decoration: const InputDecoration(
                          hintText: AppStrings.enterPassword,
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                      ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                    ] else ...[
                      if (!_otpSent) ...[
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            hintText: AppStrings.enterPhone,
                            prefixIcon: Icon(Icons.phone_outlined),
                            prefixText: '+91 ',
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                      ] else ...[
                        TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                          maxLength: 6,
                          decoration: const InputDecoration(
                            hintText: AppStrings.enterOtp,
                            prefixIcon: Icon(Icons.pin_outlined),
                          ),
                        ).animate().fadeIn(duration: 400.ms),
                      ],
                    ],
                    const SizedBox(height: 28),
                    PrimaryButton(
                      text: isCoordinator
                          ? AppStrings.login
                          : (_otpSent ? AppStrings.verifyOtp : AppStrings.sendOtp),
                      isLoading: auth.isLoading,
                      gradientColors: _gradientColors,
                      onPressed: () => _handleAuth(ref),
                    ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () => context.push(AppRoutes.register, extra: widget.role),
                        child: Text(
                          'New here? Create an account',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    if (auth.error != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.dangerLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, size: 16, color: AppColors.danger),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                auth.error!,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.danger,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAuth(WidgetRef ref) async {
    final auth = ref.read(authProvider);
    if (isCoordinator) {
      final success = await auth.loginWithEmail(
        _emailController.text,
        _passwordController.text,
      );
      if (success && mounted) {
        context.go(auth.getHomeRoute());
      }
    } else {
      if (!_otpSent) {
        setState(() => _otpSent = true);
      } else {
        final success = await auth.loginWithPhone(_phoneController.text);
        if (success && mounted) {
          context.go(auth.getHomeRoute());
        }
      }
    }
  }
}
