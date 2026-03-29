/// Mock Storage service for Phase 1.
/// Phase 2 will connect to firebase_storage.
class StorageService {
  Future<String> uploadImage(List<int> bytes, String path) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'https://storage.example.com/$path';
  }

  Future<String> uploadAudio(List<int> bytes, String path) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'https://storage.example.com/$path';
  }
}
