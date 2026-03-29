import '../models/survey_model.dart';

/// Mock location service for Phase 1.
class LocationService {
  Future<LocationData> getCurrentLocation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const LocationData(
      lat: 19.0760,
      lng: 72.8777,
      address: 'Andheri West, Mumbai, Maharashtra',
    );
  }

  double calculateDistance(LocationData a, LocationData b) {
    // Haversine formula (simplified for mock)
    final dLat = (b.lat - a.lat) * 111.32;
    final dLng = (b.lng - a.lng) * 111.32 * 0.85;
    return (dLat * dLat + dLng * dLng).abs();
  }
}
