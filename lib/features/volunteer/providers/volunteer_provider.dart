import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/need_model.dart';
import '../../../core/models/volunteer_model.dart';
import '../../../core/models/survey_model.dart';

final volunteerProvider = ChangeNotifierProvider<VolunteerNotifier>((ref) {
  return VolunteerNotifier();
});

final volunteerTabIndexProvider = StateProvider<int>((ref) => 0);

class VolunteerNotifier extends ChangeNotifier {
  VolunteerModel _profile = const VolunteerModel(
    uid: 'vol_001',
    name: 'Priya Sharma',
    skills: ['Food Distribution', 'Crowd Management', 'First Aid'],
    availableDays: ['Mon', 'Wed', 'Fri', 'Sat'],
    availableTimeSlots: ['morning', 'evening'],
    location: LocationData(lat: 19.0760, lng: 72.8777, address: 'Andheri, Mumbai'),
    rating: 4.6,
    completedTasks: 23,
    credits: 247,
    streakDays: 7,
    isVerified: true,
  );

  List<NeedModel> _matchedTasks = [];
  List<NeedModel> _completedTasksList = [];
  String _selectedFilter = 'All';
  bool _isLoading = false;

  VolunteerModel get profile => _profile;
  List<NeedModel> get matchedTasks => _selectedFilter == 'All'
      ? _matchedTasks
      : _matchedTasks.where((t) => t.category.toLowerCase() == _selectedFilter.toLowerCase()).toList();
  List<NeedModel> get completedTasksList => _completedTasksList;
  String get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;

  VolunteerNotifier() {
    _loadMockData();
  }

  void _loadMockData() {
    _matchedTasks = [
      NeedModel(
        id: 'need_001', surveyId: 'survey_001', category: 'food', urgency: 5,
        description: 'Urgent food distribution for 150 families displaced by waterlogging',
        location: const LocationData(lat: 19.0440, lng: 72.8554, address: 'Dharavi, Mumbai'),
        estimatedCount: 150, status: 'open',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        scheduledFor: DateTime.now().add(const Duration(hours: 6)),
        requiredSkills: ['Food Distribution', 'Crowd Management'],
      ),
      NeedModel(
        id: 'need_002', surveyId: 'survey_004', category: 'health', urgency: 3,
        description: 'Medical checkup camp for elderly in Bandra slum',
        location: const LocationData(lat: 19.0596, lng: 72.8295, address: 'Bandra East, Mumbai'),
        estimatedCount: 60, status: 'open',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        scheduledFor: DateTime.now().add(const Duration(days: 2)),
        requiredSkills: ['Medical Aid', 'First Aid'],
      ),
      NeedModel(
        id: 'need_003', surveyId: 'survey_005', category: 'education', urgency: 2,
        description: 'After-school tutoring volunteers for 30 children',
        location: const LocationData(lat: 19.1136, lng: 72.8697, address: 'Goregaon, Mumbai'),
        estimatedCount: 30, status: 'open',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        scheduledFor: DateTime.now().add(const Duration(days: 3)),
        requiredSkills: ['Teaching', 'Child Care'],
      ),
      NeedModel(
        id: 'need_004', surveyId: 'survey_006', category: 'shelter', urgency: 4,
        description: 'Temporary shelter setup for flood-affected families',
        location: const LocationData(lat: 19.0330, lng: 72.8440, address: 'Mahim, Mumbai'),
        estimatedCount: 45, status: 'open',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        scheduledFor: DateTime.now().add(const Duration(hours: 12)),
        requiredSkills: ['Construction', 'Logistics'],
      ),
    ];

    _completedTasksList = [
      NeedModel(
        id: 'need_c1', surveyId: 's1', category: 'food', urgency: 3,
        description: 'Ration kit distribution — Andheri camp',
        location: const LocationData(lat: 19.1197, lng: 72.8464, address: 'Andheri, Mumbai'),
        estimatedCount: 100, status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      NeedModel(
        id: 'need_c2', surveyId: 's2', category: 'health', urgency: 4,
        description: 'First aid training session',
        location: const LocationData(lat: 19.0760, lng: 72.8777, address: 'Juhu, Mumbai'),
        estimatedCount: 25, status: 'completed',
        createdAt: DateTime.now().subtract(const Duration(days: 8)),
      ),
    ];
    notifyListeners();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Future<void> acceptTask(String needId) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    final idx = _matchedTasks.indexWhere((t) => t.id == needId);
    if (idx != -1) {
      _matchedTasks[idx] = _matchedTasks[idx].copyWith(status: 'assigned', assignedVolunteerId: _profile.uid);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> cancelTask(String needId) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _profile = _profile.copyWith(credits: _profile.credits - 10);
    _isLoading = false;
    notifyListeners();
  }

  void updateAvailability(List<String> days, List<String> slots) {
    _profile = _profile.copyWith(availableDays: days, availableTimeSlots: slots);
    notifyListeners();
  }
}
