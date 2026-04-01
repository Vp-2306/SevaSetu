import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/survey_model.dart';

class SurveyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitSurvey(SurveyModel survey) async {
    await _firestore
        .collection('surveys')
        .doc(survey.id)
        .set(survey.toJson());
  }

  Future<List<SurveyModel>> getSurveysBySurveyor(String surveyorId) async {
    final snapshot = await _firestore
        .collection('surveys')
        .where('surveyorId', isEqualTo: surveyorId)
        .orderBy('submittedAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => SurveyModel.fromJson(doc.data()))
        .toList();
  }

  Future<List<SurveyModel>> getAllSurveys() async {
    final snapshot = await _firestore
        .collection('surveys')
        .orderBy('submittedAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => SurveyModel.fromJson(doc.data()))
        .toList();
  }

  Future<void> updateSurveyStatus(String surveyId, String status, {String? note}) async {
    await _firestore.collection('surveys').doc(surveyId).update({
      'status': status,
      if (note != null) 'coordinatorNote': note,
    });
  }
}