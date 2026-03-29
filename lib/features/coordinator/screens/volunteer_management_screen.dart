import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/coordinator_provider.dart';

class VolunteerManagementScreen extends ConsumerWidget {
  const VolunteerManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coord = ref.watch(coordinatorProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(AppStrings.volunteerManagement), automaticallyImplyLeading: false),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: coord.volunteers.length,
        itemBuilder: (_, i) {
          final v = coord.volunteers[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border)),
              child: Row(children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                  child: Center(child: Text(v.initials,
                    style: AppTextStyles.labelLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w700))),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(v.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                    if (v.isVerified) ...[
                      const SizedBox(width: 4),
                      Icon(Icons.verified, size: 14, color: AppColors.primary),
                    ],
                  ]),
                  const SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.star, size: 14, color: AppColors.warning),
                    Text(' ${v.rating}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
                    const SizedBox(width: 12),
                    Icon(Icons.task_alt, size: 14, color: AppColors.success),
                    Text(' ${v.completedTasks} done', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
                    const SizedBox(width: 12),
                    if (v.streakDays > 0) ...[
                      Text('🔥 ${v.streakDays}', style: AppTextStyles.labelSmall),
                    ],
                  ]),
                  const SizedBox(height: 6),
                  Wrap(spacing: 4, children: v.skills.take(3).map((s) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(4)),
                    child: Text(s, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted, fontSize: 10)),
                  )).toList()),
                ])),
                Column(children: [
                  Text('${v.credits}', style: AppTextStyles.titleLarge.copyWith(fontSize: 18, color: AppColors.warning)),
                  Text('credits', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
                ]),
              ]),
            ),
          ).animate(delay: (i * 80).ms).fadeIn(duration: 400.ms).slideY(begin: 0.05);
        },
      ),
    );
  }
}
