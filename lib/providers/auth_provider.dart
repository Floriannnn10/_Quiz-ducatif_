// =============================================================================
// PROVIDER D'AUTHENTIFICATION - GESTION D'ÉTAT GLOBALE
// =============================================================================
// Ce provider gère l'état d'authentification de l'application en utilisant
// le pattern Provider. Il synchronise l'état Firebase avec l'interface utilisateur
// et gère les données utilisateur locales.

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

// =============================================================================
// CLASSE PRINCIPALE DU PROVIDER D'AUTHENTIFICATION
// =============================================================================
/// Provider qui gère l'état d'authentification de l'application
/// Utilise ChangeNotifier pour notifier les widgets des changements d'état
/// Synchronise Firebase Auth avec les données utilisateur locales
class AuthProvider with ChangeNotifier {
  // =============================================================================
  // INSTANCES ET PROPRIÉTÉS
  // =============================================================================
  
  /// Service d'authentification Firebase
  final AuthService _authService = AuthService();
  
  /// Utilisateur Firebase actuellement connecté
  User? _firebaseUser;
  
  /// Données utilisateur complètes depuis la base locale
  UserModel? _userData;
  
  /// État de chargement pour les opérations d'authentification
  bool _isLoading = false;

  // =============================================================================
  // GETTERS PUBLICS
  // =============================================================================
  
  /// Utilisateur Firebase actuel (accessible publiquement)
  User? get firebaseUser => _firebaseUser;
  
  /// Données utilisateur complètes (accessible publiquement)
  UserModel? get userData => _userData;
  
  /// État de chargement (accessible publiquement)
  bool get isLoading => _isLoading;
  
  /// Indique si un utilisateur est actuellement authentifié
  bool get isAuthenticated => _firebaseUser != null;

  // =============================================================================
  // CONSTRUCTEUR ET INITIALISATION
  // =============================================================================
  
  /// Constructeur qui initialise l'écoute des changements d'authentification
  AuthProvider() {
    _init();
  }

  /// Initialise l'écoute des changements d'état d'authentification Firebase
  /// Cette méthode est appelée automatiquement au démarrage
  void _init() {
    _authService.authStateChanges.listen((User? user) {
      _firebaseUser = user;
      if (user != null) {
        // Si un utilisateur se connecte, charger ses données locales
        _loadUserData(user.uid);
      } else {
        // Si un utilisateur se déconnecte, effacer ses données
        _userData = null;
      }
      // Notifier tous les widgets qui écoutent ce provider
      notifyListeners();
    });
  }

  /// Charge les données utilisateur depuis la base de données locale
  /// 
  /// [userId] : Identifiant unique de l'utilisateur Firebase
  Future<void> _loadUserData(String userId) async {
    _userData = await _authService.getUserData(userId);
    notifyListeners();
  }

  // =============================================================================
  // MÉTHODES D'AUTHENTIFICATION
  // =============================================================================
  
  /// Inscrit un nouvel utilisateur dans l'application
  /// 
  /// [email] : Adresse email de l'utilisateur
  /// [password] : Mot de passe de l'utilisateur
  /// [username] : Nom d'utilisateur choisi
  /// [dateNaissance] : Date de naissance de l'utilisateur
  /// 
  /// Retourne null en cas de succès, ou un message d'erreur en cas d'échec
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
      // Retourner le message d'erreur pour affichage à l'utilisateur
      return e.toString();
    }
  }

  /// Connecte un utilisateur existant
  /// 
  /// [email] : Adresse email de l'utilisateur
  /// [password] : Mot de passe de l'utilisateur
  /// 
  /// Retourne true en cas de succès, false en cas d'échec
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

  /// Déconnecte l'utilisateur actuellement connecté
  /// Efface automatiquement les données utilisateur locales
  Future<void> signOut() async {
    await _authService.signOut();
  }

  // =============================================================================
  // MÉTHODES PRIVÉES
  // =============================================================================
  
  /// Met à jour l'état de chargement et notifie les widgets
  /// 
  /// [loading] : Nouvel état de chargement
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}