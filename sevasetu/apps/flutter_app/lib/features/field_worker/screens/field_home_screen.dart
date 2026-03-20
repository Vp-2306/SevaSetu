import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

// ---------------------------------------------------------------------------
// Mock data
// ---------------------------------------------------------------------------

class _Submission {
  final String category;
  final String title;
  final String urgency;
  final String time;
  final IconData icon;
  final Color iconColor;

  const _Submission({
    required this.category,
    required this.title,
    required this.urgency,
    required this.time,
    required this.icon,
    required this.iconColor,
  });
}

const _submissions = [
  _Submission(
    category: 'Health',
    title: 'Water contamination reported – Ward 7',
    urgency: 'HIGH',
    time: '2h ago',
    icon: Icons.water_drop_outlined,
    iconColor: AppColors.primary,
  ),
  _Submission(
    category: 'Food',
    title: 'Elderly household needs ration – Sector 4',
    urgency: 'MEDIUM',
    time: '3h ago',
    icon: Icons.restaurant_outlined,
    iconColor: AppColors.tertiary,
  ),
  _Submission(
    category: 'Education',
    title: 'School dropout alert – 3 children',
    urgency: 'LOW',
    time: '5h ago',
    icon: Icons.school_outlined,
    iconColor: AppColors.volunteerColor,
  ),
  _Submission(
    category: 'Infrastructure',
    title: 'Road damage after rain – Lane 12',
    urgency: 'MEDIUM',
    time: '6h ago',
    icon: Icons.construction_outlined,
    iconColor: AppColors.govAdminColor,
  ),
  _Submission(
    category: 'Health',
    title: 'Suspected dengue cluster – Block B',
    urgency: 'HIGH',
    time: '8h ago',
    icon: Icons.health_and_safety_outlined,
    iconColor: AppColors.primary,
  ),
];

Color _urgencyColor(String u) {
  switch (u) {
    case 'HIGH':
      return const Color(0xFFEF4444);
    case 'MEDIUM':
      return const Color(0xFFF59E0B);
    default:
      return AppColors.tertiary;
  }
}

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class FieldHomeScreen extends StatefulWidget {
  const FieldHomeScreen({super.key});

  @override
  State<FieldHomeScreen> createState() => _FieldHomeScreenState();
}

class _FieldHomeScreenState extends State<FieldHomeScreen>
    with SingleTickerProviderStateMixin {
  bool _isOffline = false;
  int _pendingCount = 3;
  int _navIndex = 0;
  late final AnimationController _syncController;

  @override
  void initState() {
    super.initState();
    _syncController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _syncController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';
    final dateStr =
        '${_weekday(now.weekday)}, ${now.day} ${_month(now.month)} ${now.year}';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Offline banner
          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutCubic,
            height: _isOffline ? 44 : 0,
            color: const Color(0xFFB45309),
            child: _isOffline
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 16, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'Offline — $_pendingCount submissions pending sync',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),

          Expanded(
            child: SafeArea(
              top: !_isOffline,
              bottom: false,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: _buildHeader(greeting, dateStr),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildVoiceSurveyCard(context),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 12)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildScanCard(),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildZoneCard(),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
                      child: Text(
                        'Recent Submissions',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => Padding(
                        padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                        child: _SubmissionTile(
                          item: _submissions[i],
                          delay: Duration(milliseconds: i * 60),
                        ),
                      ),
                      childCount: _submissions.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
      floatingActionButton: _isOffline
          ? null
          : FloatingActionButton.small(
              onPressed: () => setState(() => _isOffline = !_isOffline),
              backgroundColor: AppColors.surfaceVariant,
              child: const Icon(Icons.wifi, size: 18),
            ),
    );
  }

  Widget _buildHeader(String greeting, String date) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$greeting, Ravi 👋',
                style: Theme.of(context).textTheme.headlineSmall,
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
              const SizedBox(height: 2),
              Text(date, style: Theme.of(context).textTheme.bodyMedium)
                  .animate()
                  .fadeIn(delay: 100.ms, duration: 400.ms),
            ],
          ),
        ),
        // Sync indicator
        AnimatedBuilder(
          animation: _syncController,
          builder: (_, child) => Transform.rotate(
            angle: _syncController.value * 2 * 3.14159,
            child: child,
          ),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.sync, color: AppColors.tertiary, size: 20),
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildVoiceSurveyCard(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/voice-survey'),
      child: Container(
        height: 120,
        decoration: AppColors.gradientBoxDecoration(
          colors: [AppColors.primary, AppColors.secondary],
          borderRadius: 20,
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(Icons.mic, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start Voice Survey',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Speak in your language — AI structures the report',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 250.ms, duration: 400.ms)
        .slideY(begin: 0.1, delay: 250.ms, duration: 400.ms);
  }

  Widget _buildScanCard() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            const Icon(Icons.document_scanner_outlined,
                color: AppColors.tertiary, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                'Scan Paper Form',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.textMuted),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 350.ms, duration: 400.ms)
        .slideY(begin: 0.1, delay: 350.ms, duration: 400.ms);
  }

  Widget _buildZoneCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    color: AppColors.primary, size: 18),
                const SizedBox(width: 6),
                Text("Today's Zone",
                    style: Theme.of(context).textTheme.titleSmall),
                const Spacer(),
                Text('Ward 7 • North',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          // Map placeholder
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(16)),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 160,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Grid lines
                CustomPaint(
                  size: const Size(double.infinity, 160),
                  painter: _MapGridPainter(),
                ),
                const Icon(Icons.location_pin, color: Color(0xFFEF4444), size: 40),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 450.ms, duration: 400.ms)
        .slideY(begin: 0.1, delay: 450.ms, duration: 400.ms);
  }

  String _weekday(int d) =>
      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][d - 1];

  String _month(int m) => [
        'Jan','Feb','Mar','Apr','May','Jun',
        'Jul','Aug','Sep','Oct','Nov','Dec'
      ][m - 1];
}

// ---------------------------------------------------------------------------
// Map grid placeholder painter
// ---------------------------------------------------------------------------

class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1;
    const step = 30.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_MapGridPainter old) => false;
}

// ---------------------------------------------------------------------------
// Submission tile
// ---------------------------------------------------------------------------

class _SubmissionTile extends StatelessWidget {
  final _Submission item;
  final Duration delay;

  const _SubmissionTile({required this.item, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: item.iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(item.time,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _urgencyColor(item.urgency).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item.urgency,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: _urgencyColor(item.urgency),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delay, duration: 350.ms)
        .slideX(begin: 0.05, delay: delay, duration: 350.ms);
  }
}
