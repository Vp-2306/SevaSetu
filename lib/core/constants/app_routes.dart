class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash = '/';
  static const String roleSelect = '/role-select';
  static const String login = '/login';
  static const String register = '/register';

  // Surveyor
  static const String surveyorHome = '/surveyor';
  static const String newSurvey = '/surveyor/new-survey';
  static const String voiceSurvey = '/surveyor/voice-survey';
  static const String photoSurvey = '/surveyor/photo-survey';
  static const String surveyReview = '/surveyor/review';

  // Volunteer
  static const String volunteerHome = '/volunteer';
  static const String taskDetail = '/volunteer/task';
  static const String volunteerAvailability = '/volunteer/availability';

  // Coordinator
  static const String coordinatorHome = '/coordinator';
  static const String coordinatorReview = '/coordinator/review';
}
