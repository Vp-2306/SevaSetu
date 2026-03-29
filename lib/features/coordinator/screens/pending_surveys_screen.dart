import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_routes.dart';
import '../widgets/need_approval_card.dart';
import '../providers/coordinator_provider.dart';

class PendingSurveysScreen extends ConsumerWidget {
  const PendingSurveysScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coord = ref.watch(coordinatorProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, title: Text(AppStrings.surveys), automaticallyImplyLeading: false),
      body: coord.pendingSurveys.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.check_circle_outline, size: 64, color: AppColors.success),
              const SizedBox(height: 16),
              Text('All caught up!', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: coord.pendingSurveys.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: NeedApprovalCard(
                  survey: coord.pendingSurveys[i],
                  onTap: () => context.push('${AppRoutes.coordinatorReview}/${coord.pendingSurveys[i].id}'),
                ),
              ).animate(delay: (i * 80).ms).fadeIn(duration: 400.ms).slideY(begin: 0.05),
            ),
    );
  }
}
