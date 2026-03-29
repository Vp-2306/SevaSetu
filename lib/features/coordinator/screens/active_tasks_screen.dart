import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../providers/coordinator_provider.dart';

class ActiveTasksScreen extends ConsumerWidget {
  const ActiveTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coord = ref.watch(coordinatorProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(AppStrings.activeTasks), automaticallyImplyLeading: false),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        itemCount: coord.activeNeeds.length,
        itemBuilder: (_, i) {
          final need = coord.activeNeeds[i];
          final color = AppColors.categoryColor(need.category);
          final statusColor = switch (need.status) {
            'assigned' => AppColors.primary,
            'in_progress' => AppColors.accent,
            'completed' => AppColors.success,
            _ => AppColors.warning,
          };
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(width: 36, height: 36,
                    decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                    child: Icon(AppColors.categoryIcon(need.category), size: 18, color: color)),
                  const SizedBox(width: 12),
                  Expanded(child: Text(need.description, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                    child: Text(need.status.replaceAll('_', ' '), style: AppTextStyles.labelSmall.copyWith(color: statusColor)),
                  ),
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.location_on, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(need.location.address, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
                  const Spacer(),
                  Icon(Icons.people, size: 14, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text('${need.estimatedCount}', style: AppTextStyles.labelSmall.copyWith(color: AppColors.textMuted)),
                ]),
              ]),
            ),
          ).animate(delay: (i * 80).ms).fadeIn(duration: 400.ms).slideY(begin: 0.05);
        },
      ),
    );
  }
}
