import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/primary_button.dart';
import '../providers/volunteer_provider.dart';

class TaskDetailScreen extends ConsumerWidget {
  final String taskId;
  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vol = ref.watch(volunteerProvider);
    final task = vol.matchedTasks.where((t) => t.id == taskId).firstOrNull ??
        vol.completedTasksList.where((t) => t.id == taskId).firstOrNull;
    if (task == null) {
      return Scaffold(backgroundColor: AppColors.background,
          body: Center(child: Text('Task not found', style: AppTextStyles.bodyLarge)));
    }
    final color = AppColors.categoryColor(task.category);
    final canCancel = task.status == 'assigned' && task.scheduledFor != null &&
        task.scheduledFor!.difference(DateTime.now()).inHours > 3;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => context.pop()),
        title: const Text('Task Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 16),
          // Category + Urgency header
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(AppColors.categoryIcon(task.category), size: 16, color: color),
                const SizedBox(width: 6),
                Text(task.category[0].toUpperCase() + task.category.substring(1),
                  style: AppTextStyles.labelLarge.copyWith(color: color)),
              ]),
            ),
            const SizedBox(width: 8),
            if (task.isUrgent) Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.danger.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
              child: Text(AppStrings.urgent, style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.danger, fontWeight: FontWeight.w700)),
            ),
          ]).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 16),
          Text(task.description, style: AppTextStyles.headlineMedium)
              .animate().fadeIn(duration: 400.ms, delay: 100.ms),
          const SizedBox(height: 24),
          _DetailRow(icon: Icons.location_on, label: task.location.address, color: AppColors.accent),
          _DetailRow(icon: Icons.people, label: '${task.estimatedCount} people affected', color: AppColors.primary),
          if (task.scheduledFor != null)
            _DetailRow(icon: Icons.schedule, label: _formatDate(task.scheduledFor!), color: AppColors.secondary),
          _DetailRow(icon: Icons.signal_cellular_alt, label: 'Urgency: ${task.urgency}/5',
            color: task.urgency >= 4 ? AppColors.danger : AppColors.warning),
          const SizedBox(height: 16),
          if (task.requiredSkills.isNotEmpty) ...[
            Text('Skills Required', style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: task.requiredSkills.map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border)),
              child: Text(s, style: AppTextStyles.labelSmall),
            )).toList()),
          ],
          const SizedBox(height: 40),
          if (task.status == 'open')
            PrimaryButton(text: AppStrings.acceptTask, icon: Icons.check_circle_outline,
              onPressed: () {
                ref.read(volunteerProvider).acceptTask(task.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Task accepted! 🎉')));
                context.pop();
              }),
          if (canCancel) ...[
            const SizedBox(height: 12),
            PrimaryButton(text: AppStrings.cancelTask, isOutlined: true, color: AppColors.danger,
              onPressed: () => _showCancelDialog(context, ref, task.id)),
          ],
          const SizedBox(height: 32),
        ]),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, WidgetRef ref, String taskId) {
    showDialog(context: context, builder: (_) => AlertDialog(
      title: Text(AppStrings.cancelTask),
      content: Text(AppStrings.cancelWarning),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.cancel)),
        TextButton(
          onPressed: () {
            ref.read(volunteerProvider).cancelTask(taskId);
            Navigator.pop(context);
            context.pop();
          },
          child: Text(AppStrings.confirm, style: TextStyle(color: AppColors.danger)),
        ),
      ],
    ));
  }

  String _formatDate(DateTime dt) {
    final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${dt.day} ${months[dt.month-1]} ${dt.year}, ${dt.hour}:${dt.minute.toString().padLeft(2,'0')}';
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _DetailRow({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
      ]),
    );
  }
}
