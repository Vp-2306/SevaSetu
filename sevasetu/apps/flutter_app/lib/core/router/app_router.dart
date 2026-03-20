import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/role_selector_screen.dart';
import '../../features/field_worker/screens/field_home_screen.dart';
import '../../features/field_worker/screens/voice_survey_screen.dart';
import '../../features/volunteer/screens/volunteer_home_screen.dart';
import '../../features/coordinator/screens/coordinator_home_screen.dart';
import '../../features/community/screens/community_home_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: RoleSelectorScreen(),
        ),
      ),
      GoRoute(
        path: '/field-worker',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const FieldHomeScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: '/voice-survey',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const VoiceSurveyScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: '/volunteer',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const VolunteerHomeScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: '/coordinator',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const CoordinatorHomeScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
      GoRoute(
        path: '/community',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const CommunityHomeScreen(),
          transitionsBuilder: _slideTransition,
        ),
      ),
    ],
  );
});

Widget _slideTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
    child: child,
  );
}
