import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _firebaseUser;
  UserModel? _userData;
  bool _isLoading = false;

  User? get firebaseUser => _firebaseUser;
  UserModel? get userData => _userData;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _firebaseUser != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    _authService.authStateChanges.listen((User? user) {
      _firebaseUser = user;
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserData(String userId) async {
    _userData = await _authService.getUserData(userId);
    notifyListeners();
  }

// floriannnn_101
// floriann101@gmail.com
// 10/02/2000
// 74108529630
// 74108529630

  Future<String?> signUp({
    required String email,
    required String password,
    required String username,
    required DateTime dateNaissance,
  }) async {
    _setLoading(true);
    try {
      await _authService.signUp(
        email: email,
        password: password,
        username: username,
        dateNaissance: dateNaissance,
      );
      _setLoading(false);
      return null; // null = succès
    } catch (e) {
      _setLoading(false);
      // On retourne le message d'erreur
      return e.toString();
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await _authService.signIn(
        email: email,
        password: password,
      );
      // S'assurer que les données utilisateur sont chargées après la connexion
      if (_firebaseUser != null) {
        await _loadUserData(_firebaseUser!.uid);
      }
      _setLoading(false);
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}