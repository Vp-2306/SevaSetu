import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/volunteer_provider.dart';

class AvailabilityScreen extends ConsumerStatefulWidget {
  const AvailabilityScreen({super.key});
  @override
  ConsumerState<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends ConsumerState<AvailabilityScreen> {
  late List<String> _selectedDays;
  late List<String> _selectedSlots;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(volunteerProvider).profile;
    _selectedDays = List.from(profile.availableDays);
    _selectedSlots = List.from(profile.availableTimeSlots);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(AppStrings.selectAvailability)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 24),
            Text('Select Days', style: AppTextStyles.titleLarge).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 16),
            Wrap(spacing: 8, runSpacing: 8, children: AppStrings.weekDays.map((day) {
              final selected = _selectedDays.contains(day);
              return GestureDetector(
                onTap: () => setState(() {
                  selected ? _selectedDays.remove(day) : _selectedDays.add(day);
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: selected ? AppColors.primary : AppColors.border)),
                  child: Center(child: Text(day, style: AppTextStyles.labelLarge.copyWith(
                    color: selected ? Colors.white : AppColors.textMuted))),
                ),
              );
            }).toList()),
            const SizedBox(height: 32),
            Text('Select Time Slots', style: AppTextStyles.titleLarge),
            const SizedBox(height: 16),
            ...AppStrings.timeSlots.map((slot) {
              final selected = _selectedSlots.contains(slot.toLowerCase());
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => setState(() {
                    final key = slot.toLowerCase();
                    selected ? _selectedSlots.remove(key) : _selectedSlots.add(key);
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: selected ? AppColors.primary : AppColors.border)),
                    child: Row(children: [
                      Icon(selected ? Icons.check_circle : Icons.circle_outlined,
                        color: selected ? AppColors.primary : AppColors.textMuted),
                      const SizedBox(width: 12),
                      Text(slot, style: AppTextStyles.bodyLarge.copyWith(
                        color: selected ? AppColors.textPrimary : AppColors.textMuted)),
                    ]),
                  ),
                ),
              );
            }),
            const Spacer(),
            PrimaryButton(text: AppStrings.save, onPressed: () {
              ref.read(volunteerProvider).updateAvailability(_selectedDays, _selectedSlots);
              Navigator.pop(context);
            }),
            const SizedBox(height: 24),
          ]),
        ),
      ),
    );
  }
}
