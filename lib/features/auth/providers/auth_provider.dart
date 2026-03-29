import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/models/user_model.dart';
import '../../../core/constants/app_routes.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authProvider = ChangeNotifierProvider<AuthNotifier>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

class AuthNotifier extends ChangeNotifier {
  final AuthService _authService;

  AuthNotifier(this._authService);

  UserModel? _user;
  String? _selectedRole;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  String? get selectedRole => _selectedRole;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get error => _error;

  void selectRole(String role) {
    _selectedRole = role;
    notifyListeners();
  }

  Future<bool> loginWithPhone(String phone) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _authService.loginWithPhone(phone, _selectedRole ?? 'volunteer');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _authService.loginWithEmail(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    String? phone,
    String? email,
    String? password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await _authService.register(
        name: name,
        role: _selectedRole ?? 'volunteer',
        phone: phone,
        email: email,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    _selectedRole = null;
    notifyListeners();
  }

  String getHomeRoute() {
    switch (_user?.role ?? _selectedRole) {
      case 'surveyor':
        return AppRoutes.surveyorHome;
      case 'volunteer':
        return AppRoutes.volunteerHome;
      case 'coordinator':
        return AppRoutes.coordinatorHome;
      default:
        return AppRoutes.roleSelect;
    }
  }
}
