/// Mock FCM service for Phase 1.
/// Phase 2 will connect to firebase_messaging.
class FcmService {
  Future<void> initialize() async {}

  Future<String?> getToken() async {
    return 'mock_fcm_token_123';
  }

  Future<void> sendNotification({
    required String to,
    required String title,
    required String body,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  Future<void> broadcastToAll({
    required String title,
    required String body,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
