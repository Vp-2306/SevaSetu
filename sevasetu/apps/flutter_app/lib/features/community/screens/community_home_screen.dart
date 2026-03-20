import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

// ---------------------------------------------------------------------------
// Need type
// ---------------------------------------------------------------------------

enum _NeedType { food, healthcare, education }

extension _NeedTypeExt on _NeedType {
  String get label {
    switch (this) {
      case _NeedType.food:
        return 'I need FOOD';
      case _NeedType.healthcare:
        return 'I need HEALTHCARE';
      case _NeedType.education:
        return 'I need EDUCATION';
    }
  }

  IconData get icon {
    switch (this) {
      case _NeedType.food:
        return Icons.restaurant;
      case _NeedType.healthcare:
        return Icons.local_hospital;
      case _NeedType.education:
        return Icons.menu_book;
    }
  }

  Color get color {
    switch (this) {
      case _NeedType.food:
        return const Color(0xFFEF4444);
      case _NeedType.healthcare:
        return const Color(0xFF3B82F6);
      case _NeedType.education:
        return const Color(0xFF22C55E);
    }
  }

  String get volunteerName {
    switch (this) {
      case _NeedType.food:
        return 'Sunita Rao';
      case _NeedType.healthcare:
        return 'Dr. Arjun Kumar';
      case _NeedType.education:
        return 'Meena Devi';
    }
  }
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class CommunityHomeScreen extends StatefulWidget {
  const CommunityHomeScreen({super.key});

  @override
  State<CommunityHomeScreen> createState() => _CommunityHomeScreenState();
}

class _CommunityHomeScreenState extends State<CommunityHomeScreen> {
  _NeedType? _loadingType;
  _NeedType? _confirmedType;
  int _etaSeconds = 300; // 5 minutes countdown
  Timer? _etaTimer;
  int? _pressedIndex;

  @override
  void dispose() {
    _etaTimer?.cancel();
    super.dispose();
  }

  Future<void> _onNeedTap(_NeedType type) async {
    await HapticFeedback.heavyImpact();
    setState(() => _loadingType = type);

    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    _etaTimer?.cancel();
    _etaSeconds = 300;
    _etaTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_etaSeconds > 0) {
          _etaSeconds--;
        } else {
          t.cancel();
        }
      });
    });

    setState(() {
      _loadingType = null;
      _confirmedType = type;
    });
  }

  void _reset() {
    _etaTimer?.cancel();
    setState(() {
      _confirmedType = null;
      _loadingType = null;
    });
  }

  String _formatEta(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    if (_confirmedType != null) {
      return _buildConfirmationScreen(context, _confirmedType!);
    }
    return _buildMainScreen(context);
  }

  Widget _buildMainScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Header
              Text(
                'Hello 👋',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ).animate().fadeIn(duration: 500.ms),

              const SizedBox(height: 8),

              Text(
                'What do you need help with?',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 150.ms, duration: 500.ms),

              const SizedBox(height: 48),

              // Big need buttons
              ..._NeedType.values.asMap().entries.map((entry) {
                final i = entry.key;
                final type = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _NeedButton(
                    type: type,
                    isLoading: _loadingType == type,
                    delay: Duration(milliseconds: 200 + i * 120),
                    onTap: _loadingType == null ? () => _onNeedTap(type) : null,
                  ),
                );
              }),

              const SizedBox(height: 16),

              // More options
              TextButton(
                onPressed: () {},
                child: Text(
                  'More options →',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary,
                      ),
                ),
              ).animate().fadeIn(delay: 600.ms, duration: 400.ms),

              const Spacer(),

              // Language note
              Text(
                'Tap once — help will reach you',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 700.ms, duration: 400.ms),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationScreen(BuildContext context, _NeedType type) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated checkmark
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: type.color.withValues(alpha: 0.12),
                    border: Border.all(
                        color: type.color.withValues(alpha: 0.4), width: 2),
                  ),
                  child: Icon(Icons.check_rounded,
                      size: 60, color: type.color),
                )
                    .animate()
                    .scale(
                      begin: const Offset(0.2, 0.2),
                      duration: 700.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 300.ms),

                const SizedBox(height: 28),

                Text(
                  'Help is on the way!',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 350.ms, duration: 400.ms),

                const SizedBox(height: 12),

                Text(
                  type.label.replaceAll('I need ', '') + ' help is being arranged for you.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 450.ms, duration: 400.ms),

                const SizedBox(height: 28),

                // Volunteer info card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: type.color.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: type.color.withValues(alpha: 0.15),
                            ),
                            child: Icon(type.icon, color: type.color, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  type.volunteerName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium,
                                ),
                                Text(
                                  'Assigned volunteer',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(color: AppColors.border),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Estimated arrival',
                              style: Theme.of(context).textTheme.bodySmall),
                          Text(
                            _formatEta(_etaSeconds),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: type.color,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures()
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 550.ms, duration: 400.ms).slideY(begin: 0.1, delay: 550.ms),

                const SizedBox(height: 20),

                // Track on map button
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    decoration:
                        AppColors.gradientBoxDecoration(borderRadius: 16),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on_outlined,
                            color: Colors.white, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Track on Map',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 700.ms, duration: 400.ms),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: _reset,
                  child: const Text(
                    'Back to Home',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                  ),
                ).animate().fadeIn(delay: 800.ms, duration: 400.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Big need button
// ---------------------------------------------------------------------------

class _NeedButton extends StatefulWidget {
  final _NeedType type;
  final bool isLoading;
  final Duration delay;
  final VoidCallback? onTap;

  const _NeedButton({
    required this.type,
    required this.isLoading,
    required this.delay,
    required this.onTap,
  });

  @override
  State<_NeedButton> createState() => _NeedButtonState();
}

class _NeedButtonState extends State<_NeedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _pressController.reverse();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _pressController.forward();
        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _pressController.forward();
      },
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (_, child) => Transform.scale(
          scale: _pressController.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.type.color.withValues(alpha: _isPressed ? 0.25 : 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.type.color.withValues(alpha: _isPressed ? 0.7 : 0.35),
              width: 2,
            ),
            boxShadow: _isPressed
                ? [
                    BoxShadow(
                      color: widget.type.color.withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 2,
                    )
                  ]
                : [],
          ),
          child: widget.isLoading
              ? Center(
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: widget.type.color,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.type.icon,
                        color: widget.type.color, size: 48),
                    const SizedBox(width: 16),
                    Text(
                      widget.type.label,
                      style: TextStyle(
                        color: widget.type.color,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: widget.delay, duration: 400.ms)
        .slideY(begin: 0.12, delay: widget.delay, duration: 400.ms, curve: Curves.easeOut);
  }
}
