import 'dart:math';
import '../models/need_model.dart';
import '../models/volunteer_model.dart';
import '../models/survey_model.dart';

class MatchingService {
  /// Score a volunteer for a given need.
  /// Returns 0.0–1.0 composite score.
  double scoreVolunteer(VolunteerModel v, NeedModel need) {
    // 1. Skill match (40% weight)
    final requiredSkills = _skillsForCategory(need.category);
    final matched =
        v.skills.where((s) => requiredSkills.contains(s)).length;
    final skillScore =
        requiredSkills.isEmpty ? 1.0 : matched / requiredSkills.length;

    // 2. Distance score (35% weight)
    final distanceKm = _calculateDistance(v.location, need.location);
    final distScore = distanceKm > 50 ? 0.0 : 1.0 - (distanceKm / 50);

    // 3. Availability score (15% weight)
    final dayName = _getDayName(need.scheduledFor ?? DateTime.now());
    final availScore = v.availableDays.contains(dayName) ? 1.0 : 0.3;

    // 4. Rating (10% weight)
    final ratingScore = v.rating / 5.0;

    return (skillScore * 0.40) +
        (distScore * 0.35) +
        (availScore * 0.15) +
        (ratingScore * 0.10);
  }

  /// Return top N volunteers sorted by match score.
  List<MapEntry<VolunteerModel, double>> getTopMatches(
    List<VolunteerModel> volunteers,
    NeedModel need, {
    int topN = 3,
  }) {
    final scored = volunteers
        .map((v) => MapEntry(v, scoreVolunteer(v, need)))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return scored.take(topN).toList();
  }

  List<String> skillsForCategoryPublic(String category) =>
      _skillsForCategory(category);

  List<String> _skillsForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return ['Food Distribution', 'Cooking', 'Logistics'];
      case 'health':
        return ['Medical Aid', 'First Aid', 'Counseling'];
      case 'education':
        return ['Teaching', 'Child Care'];
      case 'shelter':
        return ['Construction', 'Logistics'];
      case 'water':
        return ['Logistics'];
      default:
        return [];
    }
  }

  double _calculateDistance(LocationData a, LocationData b) {
    const earthRadius = 6371.0;
    final dLat = _toRad(b.lat - a.lat);
    final dLng = _toRad(b.lng - a.lng);
    final sinDLat = sin(dLat / 2);
    final sinDLng = sin(dLng / 2);
    final calc = sinDLat * sinDLat +
        cos(_toRad(a.lat)) * cos(_toRad(b.lat)) * sinDLng * sinDLng;
    return earthRadius * 2 * asin(sqrt(calc));
  }

  double _toRad(double deg) => deg * pi / 180;

  String _getDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }
}
