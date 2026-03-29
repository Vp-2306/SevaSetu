import '../models/user_model.dart';

/// Mock authentication service for Phase 1.
/// Phase 2 will connect to firebase_auth.
class AuthService {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<UserModel> loginWithPhone(String phone, String role) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = UserModel(
      uid: 'mock_${role}_001',
      name: role == 'surveyor' ? 'Arjun Kumar' : 'Priya Sharma',
      email: '',
      phone: phone,
      role: role,
      createdAt: DateTime.now(),
      ngoId: role == 'surveyor' ? 'ngo_001' : null,
    );
    return _currentUser!;
  }

  Future<UserModel> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = UserModel(
      uid: 'mock_coordinator_001',
      name: 'Dr. Meera Patel',
      email: email,
      phone: '',
      role: 'coordinator',
      createdAt: DateTime.now(),
      ngoId: 'ngo_001',
    );
    return _currentUser!;
  }

  Future<UserModel> register({
    required String name,
    required String role,
    String? phone,
    String? email,
    String? password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    _currentUser = UserModel(
      uid: 'mock_${role}_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email ?? '',
      phone: phone ?? '',
      role: role,
      createdAt: DateTime.now(),
      ngoId: role != 'volunteer' ? 'ngo_001' : null,
    );
    return _currentUser!;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
  }

  Future<void> sendOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp.length == 6;
  }
}
