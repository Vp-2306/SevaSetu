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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text(
                isCoordinator ? 'Coordinator Login' : 'Welcome Back',
                style: AppTextStyles.headlineLarge,
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 8),
              Text(
                isCoordinator
                    ? 'Sign in with your NGO email'
                    : 'Sign in with your phone number',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
              const SizedBox(height: 40),
              if (isCoordinator) ...[
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: AppTextStyles.bodyLarge,
                  decoration: const InputDecoration(
                    hintText: AppStrings.enterEmail,
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: AppTextStyles.bodyLarge,
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
                    style: AppTextStyles.bodyLarge,
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
                    style: AppTextStyles.bodyLarge,
                    maxLength: 6,
                    decoration: const InputDecoration(
                      hintText: AppStrings.enterOtp,
                      prefixIcon: Icon(Icons.pin_outlined),
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                ],
              ],
              const SizedBox(height: 32),
              PrimaryButton(
                text: isCoordinator
                    ? AppStrings.login
                    : (_otpSent ? AppStrings.verifyOtp : AppStrings.sendOtp),
                isLoading: auth.isLoading,
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
                    ),
                  ),
                ),
              ),
              if (auth.error != null) ...[
                const SizedBox(height: 16),
                Text(
                  auth.error!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.danger,
                  ),
                ),
              ],
            ],
          ),
        ),
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
