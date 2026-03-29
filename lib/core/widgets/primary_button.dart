import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? color;
  final List<Color>? gradientColors;
  final double height;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.color,
    this.gradientColors,
    this.height = 52,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isOutlined) {
      return SizedBox(
        width: double.infinity,
        height: widget.height,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: OutlinedButton(
              onPressed: widget.isLoading ? null : widget.onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: widget.color ?? AppColors.primary),
                foregroundColor: widget.color ?? AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _buildChild(widget.color ?? AppColors.primary),
            ),
          ),
        ),
      );
    }

    final gradColors = widget.gradientColors ??
        (widget.color != null
            ? [widget.color!, widget.color!.withValues(alpha: 0.8)]
            : AppColors.gradientPrimary);

    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: widget.onPressed == null
                    ? [AppColors.textMuted, AppColors.textMuted]
                    : gradColors,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: widget.onPressed != null
                  ? [
                      BoxShadow(
                        color: gradColors.first.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : null,
            ),
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _buildChild(Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChild(Color textColor) {
    if (widget.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }
    if (widget.icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.icon, size: 20, color: textColor),
          const SizedBox(width: 8),
          Text(
            widget.text,
            style: AppTextStyles.labelLarge.copyWith(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
    return Text(
      widget.text,
      style: AppTextStyles.labelLarge.copyWith(
        color: textColor,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
