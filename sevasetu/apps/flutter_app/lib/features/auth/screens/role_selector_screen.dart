import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

class _RoleData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String route;

  const _RoleData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });
}

const _roles = [
  _RoleData(
    title: 'Field Worker',
    subtitle: 'Conduct surveys & report issues on the ground',
    icon: Icons.person_outline,
    color: AppColors.fieldWorkerColor,
    route: '/field-worker',
  ),
  _RoleData(
    title: 'NGO Coordinator',
    subtitle: 'Manage volunteers, tasks & live operations',
    icon: Icons.dashboard_outlined,
    color: AppColors.coordinatorColor,
    route: '/coordinator',
  ),
  _RoleData(
    title: 'Volunteer',
    subtitle: 'Discover tasks matched to your skills',
    icon: Icons.volunteer_activism_outlined,
    color: AppColors.volunteerColor,
    route: '/volunteer',
  ),
  _RoleData(
    title: 'Community Member',
    subtitle: 'Request help for food, health or education',
    icon: Icons.people_outline,
    color: AppColors.communityColor,
    route: '/community',
  ),
  _RoleData(
    title: 'Government Admin',
    subtitle: 'Oversee programs, analytics & compliance',
    icon: Icons.admin_panel_settings_outlined,
    color: AppColors.govAdminColor,
    route: '/coordinator', // shares coordinator shell
  ),
];

// ---------------------------------------------------------------------------
// Particle Painter
// ---------------------------------------------------------------------------

class _ParticlePainter extends CustomPainter {
  final double animValue;
  final List<_Particle> particles;

  _ParticlePainter({required this.animValue, required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final dy = (p.baseY + animValue * p.speed * size.height) % size.height;
      final dx = p.baseX * size.width +
          math.sin(animValue * math.pi * 2 + p.phase) * 20;

      final paint = Paint()
        ..color = p.color.withValues(alpha: p.opacity * (0.5 + 0.5 * math.sin(animValue * math.pi * 2 + p.phase)))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(dx, dy), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}

class _Particle {
  final double baseX;
  final double baseY;
  final double speed;
  final double radius;
  final double opacity;
  final double phase;
  final Color color;

  _Particle({
    required this.baseX,
    required this.baseY,
    required this.speed,
    required this.radius,
    required this.opacity,
    required this.phase,
    required this.color,
  });

  static List<_Particle> generate(int count) {
    final rng = math.Random(42);
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.tertiary,
    ];
    return List.generate(count, (i) {
      return _Particle(
        baseX: rng.nextDouble(),
        baseY: rng.nextDouble() * 1000,
        speed: 0.03 + rng.nextDouble() * 0.04,
        radius: 2.0 + rng.nextDouble() * 4.0,
        opacity: 0.1 + rng.nextDouble() * 0.3,
        phase: rng.nextDouble() * math.pi * 2,
        color: colors[i % colors.length],
      );
    });
  }
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class RoleSelectorScreen extends StatefulWidget {
  const RoleSelectorScreen({super.key});

  @override
  State<RoleSelectorScreen> createState() => _RoleSelectorScreenState();
}

class _RoleSelectorScreenState extends State<RoleSelectorScreen>
    with TickerProviderStateMixin {
  late final AnimationController _particleController;
  late final AnimationController _shimmerController;
  final List<_Particle> _particles = _Particle.generate(20);
  int? _tappedIndex;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
  }

  @override
  void dispose() {
    _particleController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  Future<void> _onRoleTap(BuildContext context, int index) async {
    await HapticFeedback.mediumImpact();
    setState(() => _tappedIndex = index);
    await Future.delayed(const Duration(milliseconds: 180));
    if (context.mounted) {
      context.go(_roles[index].route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Animated particle background
          AnimatedBuilder(
            animation: _particleController,
            builder: (_, __) => CustomPaint(
              painter: _ParticlePainter(
                animValue: _particleController.value,
                particles: _particles,
              ),
              size: MediaQuery.of(context).size,
            ),
          ),

          // Radial glow at top
          Positioned(
            top: -80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),

                  // Logo
                  _SevaSetuLogo()
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .scale(begin: const Offset(0.85, 0.85), duration: 600.ms, curve: Curves.easeOutBack),

                  const SizedBox(height: 28),

                  // Headline
                  Text(
                    'Who are you?',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 500.ms)
                      .slideY(begin: 0.15, duration: 500.ms),

                  const SizedBox(height: 8),

                  Text(
                    'Select your role to get started',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                      .animate()
                      .fadeIn(delay: 350.ms, duration: 500.ms),

                  const SizedBox(height: 32),

                  // Role cards
                  ...List.generate(_roles.length, (i) {
                    final role = _roles[i];
                    final isPressed = _tappedIndex == i;
                    return _RoleCard(
                      role: role,
                      isPressed: isPressed,
                      delay: Duration(milliseconds: 400 + i * 90),
                      onTap: () => _onRoleTap(context, i),
                    );
                  }),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Logo widget
// ---------------------------------------------------------------------------

class _SevaSetuLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.hub_outlined, color: Colors.white, size: 36),
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Seva',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              TextSpan(
                text: 'Setu',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'AI-powered NGO Coordination',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 0.8,
              ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Role card
// ---------------------------------------------------------------------------

class _RoleCard extends StatelessWidget {
  final _RoleData role;
  final bool isPressed;
  final Duration delay;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.isPressed,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedScale(
        scale: isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 140),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isPressed
                    ? role.color.withValues(alpha: 0.5)
                    : AppColors.border,
                width: 1.5,
              ),
              boxShadow: isPressed
                  ? [
                      BoxShadow(
                        color: role.color.withValues(alpha: 0.2),
                        blurRadius: 16,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Icon square
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: role.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(role.icon, color: role.color, size: 24),
                  ),
                  const SizedBox(width: 14),

                  // Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          role.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.textPrimary,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          role.subtitle,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delay, duration: 400.ms)
        .slideY(begin: 0.12, delay: delay, duration: 400.ms, curve: Curves.easeOut);
  }
}
