import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_routes.dart';
import 'features/auth/screens/splash_screen.dart';
import 'features/auth/screens/role_select_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/surveyor/screens/surveyor_home_screen.dart';
import 'features/surveyor/screens/new_survey_screen.dart';
import 'features/surveyor/screens/voice_survey_screen.dart';
import 'features/surveyor/screens/photo_survey_screen.dart';
import 'features/surveyor/screens/survey_review_screen.dart';
import 'features/volunteer/screens/volunteer_home_screen.dart';
import 'features/volunteer/screens/task_detail_screen.dart';
import 'features/volunteer/screens/availability_screen.dart';
import 'features/volunteer/screens/heatmap_screen.dart';
import 'features/coordinator/screens/coordinator_home_screen.dart';
import 'features/coordinator/screens/survey_review_detail_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.roleSelect,
        builder: (_, _) => const RoleSelectScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, state) => LoginScreen(
          role: state.extra as String? ?? 'volunteer',
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, state) => RegisterScreen(
          role: state.extra as String? ?? 'volunteer',
        ),
      ),
      // Surveyor routes
      GoRoute(
        path: AppRoutes.surveyorHome,
        builder: (_, _) => const SurveyorHomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.newSurvey,
        builder: (_, _) => const NewSurveyScreen(),
      ),
      GoRoute(
        path: AppRoutes.voiceSurvey,
        builder: (_, _) => const VoiceSurveyScreen(),
      ),
      GoRoute(
        path: AppRoutes.photoSurvey,
        builder: (_, _) => const PhotoSurveyScreen(),
      ),
      GoRoute(
        path: AppRoutes.surveyReview,
        builder: (_, state) => SurveyReviewScreen(
          extractedData: state.extra as Map<String, dynamic>?,
        ),
      ),
      // Volunteer routes
      GoRoute(
        path: AppRoutes.volunteerHome,
        builder: (_, _) => const VolunteerHomeScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.taskDetail}/:id',
        builder: (_, state) => TaskDetailScreen(
          taskId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.volunteerAvailability,
        builder: (_, _) => const AvailabilityScreen(),
      ),
      GoRoute(
        path: '/volunteer/heatmap',
        builder: (_, _) => const HeatmapScreen(),
      ),
      // Coordinator routes
      GoRoute(
        path: AppRoutes.coordinatorHome,
        builder: (_, _) => const CoordinatorHomeScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.coordinatorReview}/:id',
        builder: (_, state) => SurveyReviewDetailScreen(
          surveyId: state.pathParameters['id'] ?? '',
        ),
      ),
    ],
  );
});

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: SevasetuApp(),
    ),
  );
}
class SevasetuApp extends ConsumerWidget {
  const SevasetuApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'SevaSetu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
