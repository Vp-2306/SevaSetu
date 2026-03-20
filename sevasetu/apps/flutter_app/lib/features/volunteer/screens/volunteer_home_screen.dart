import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

// ---------------------------------------------------------------------------
// Mock data
// ---------------------------------------------------------------------------

class _Task {
  final String title;
  final String category;
  final IconData icon;
  final Color color;
  final String distance;
  final String time;
  final int matchPercent;

  const _Task({
    required this.title,
    required this.category,
    required this.icon,
    required this.color,
    required this.distance,
    required this.time,
    required this.matchPercent,
  });
}

const _tasks = [
  _Task(
    title: 'Medical Camp Assistant',
    category: 'Health',
    icon: Icons.health_and_safety_outlined,
    color: AppColors.primary,
    distance: '1.2 km',
    time: '3h',
    matchPercent: 92,
  ),
  _Task(
    title: 'Ration Distribution Helper',
    category: 'Food',
    icon: Icons.restaurant_outlined,
    color: AppColors.tertiary,
    distance: '2.5 km',
    time: '4h',
    matchPercent: 85,
  ),
  _Task(
    title: 'School Enrollment Drive',
    category: 'Education',
    icon: Icons.school_outlined,
    color: AppColors.volunteerColor,
    distance: '0.8 km',
    time: '2h',
    matchPercent: 78,
  ),
  _Task(
    title: 'Flood Survey Documentation',
    category: 'Disaster',
    icon: Icons.flood_outlined,
    color: AppColors.govAdminColor,
    distance: '3.0 km',
    time: '5h',
    matchPercent: 70,
  ),
];

class _Token {
  final String title;
  final String ngo;
  final String date;
  final int hours;

  const _Token({
    required this.title,
    required this.ngo,
    required this.date,
    required this.hours,
  });
}

const _tokens = [
  _Token(title: 'Medical Camp', ngo: 'HealthFirst NGO', date: 'Jan 12', hours: 8),
  _Token(title: 'Ration Drive', ngo: 'FoodBridge', date: 'Dec 28', hours: 6),
  _Token(title: 'Tree Plantation', ngo: 'GreenEarth', date: 'Dec 15', hours: 4),
];

// ---------------------------------------------------------------------------
// Screen
// ---------------------------------------------------------------------------

class VolunteerHomeScreen extends StatefulWidget {
  const VolunteerHomeScreen({super.key});

  @override
  State<VolunteerHomeScreen> createState() => _VolunteerHomeScreenState();
}

class _VolunteerHomeScreenState extends State<VolunteerHomeScreen>
    with SingleTickerProviderStateMixin {
  int _navIndex = 0;
  int _displayedScore = 0;
  late final AnimationController _flameController;
  Timer? _scoreTimer;
  final int _targetScore = 1240;

  @override
  void initState() {
    super.initState();
    _flameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    // Animate score counter
    int step = 0;
    const steps = 40;
    _scoreTimer = Timer.periodic(const Duration(milliseconds: 30), (t) {
      step++;
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _displayedScore = (_targetScore * step / steps).round();
        if (step >= steps) {
          _displayedScore = _targetScore;
          t.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _flameController.dispose();
    _scoreTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: _buildHeader(context),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildStreakBanner(context),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: Text('Matched For You',
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      SizedBox(
                        height: 220,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _tasks.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (_, i) => _TaskCard(
                            task: _tasks[i],
                            delay: Duration(milliseconds: 200 + i * 80),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                        child: Text('Your Impact Tokens',
                            style: Theme.of(context).textTheme.titleMedium),
                      ),
                      SizedBox(
                        height: 150,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: _tokens.length + 1,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (_, i) {
                            if (i == _tokens.length) return _ExportTokenCard();
                            return _TokenCard(
                              token: _tokens[i],
                              delay: Duration(milliseconds: 300 + i * 80),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),

            // Floating mic button
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.mic, color: Colors.white, size: 26),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_outlined), label: 'Tasks'),
          BottomNavigationBarItem(
              icon: Icon(Icons.workspace_premium_outlined), label: 'Tokens'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, Priya 👋',
                      style: Theme.of(context).textTheme.headlineSmall)
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideY(begin: 0.1),
              const SizedBox(height: 4),
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _flameController,
                    builder: (_, __) => Icon(
                      Icons.local_fire_department,
                      color: Color.lerp(
                          const Color(0xFFF97316),
                          const Color(0xFFFBBF24),
                          _flameController.value)!,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Impact Score: $_displayedScore',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ).animate().fadeIn(delay: 150.ms, duration: 400.ms),
            ],
          ),
        ),
        // Avatar
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: Text(
              'PS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
      ],
    );
  }

  Widget _buildStreakBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFF97316).withValues(alpha: 0.15),
            const Color(0xFFFBBF24).withValues(alpha: 0.15),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFFF97316).withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('12 day streak!',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: const Color(0xFFFBBF24),
                        )),
                Text('Keep going — only 3 more days to a badge',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: AppColors.textMuted),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 300.ms, duration: 400.ms)
        .slideY(begin: 0.1, delay: 300.ms, duration: 400.ms);
  }
}

// ---------------------------------------------------------------------------
// Task card
// ---------------------------------------------------------------------------

class _TaskCard extends StatefulWidget {
  final _Task task;
  final Duration delay;

  const _TaskCard({required this.task, required this.delay});

  @override
  State<_TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<_TaskCard> {
  bool _accepted = false;
  bool _declined = false;

  @override
  Widget build(BuildContext context) {
    if (_declined) {
      return SizedBox(
        width: 240,
        child: Center(
          child: Text('Dismissed',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textMuted)),
        ),
      );
    }
    return SizedBox(
      width: 240,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _accepted
                ? AppColors.tertiary.withValues(alpha: 0.5)
                : AppColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: widget.task.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(widget.task.icon,
                      color: widget.task.color, size: 20),
                ),
                const Spacer(),
                _Badge(label: widget.task.distance, icon: Icons.location_on_outlined),
                const SizedBox(width: 6),
                _Badge(label: widget.task.time, icon: Icons.access_time),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.task.title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppColors.textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '${widget.task.matchPercent}% match',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.tertiary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: widget.task.matchPercent / 100,
                color: AppColors.tertiary,
                backgroundColor: AppColors.surfaceVariant,
                minHeight: 6,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _declined = true),
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Center(
                        child: Text('Decline',
                            style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: GestureDetector(
                    onTap: () => setState(() => _accepted = true),
                    child: Container(
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF059669), Color(0xFF10B981)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          _accepted ? 'Accepted ✓' : 'Accept',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: widget.delay, duration: 400.ms)
        .slideX(begin: 0.1, delay: widget.delay, duration: 400.ms);
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final IconData icon;

  const _Badge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: AppColors.textMuted),
          const SizedBox(width: 3),
          Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Token card
// ---------------------------------------------------------------------------

class _TokenCard extends StatelessWidget {
  final _Token token;
  final Duration delay;

  const _TokenCard({required this.token, required this.delay});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF78350F), Color(0xFF92400E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color(0xFFFBBF24).withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.workspace_premium,
                color: Color(0xFFFBBF24), size: 28),
            const Spacer(),
            Text(
              token.title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              token.ngo,
              style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFFFBBF24),
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text('${token.hours}h • ${token.date}',
                style: const TextStyle(
                    fontSize: 10, color: Colors.white54)),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: delay, duration: 400.ms)
        .slideX(begin: 0.1, delay: delay, duration: 400.ms);
  }
}

class _ExportTokenCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.share_outlined,
                color: AppColors.primary, size: 28),
            const SizedBox(height: 8),
            Text(
              'Export as PDF',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
