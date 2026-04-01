import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final String role;
  const RegisterScreen({super.key, required this.role});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final List<String> _selectedSkills = [];
  final List<String> _selectedDays = [];
  final List<String> _selectedSlots = [];

  bool get isVolunteer => widget.role == 'volunteer';

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
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                padding: const EdgeInsets.fromLTRB(8, 8, 24, 24),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                    Text(
                      AppStrings.register,
                      style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: AppStrings.enterName,
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 16),
                  if (widget.role == 'coordinator') ...[
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: AppStrings.enterEmail,
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: AppStrings.enterPassword,
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                  ] else ...[
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        hintText: AppStrings.enterPhone,
                        prefixIcon: Icon(Icons.phone_outlined),
                        prefixText: '+91 ',
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                  ],
                  if (isVolunteer) ...[
                    const SizedBox(height: 32),
                    Text(
                      AppStrings.selectSkills,
                      style: AppTextStyles.titleLarge,
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppStrings.availableSkills.map((skill) {
                        final selected = _selectedSkills.contains(skill);
                        return FilterChip(
                          label: Text(skill),
                          selected: selected,
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                _selectedSkills.add(skill);
                              } else {
                                _selectedSkills.remove(skill);
                              }
                            });
                          },
                          selectedColor: AppColors.primary.withValues(alpha: 0.15),
                          checkmarkColor: AppColors.primary,
                        );
                      }).toList(),
                    ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
                    const SizedBox(height: 32),
                    Text(
                      AppStrings.selectAvailability,
                      style: AppTextStyles.titleLarge,
                    ).animate().fadeIn(duration: 400.ms, delay: 400.ms),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppStrings.weekDays.map((day) {
                        final selected = _selectedDays.contains(day);
                        return FilterChip(
                          label: Text(day),
                          selected: selected,
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                _selectedDays.add(day);
                              } else {
                                _selectedDays.remove(day);
                              }
                            });
                          },
                          selectedColor: AppColors.primary.withValues(alpha: 0.15),
                          checkmarkColor: AppColors.primary,
                        );
                      }).toList(),
                    ).animate().fadeIn(duration: 400.ms, delay: 500.ms),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: AppStrings.timeSlots.map((slot) {
                        final selected = _selectedSlots.contains(slot);
                        return FilterChip(
                          label: Text(slot),
                          selected: selected,
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                _selectedSlots.add(slot);
                              } else {
                                _selectedSlots.remove(slot);
                              }
                            });
                          },
                          selectedColor: AppColors.accent.withValues(alpha: 0.15),
                          checkmarkColor: AppColors.accent,
                        );
                      }).toList(),
                    ).animate().fadeIn(duration: 400.ms, delay: 600.ms),
                  ],
                  const SizedBox(height: 40),
                  PrimaryButton(
                    text: AppStrings.register,
                    isLoading: auth.isLoading,
                    gradientColors: _gradientColors,
                    onPressed: () => _handleRegister(ref),
                  ).animate().fadeIn(duration: 400.ms, delay: 700.ms),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRegister(WidgetRef ref) async {
    final auth = ref.read(authProvider);
    final success = await auth.register(
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (success && mounted) {
      context.go(auth.getHomeRoute());
    }
  }
}
