class AppStrings {
  AppStrings._();

  // App
  static const String appName = 'SevaSetu';
  static const String tagline = 'Built for Bharat';

  // Roles
  static const String fieldSurveyor = 'Field Surveyor';
  static const String volunteer = 'Volunteer';
  static const String ngoCoordinator = 'NGO Coordinator';
  static const String surveyorSubtitle = 'Report community needs from the ground';
  static const String volunteerSubtitle = 'Offer your skills to help communities';
  static const String coordinatorSubtitle = 'Manage surveys, tasks, and volunteers';

  // Role Select
  static const String whoAreYou = 'Who are you?';
  static const String selectRole = 'Select your role to get started';
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String signIn = 'Sign in';

  // Auth
  static const String enterPhone = 'Enter your phone number';
  static const String enterEmail = 'Enter your email';
  static const String enterPassword = 'Enter your password';
  static const String enterOtp = 'Enter OTP';
  static const String sendOtp = 'Send OTP';
  static const String verifyOtp = 'Verify OTP';
  static const String enterName = 'Enter your full name';
  static const String selectSkills = 'Select your skills';
  static const String selectAvailability = 'Select your availability';
  static const String register = 'Register';
  static const String login = 'Login';
  static const String continueText = 'Continue';
  static const String logout = 'Logout';

  // Surveyor
  static const String startNewSurvey = 'Start New Survey';
  static const String voicePhotoOrManual = 'Voice, photo, or manual entry';
  static const String recentSurveys = 'Recent Surveys';
  static const String chooseHowToReport = 'Choose how to report';
  static const String recordVoiceSurvey = 'Record Voice Survey';
  static const String speakInAnyLanguage = 'Speak in Hindi, Kannada, Tamil or any language';
  static const String uploadSurveyPhoto = 'Upload Survey Form Photo';
  static const String takePhotoOfForm = 'Take a photo of a paper form — AI will read it';
  static const String typeManually = 'Type Manually';
  static const String enterDetailsDirectly = 'Enter survey details directly';
  static const String today = 'Today';
  static const String thisWeek = 'This Week';
  static const String pendingReview = 'Pending Review';
  static const String synced = 'Synced';
  static const String pending = 'pending';
  static const String processingWithGemini = 'Processing with Gemini AI...';
  static const String geminiReading = 'Gemini is reading your survey...';
  static const String looksRight = 'Looks right?';
  static const String reRecord = 'Re-record';
  static const String couldNotRead = 'Could not read clearly — please fill in manually';
  static const String surveyHistory = 'Survey History';

  // Voice Survey
  static const String tapToRecord = 'Tap to start recording';
  static const String recording = 'Recording...';
  static const String process = 'Process';

  // Volunteer
  static const String tasksMatchedForYou = 'Tasks Matched For You';
  static const String viewHeatmap = 'View Heatmap';
  static const String acceptTask = 'Accept Task';
  static const String skip = 'Skip';
  static const String noTasksMatch = 'No tasks match your skills today — check back soon';
  static const String credits = 'Credits';
  static const String myCredits = 'My Credits';
  static const String totalCredits = 'Total Credits';
  static const String yourImpactCertificate = 'Your Impact Certificate';
  static const String downloadPdf = 'Download PDF';
  static const String shareToLinkedIn = 'Share to LinkedIn';
  static const String completedTasks = 'Completed Tasks';
  static const String cancelTask = 'Cancel Task';
  static const String cancelWarning = 'Cancelling affects your streak and costs 10 credits';
  static const String kmAway = 'km away';
  static const String urgent = 'URGENT';
  static const String moderate = 'Moderate';
  static const String tasks = 'Tasks';
  static const String heatmap = 'Heatmap';
  static const String profile = 'Profile';
  static const String dayStreak = '-day streak! Keep going!';

  // Coordinator
  static const String surveysAwaitingReview = 'Surveys Awaiting Review';
  static const String approveAndCreateTask = 'Approve & Create Task';
  static const String reject = 'Reject';
  static const String openNeeds = 'Open Needs';
  static const String pendingSurveyReviews = 'Pending Survey Reviews';
  static const String activeVolunteers = 'Active Volunteers';
  static const String tasksCompletedWeek = 'Tasks Completed';
  static const String crisis = 'CRISIS';
  static const String crisisConfirmation = 'Send emergency broadcast to all NGO volunteers?';
  static const String topMatches = 'Top Matches for this Task';
  static const String autoAssignBest = 'Auto-assign Best Match';
  static const String taskCreated = 'Task created! Matching volunteers...';
  static const String rejectReason = 'Reason for rejection';
  static const String dashboard = 'Dashboard';
  static const String surveys = 'Surveys';
  static const String volunteers = 'Volunteers';
  static const String analytics = 'Analytics';
  static const String activeTasks = 'Active Tasks';
  static const String volunteerManagement = 'Volunteer Management';
  static const String recentActivity = 'Recent Activity';
  static const String assign = 'Assign';

  // Categories
  static const String food = 'Food';
  static const String health = 'Health';
  static const String education = 'Education';
  static const String shelter = 'Shelter';
  static const String water = 'Water';
  static const String other = 'Other';
  static const String all = 'All';

  // Common
  static const String submit = 'Submit';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String loading = 'Loading...';
  static const String error = 'Something went wrong';
  static const String retry = 'Retry';
  static const String success = 'Success!';
  static const String home = 'Home';
  static const String history = 'History';
  static const String settings = 'Settings';
  static const String noData = 'No data available';

  // Languages
  static const List<String> supportedLanguages = [
    'Hindi', 'Kannada', 'Tamil', 'Telugu', 'Marathi', 'Bengali',
  ];

  // Skills
  static const List<String> availableSkills = [
    'Food Distribution', 'Medical Aid', 'Teaching',
    'Construction', 'Counseling', 'Crowd Management',
    'First Aid', 'Child Care', 'Logistics',
    'Translation', 'Driving', 'Cooking',
  ];

  // Days
  static const List<String> weekDays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  // Time Slots
  static const List<String> timeSlots = [
    'Morning', 'Afternoon', 'Evening',
  ];
}
