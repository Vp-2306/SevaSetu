import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

// ---------------------------------------------------------------------------
// Mock data
// ---------------------------------------------------------------------------

class _ActivityItem {
  final String message;
  final String time;
  final IconData icon;
  final Color color;

  const _ActivityItem({
    required this.message,
    required this.time,
    required this.icon,
    required this.color,
  });
}

const _activities = [
  _ActivityItem(
      message: 'Anita Kumar accepted Medical Camp task',
      time: '2m',
      icon: Icons.check_circle_outline,
      color: Color(0xFF22C55E)),
  _ActivityItem(
      message: 'New survey submitted from Ward 7',
      time: '5m',
      icon: Icons.assignment_outlined,
      color: AppColors.primary),
  _ActivityItem(
      message: 'Rohit Sharma completed Ration Drive',
      time: '12m',
      icon: Icons.task_alt,
      color: AppColors.tertiary),
  _ActivityItem(
      message: 'CRISIS alert: Flood in Sector 4',
      time: '18m',
      icon: Icons.warning_amber_outlined,
      color: Color(0xFFEF4444)),
  _ActivityItem(
      message: 'Meena Devi declined Education task',
      time: '22m',
      icon: Icons.cancel_outlined,
      color: AppColors.textMuted),
  _ActivityItem(
      message: 'AI suggested reallocation for 3 volunteers',
      time: '30m',
      icon: Icons.auto_awesome,
      color: AppColors.volunteerColor),
  _ActivityItem(
      message: 'Volunteer onboarded: Sunita Rao',
      time: '45m',
      icon: Icons.person_add_outlined,
      color: AppColors.primary),
  _ActivityItem(
      message: 'Zone B coverage dropped to 68%',
      time: '1h',
      icon: Icons.trending_down,
      color: Color(0xFFF59E0B)),
  _ActivityItem(
      message: 'Government admin reviewed weekly report',
      time: '2h',
      icon: Icons.admin_panel_settings_outlined,
      color: AppColors.govAdminColor),
  _ActivityItem(
      message: 'Task batch #24 auto-assigned by AI',
      time: '3h',
      icon: Icons.auto_fix_high,
      color: AppColors.volunteerColor),
];

class _ZoneSummary {
  final String zone;
  final int volunteers;
  final int tasks;
  final double coverage;

  const _ZoneSummary({
    required this.zone,
    required this.volunteers,
    required this.tasks,
    required this.coverage,
  });
}

const _zones = [
  _ZoneSummary(zone: 'Ward 7 North', volunteers: 8, tasks: 12, coverage: 0.82),
  _ZoneSummary(zone: 'Ward 7 South', volunteers: 5, tasks: 9, coverage: 0.68),
  _ZoneSummary(zone: 'Ward 8', volunteers: 11, tasks: 7, coverage: 0.91),
  _ZoneSummary(zone: 'Sector B', volunteers: 3, tasks: 14, coverage: 0.45),
];

// ---------------------------------------------------------------------------
// Mini line chart painter
// ---------------------------------------------------------------------------

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _LineChartPainter({required this.data, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxVal = data.reduce(math.max);
    final minVal = data.reduce(math.min);
    final range = (maxVal - minVal).clamp(1.0, double.infinity);

    final path = Path();
    final fillPath = Path();

    for (int i = 0; i < data.length; i++) {
      final x = i / (data.length - 1) * size.width;
      final y = size.height - ((data[i] - minVal) / range) * size.height * 0.85 - size.height * 0.05;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(_LineChartPainter old) => false;
}

// ---------------------------------------------------------------------------
// Volunteer dot painter (map placeholder)
// ---------------------------------------------------------------------------

class _VolunteerDotPainter extends CustomPainter {
  final double pulse;

  _VolunteerDotPainter({required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final positions = [
      Offset(size.width * 0.25, size.height * 0.35),
      Offset(size.width * 0.6, size.height * 0.45),
      Offset(size.width * 0.4, size.height * 0.65),
      Offset(size.width * 0.75, size.height * 0.28),
      Offset(size.width * 0.15, size.height * 0.70),
    ];

    final colors = [
      AppColors.primary,
      AppColors.tertiary,
      AppColors.volunteerColor,
      AppColors.primary,
      AppColors.tertiary,
    ];

    for (int i = 0; i < positions.length; i++) {
      final p = positions[i];
      final c = colors[i];

      // Pulse ring
      final pulsePaint = Paint()
        ..color = c.withValues(alpha: (1 - pulse) * 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawCircle(p, 10 + pulse * 12, pulsePaint);

      // Dot
      final dotPaint = Paint()..color = c;
      canvas.drawCircle(p, 7, dotPaint);

      // White center
      final centerPaint = Paint()..color = Colors.white;
      canvas.drawCircle(p, 3, centerPaint);
    }
  }

  @override
  bool shouldRepaint(_VolunteerDotPainter old) => true;
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class CoordinatorHomeScreen extends StatefulWidget {
  const CoordinatorHomeScreen({super.key});

  @override
  State<CoordinatorHomeScreen> createState() => _CoordinatorHomeScreenState();
}

class _CoordinatorHomeScreenState extends State<CoordinatorHomeScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final AnimationController _pulseController;
  bool _suggestionDismissed = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildLiveMapTab(),
                  _buildInsightsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 12),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('HealthFirst NGO',
                    style: Theme.of(context).textTheme.titleLarge),
                Text('Operations Dashboard',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textPrimary),
                onPressed: () {},
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEF4444),
                  ),
                  child: const Center(
                    child: Text('3',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: () => _showCrisisDialog(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFEF4444).withValues(alpha: 0.4),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Text(
                'CRISIS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.surface,
      child: TabBar(
        controller: _tabController,
        tabs: const [
          Tab(text: 'Live Map'),
          Tab(text: 'AI Insights'),
        ],
      ),
    );
  }

  Widget _buildLiveMapTab() {
    return Stack(
      children: [
        Column(
          children: [
            // Map placeholder (55% height)
            Expanded(
              flex: 55,
              child: Stack(
                children: [
                  // Gradient map placeholder
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Grid overlay
                  CustomPaint(
                    size: Size.infinite,
                    painter: _GridPainter(),
                  ),
                  // Volunteer dots
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (_, __) => CustomPaint(
                      size: Size.infinite,
                      painter: _VolunteerDotPainter(pulse: _pulseController.value),
                    ),
                  ),
                  // Map label
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: Color(0xFF22C55E)),
                          SizedBox(width: 5),
                          Text('27 active',
                              style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom sheet area
            Expanded(
              flex: 45,
              child: _buildBottomSheetContent(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomSheetContent() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Zone Summary',
                    style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                Text('4 zones',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _zones.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _ZoneTile(zone: _zones[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Forecast card
          _buildForecastCard()
              .animate()
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 16),

          // AI Suggestion card
          if (!_suggestionDismissed)
            _buildAiSuggestionCard()
                .animate()
                .fadeIn(delay: 100.ms, duration: 400.ms)
                .slideY(begin: 0.1, delay: 100.ms),
          if (!_suggestionDismissed) const SizedBox(height: 16),

          // Volunteer health indicators
          Text('Volunteer Health', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 12),
          _buildVolunteerIndicators()
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 20),

          // Recent activity
          Text('Recent Activity', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          ...List.generate(
              _activities.length,
              (i) => _ActivityTile(
                    item: _activities[i],
                    delay: Duration(milliseconds: 250 + i * 50),
                  )),
        ],
      ),
    );
  }

  Widget _buildForecastCard() {
    const forecastData = [12.0, 18.0, 14.0, 22.0, 28.0, 20.0, 25.0, 30.0];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: AppColors.primary, size: 18),
              const SizedBox(width: 6),
              Text('Demand Forecast – Next 8 Days',
                  style: Theme.of(context).textTheme.titleSmall),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: CustomPaint(
              painter: _LineChartPainter(
                data: forecastData,
                color: AppColors.primary,
              ),
              size: const Size(double.infinity, 80),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Peak expected on Day 5 — consider activating 8 reserve volunteers.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildAiSuggestionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 12,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome,
                  color: AppColors.primary, size: 18),
              const SizedBox(width: 6),
              Text('AI Suggestion',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: AppColors.primary)),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('High Confidence',
                    style: TextStyle(
                        fontSize: 10,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Move 3 volunteers from Zone A (over-staffed, 91% coverage) to Sector B (under-staffed, 45% coverage). Estimated impact: +28% coverage in Sector B.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _suggestionDismissed = true),
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Center(
                      child: Text('Dismiss',
                          style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => setState(() => _suggestionDismissed = true),
                  child: Container(
                    height: 38,
                    decoration:
                        AppColors.gradientBoxDecoration(borderRadius: 8),
                    child: const Center(
                      child: Text('Accept & Apply',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVolunteerIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _CircleIndicator(
          percent: 0.72,
          label: 'Active',
          value: '27',
          color: const Color(0xFF22C55E),
        ),
        _CircleIndicator(
          percent: 0.18,
          label: 'At Risk',
          value: '7',
          color: const Color(0xFFF59E0B),
        ),
        _CircleIndicator(
          percent: 0.10,
          label: 'Inactive',
          value: '4',
          color: const Color(0xFFEF4444),
        ),
      ],
    );
  }

  void _showCrisisDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('🚨 Declare Crisis',
            style: TextStyle(color: AppColors.textPrimary)),
        content: Text(
          'This will alert all volunteers and government authorities immediately. Are you sure?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444)),
            onPressed: () => Navigator.pop(context),
            child: const Text('Declare Crisis'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Zone tile
// ---------------------------------------------------------------------------

class _ZoneTile extends StatelessWidget {
  final _ZoneSummary zone;

  const _ZoneTile({required this.zone});

  @override
  Widget build(BuildContext context) {
    final coverageColor = zone.coverage >= 0.75
        ? const Color(0xFF22C55E)
        : zone.coverage >= 0.55
            ? const Color(0xFFF59E0B)
            : const Color(0xFFEF4444);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(zone.zone,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontSize: 13)),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: zone.coverage,
                    color: coverageColor,
                    backgroundColor: AppColors.border,
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${zone.volunteers} vol',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall
                      ?.copyWith(color: AppColors.primary)),
              Text('${zone.tasks} tasks',
                  style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Circle indicator
// ---------------------------------------------------------------------------

class _CircleIndicator extends StatelessWidget {
  final double percent;
  final String label;
  final String value;
  final Color color;

  const _CircleIndicator({
    required this.percent,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  value: percent,
                  strokeWidth: 7,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.15),
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Activity tile
// ---------------------------------------------------------------------------

class _ActivityTile extends StatelessWidget {
  final _ActivityItem item;
  final Duration delay;

  const _ActivityTile({required this.item, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, color: item.color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                ),
                const SizedBox(height: 2),
                Text(item.time,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delay, duration: 300.ms)
        .slideX(begin: 0.04, delay: delay, duration: 300.ms);
  }
}

// ---------------------------------------------------------------------------
// Grid painter
// ---------------------------------------------------------------------------

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1;
    const step = 32.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}
