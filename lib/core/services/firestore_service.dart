import '../models/survey_model.dart';
import '../models/need_model.dart';

/// Mock Firestore service for Phase 1.
/// Phase 2 will connect to cloud_firestore.
class FirestoreService {
  final List<SurveyModel> _surveys = [];
  final List<NeedModel> _needs = [];

  // --- Surveys ---
  Future<void> submitSurvey(SurveyModel survey) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _surveys.add(survey);
  }

  Future<List<SurveyModel>> getSurveys({String? surveyorId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (surveyorId != null) {
      return _surveys.where((s) => s.surveyorId == surveyorId).toList();
    }
    return List.from(_surveys);
  }

  Future<List<SurveyModel>> getPendingSurveys() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _surveys.where((s) => s.status == 'pending_review').toList();
  }

  Future<void> updateSurveyStatus(String id, String status,
      {String? note}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _surveys.indexWhere((s) => s.id == id);
    if (idx != -1) {
      _surveys[idx] = _surveys[idx].copyWith(
        status: status,
        coordinatorNote: note,
      );
    }
  }

  // --- Needs ---
  Future<void> createNeed(NeedModel need) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _needs.add(need);
  }

  Future<List<NeedModel>> getNeeds({String? status}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (status != null) {
      return _needs.where((n) => n.status == status).toList();
    }
    return List.from(_needs);
  }

  Future<void> updateNeedStatus(String id, String status,
      {String? volunteerId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = _needs.indexWhere((n) => n.id == id);
    if (idx != -1) {
      _needs[idx] = _needs[idx].copyWith(
        status: status,
        assignedVolunteerId: volunteerId,
      );
    }
  }
}
