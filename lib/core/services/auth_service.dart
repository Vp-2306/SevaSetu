import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? _currentUser;
  ConfirmationResult? _confirmationResult; // for web OTP

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // STEP 1: Send OTP (Web uses ConfirmationResult)
  Future<void> sendOtp(String phone) async {
    final formattedPhone = '+91$phone';
    _confirmationResult = await _auth.signInWithPhoneNumber(formattedPhone);
  }

  // STEP 2: Verify OTP
  Future<bool> verifyOtp(String otp) async {
    try {
      await _confirmationResult!.confirm(otp);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Phone login — call after OTP verified
  Future<UserModel> loginWithPhone(String phone, String role) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Not authenticated');

    // Check if user exists in Firestore
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      _currentUser = UserModel.fromMap(doc.data()!, user.uid);
    } else {
      // New user — save to Firestore
      _currentUser = UserModel(
        uid: user.uid,
        name: '',
        email: '',
        phone: phone,
        role: role,
        createdAt: DateTime.now(),
      );
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(_currentUser!.toMap());
    }
    return _currentUser!;
  }

  // Email login for coordinators
  Future<UserModel> loginWithEmail(String email, String password) async {
    final result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final doc = await _firestore
        .collection('users')
        .doc(result.user!.uid)
        .get();
    if (doc.exists) {
      _currentUser = UserModel.fromMap(doc.data()!, result.user!.uid);
    } else {
      throw Exception('User not found in database');
    }
    return _currentUser!;
  }

  // Register new user
  Future<UserModel> register({
    required String name,
    required String role,
    String? phone,
    String? email,
    String? password,
  }) async {
    User? firebaseUser;

    if (role == 'coordinator' && email != null && password != null) {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      firebaseUser = result.user;
    } else {
      firebaseUser = _auth.currentUser;
    }

    if (firebaseUser == null) throw Exception('Registration failed');

    _currentUser = UserModel(
      uid: firebaseUser.uid,
      name: name,
      email: email ?? '',
      phone: phone ?? '',
      role: role,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('users')
        .doc(firebaseUser.uid)
        .set(_currentUser!.toMap());

    return _currentUser!;
  }

  Future<void> logout() async {
    await _auth.signOut();
    _currentUser = null;
  }
}