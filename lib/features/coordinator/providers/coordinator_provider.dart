import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/survey_model.dart';
import '../../../core/models/need_model.dart';
import '../../../core/models/volunteer_model.dart';
import '../../../core/services/matching_service.dart';

final coordinatorProvider =
    ChangeNotifierProvider<CoordinatorNotifier>((ref) => CoordinatorNotifier());

final coordinatorTabIndexProvider = StateProvider<int>((ref) => 0);

class CoordinatorNotifier extends ChangeNotifier {
  final MatchingService _matchingService = MatchingService();
  List<SurveyModel> _pendingSurveys = [];
  List<NeedModel> _activeNeeds = [];
  List<VolunteerModel> _volunteers = [];
  bool _isLoading = false;

  List<SurveyModel> get pendingSurveys => _pendingSurveys;
  List<NeedModel> get activeNeeds => _activeNeeds;
  List<VolunteerModel> get volunteers => _volunteers;
  bool get isLoading => _isLoading;

  int get openNeedsCount => _activeNeeds.where((n) => n.status == 'open').length;
  int get pendingSurveyCount => _pendingSurveys.length;
  int get activeVolunteerCount => _volunteers.where((v) => v.streakDays > 0).length;
  int get completedThisWeek => 12;

  CoordinatorNotifier() {
    _loadMockData();
  }

  void _loadMockData() {
    _pendingSurveys = [
      SurveyModel(
        id: 'ps_001', surveyorId: 'mock_surveyor_001', inputType: 'voice',
        rawText: 'Dharavi mein paani ki bahut kami hai, 200 families affected',
        status: 'pending_review',
        submittedAt: DateTime.now().subtract(const Duration(hours: 1)),
        aiExtracted: const AiExtractedData(
          category: 'water', urgency: 5,
          description: 'Severe water shortage affecting 200 families',
          location: LocationData(lat: 19.0440, lng: 72.8554, address: 'Dharavi, Mumbai'),
          estimatedCount: 200, languageDetected: 'hi', confidence: 0.91,
        ),
      ),
      SurveyModel(
        id: 'ps_002', surveyorId: 'mock_surveyor_002', inputType: 'photo',
        rawText: 'School in Kurla needs repair after monsoon damage',
        status: 'pending_review',
        submittedAt: DateTime.now().subtract(const Duration(hours: 4)),
        aiExtracted: const AiExtractedData(
          category: 'education', urgency: 3,
          description: 'School building needs monsoon damage repair',
          location: LocationData(lat: 19.0728, lng: 72.8826, address: 'Kurla, Mumbai'),
          estimatedCount: 120, languageDetected: 'en', confidence: 0.87,
        ),
      ),
      SurveyModel(
        id: 'ps_003', surveyorId: 'mock_surveyor_001', inputType: 'manual',
        rawText: 'Need shelter kits for 50 families in Sion',
        status: 'pending_review',
        submittedAt: DateTime.now().subtract(const Duration(hours: 6)),
        aiExtracted: const AiExtractedData(
          category: 'shelter', urgency: 4,
          description: 'Shelter kits needed for 50 flood-displaced families',
          location: LocationData(lat: 19.0404, lng: 72.8601, address: 'Sion, Mumbai'),
          estimatedCount: 50, languageDetected: 'en', confidence: 0.94,
        ),
      ),
    ];

    _activeNeeds = [
      NeedModel(
        id: 'an_001', surveyId: 'sv_01', category: 'food', urgency: 4,
        description: 'Food distribution for 150 families',
        location: const LocationData(lat: 19.0440, lng: 72.8554, address: 'Dharavi, Mumbai'),
        estimatedCount: 150, status: 'assigned', assignedVolunteerId: 'vol_001',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        requiredSkills: ['Food Distribution', 'Crowd Management'],
      ),
      NeedModel(
        id: 'an_002', surveyId: 'sv_02', category: 'health', urgency: 3,
        description: 'Medical camp — Bandra East',
        location: const LocationData(lat: 19.0596, lng: 72.8295, address: 'Bandra, Mumbai'),
        estimatedCount: 60, status: 'in_progress', assignedVolunteerId: 'vol_002',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        requiredSkills: ['Medical Aid', 'First Aid'],
      ),
    ];

    _volunteers = [
      const VolunteerModel(
        uid: 'vol_001', name: 'Priya Sharma',
        skills: ['Food Distribution', 'Crowd Management', 'First Aid'],
        availableDays: ['Mon', 'Wed', 'Fri', 'Sat'],
        availableTimeSlots: ['morning', 'evening'],
        location: LocationData(lat: 19.0760, lng: 72.8777, address: 'Andheri, Mumbai'),
        rating: 4.6, completedTasks: 23, credits: 247, streakDays: 7, isVerified: true,
      ),
      const VolunteerModel(
        uid: 'vol_002', name: 'Rahul Verma',
        skills: ['Medical Aid', 'First Aid', 'Counseling'],
        availableDays: ['Tue', 'Thu', 'Sat'],
        availableTimeSlots: ['morning', 'afternoon'],
        location: LocationData(lat: 19.0596, lng: 72.8295, address: 'Bandra, Mumbai'),
        rating: 4.8, completedTasks: 31, credits: 385, streakDays: 12, isVerified: true,
      ),
      const VolunteerModel(
        uid: 'vol_003', name: 'Anita Desai',
        skills: ['Teaching', 'Child Care', 'Counseling'],
        availableDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'],
        availableTimeSlots: ['afternoon', 'evening'],
        location: LocationData(lat: 19.1136, lng: 72.8697, address: 'Goregaon, Mumbai'),
        rating: 4.3, completedTasks: 15, credits: 168, streakDays: 3, isVerified: true,
      ),
      const VolunteerModel(
        uid: 'vol_004', name: 'Vikram Patel',
        skills: ['Construction', 'Logistics', 'Driving'],
        availableDays: ['Sat', 'Sun'],
        availableTimeSlots: ['morning', 'afternoon', 'evening'],
        location: LocationData(lat: 19.0330, lng: 72.8440, address: 'Mahim, Mumbai'),
        rating: 4.1, completedTasks: 9, credits: 95, streakDays: 0, isVerified: false,
      ),
    ];
    notifyListeners();
  }

  List<MapEntry<VolunteerModel, double>> getMatchesForNeed(NeedModel need) {
    return _matchingService.getTopMatches(_volunteers, need);
  }

  Future<void> approveSurvey(String surveyId, AiExtractedData data) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _pendingSurveys.removeWhere((s) => s.id == surveyId);
    _activeNeeds.add(NeedModel(
      id: 'need_${DateTime.now().millisecondsSinceEpoch}',
      surveyId: surveyId, category: data.category, urgency: data.urgency,
      description: data.description, location: data.location,
      estimatedCount: data.estimatedCount, status: 'open',
      createdAt: DateTime.now(),
      requiredSkills: _matchingService.skillsForCategoryPublic(data.category),
    ));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> rejectSurvey(String surveyId, String reason) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _pendingSurveys.removeWhere((s) => s.id == surveyId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> assignVolunteer(String needId, String volunteerId) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    final idx = _activeNeeds.indexWhere((n) => n.id == needId);
    if (idx != -1) {
      _activeNeeds[idx] = _activeNeeds[idx].copyWith(
        status: 'assigned', assignedVolunteerId: volunteerId,
      );
    }
    _isLoading = false;
    notifyListeners();
  }
}
