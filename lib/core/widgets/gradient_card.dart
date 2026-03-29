import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GradientCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final List<Color> gradientColors;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const GradientCard({
    super.key,
    required this.child,
    required this.gradientColors,
    this.onTap,
    this.borderRadius = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppColors.border),
            boxShadow: [AppColors.cardShadow],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(borderRadius),
                    bottomLeft: Radius.circular(borderRadius),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: padding ?? const EdgeInsets.all(16),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
