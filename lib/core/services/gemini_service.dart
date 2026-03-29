import '../models/survey_model.dart';

/// Mock Gemini AI service — returns hardcoded data after simulated delay.
/// Phase 2 will connect to google_generative_ai package.
class GeminiService {
  Future<AiExtractedData> extractFromText(
      String transcript, String language) async {
    await Future.delayed(const Duration(seconds: 2));
    return AiExtractedData(
      category: _detectCategory(transcript),
      urgency: 4,
      description: 'Food distribution needed for 150 families in the area',
      location: const LocationData(
        lat: 19.0760,
        lng: 72.8777,
        address: 'Dharavi, Mumbai, Maharashtra',
      ),
      estimatedCount: 150,
      languageDetected: language.toLowerCase(),
      confidence: 0.92,
    );
  }

  Future<AiExtractedData> extractFromImage(List<int> imageBytes) async {
    await Future.delayed(const Duration(seconds: 3));
    return const AiExtractedData(
      category: 'health',
      urgency: 3,
      description: 'Medical camp needed — many elderly without access to checkups',
      location: LocationData(
        lat: 12.9716,
        lng: 77.5946,
        address: 'Jayanagar, Bangalore, Karnataka',
      ),
      estimatedCount: 80,
      languageDetected: 'en',
      confidence: 0.85,
    );
  }

  Future<String> generateTaskSummary(String category, String description,
      String volunteerName) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'Hi $volunteerName! 🙏 A community near you needs help with '
        '$category support. $description. Your skills are a perfect match — '
        'can you lend a hand?';
  }

  String _detectCategory(String text) {
    final lower = text.toLowerCase();
    if (lower.contains('food') || lower.contains('khana') || lower.contains('ration')) {
      return 'food';
    } else if (lower.contains('health') || lower.contains('medical') || lower.contains('doctor')) {
      return 'health';
    } else if (lower.contains('school') || lower.contains('education') || lower.contains('padhai')) {
      return 'education';
    } else if (lower.contains('shelter') || lower.contains('ghar') || lower.contains('house')) {
      return 'shelter';
    } else if (lower.contains('water') || lower.contains('paani')) {
      return 'water';
    }
    return 'food';
  }
}
