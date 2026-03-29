import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/survey_model.dart';
import '../../../core/services/gemini_service.dart';

final surveyorProvider = ChangeNotifierProvider<SurveyorNotifier>((ref) {
  return SurveyorNotifier();
});

final surveyorTabIndexProvider = StateProvider<int>((ref) => 0);

class SurveyorNotifier extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  List<SurveyModel> _surveys = [];
  bool _isLoading = false;
  AiExtractedData? _lastExtraction;

  List<SurveyModel> get surveys => _surveys;
  bool get isLoading => _isLoading;
  AiExtractedData? get lastExtraction => _lastExtraction;

  int get todayCount => _surveys
      .where((s) =>
          s.submittedAt.day == DateTime.now().day &&
          s.submittedAt.month == DateTime.now().month)
      .length;

  int get weekCount {
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    return _surveys.where((s) => s.submittedAt.isAfter(weekAgo)).length;
  }

  int get pendingCount =>
      _surveys.where((s) => s.status == 'pending_review').length;

  SurveyorNotifier() {
    _loadMockData();
  }

  void _loadMockData() {
    _surveys = [
      SurveyModel(
        id: 'survey_001',
        surveyorId: 'mock_surveyor_001',
        inputType: 'voice',
        rawText: 'Dharavi area mein 150 families ko food distribution chahiye urgently',
        status: 'pending_review',
        submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
        aiExtracted: const AiExtractedData(
          category: 'food',
          urgency: 4,
          description: 'Food distribution needed for 150 families in Dharavi',
          location: LocationData(lat: 19.0440, lng: 72.8554, address: 'Dharavi, Mumbai'),
          estimatedCount: 150,
          languageDetected: 'hi',
          confidence: 0.92,
        ),
      ),
      SurveyModel(
        id: 'survey_002',
        surveyorId: 'mock_surveyor_001',
        inputType: 'photo',
        rawText: 'Medical camp needed in rural area near Hubli',
        status: 'approved',
        submittedAt: DateTime.now().subtract(const Duration(days: 1)),
        aiExtracted: const AiExtractedData(
          category: 'health',
          urgency: 3,
          description: 'Medical camp needed — elderly lack checkup access',
          location: LocationData(lat: 15.3647, lng: 75.1240, address: 'Hubli, Karnataka'),
          estimatedCount: 80,
          languageDetected: 'en',
          confidence: 0.88,
        ),
      ),
      SurveyModel(
        id: 'survey_003',
        surveyorId: 'mock_surveyor_001',
        inputType: 'manual',
        rawText: 'School supplies needed for children in Patna slum area',
        status: 'rejected',
        coordinatorNote: 'Duplicate — already covered by Task #22',
        submittedAt: DateTime.now().subtract(const Duration(days: 3)),
        aiExtracted: const AiExtractedData(
          category: 'education',
          urgency: 2,
          description: 'School supplies needed for 40 children',
          location: LocationData(lat: 25.6093, lng: 85.1376, address: 'Kankarbagh, Patna'),
          estimatedCount: 40,
          languageDetected: 'en',
          confidence: 0.95,
        ),
      ),
    ];
    notifyListeners();
  }

  Future<AiExtractedData> processVoiceSurvey(
      String transcript, String language) async {
    _isLoading = true;
    notifyListeners();
    try {
      _lastExtraction =
          await _geminiService.extractFromText(transcript, language);
      _isLoading = false;
      notifyListeners();
      return _lastExtraction!;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<AiExtractedData> processPhotoSurvey(List<int> imageBytes) async {
    _isLoading = true;
    notifyListeners();
    try {
      _lastExtraction = await _geminiService.extractFromImage(imageBytes);
      _isLoading = false;
      notifyListeners();
      return _lastExtraction!;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> submitSurvey(SurveyModel survey) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _surveys.insert(0, survey);
    _isLoading = false;
    notifyListeners();
  }
}
