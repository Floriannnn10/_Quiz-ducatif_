// =============================================================================
// SERVICE D'AUTHENTIFICATION - GESTION DES UTILISATEURS FIREBASE
// =============================================================================
// Ce service gère l'authentification des utilisateurs via Firebase Auth
// Il fournit les méthodes d'inscription, connexion, déconnexion et récupération
// des données utilisateur

import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'database_service.dart';

// =============================================================================
// CLASSE PRINCIPALE DU SERVICE D'AUTHENTIFICATION
// =============================================================================
/// Service centralisé pour la gestion de l'authentification Firebase
/// Gère l'inscription, la connexion, la déconnexion et la synchronisation
/// avec la base de données locale
class AuthService {
  // =============================================================================
  // INSTANCES DES SERVICES
  // =============================================================================
  
  /// Instance Firebase Auth pour la gestion de l'authentification
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  /// Service de base de données locale pour la synchronisation des données
  final DatabaseService _databaseService = DatabaseService();

  // =============================================================================
  // GETTERS ET STREAMS
  // =============================================================================
  
  /// Stream qui écoute les changements d'état d'authentification Firebase
  /// Notifie automatiquement quand un utilisateur se connecte ou se déconnecte
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Retourne l'utilisateur Firebase actuellement connecté
  /// Retourne null si aucun utilisateur n'est connecté
  User? get currentUser => _auth.currentUser;

  // =============================================================================
  // MÉTHODES D'AUTHENTIFICATION
  // =============================================================================
  
  /// Inscrit un nouvel utilisateur dans Firebase Auth
  /// Crée également un profil utilisateur dans la base de données locale
  /// 
  /// [email] : Adresse email de l'utilisateur
  /// [password] : Mot de passe de l'utilisateur
  /// [username] : Nom d'utilisateur choisi
  /// [dateNaissance] : Date de naissance de l'utilisateur
  /// 
  /// Retourne les credentials Firebase en cas de succès
  /// Lance une exception en cas d'erreur (email déjà utilisé, mot de passe faible, etc.)
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String username,
    required DateTime dateNaissance,
  }) async {
    try {
      // Création du compte Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Création du modèle utilisateur avec les données complètes
      UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        username: username,
        email: email,
        dateNaissance: dateNaissance,
        dateCreation: DateTime.now(),
      );

      // Sauvegarde des données utilisateur dans la base locale
      await _databaseService.insertUser(userModel);

      return userCredential;
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      rethrow; // Relance l'exception pour la gestion dans le provider
    }
  }

  /// Connecte un utilisateur existant avec email et mot de passe
  /// 
  /// [email] : Adresse email de l'utilisateur
  /// [password] : Mot de passe de l'utilisateur
  /// 
  /// Retourne les credentials Firebase en cas de succès
  /// Lance une exception en cas d'erreur (identifiants incorrects, etc.)
  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Erreur lors de la connexion: $e');
      rethrow; // Relance l'exception pour la gestion dans le provider
    }
  }

  /// Déconnecte l'utilisateur actuellement connecté
  /// Efface la session Firebase Auth
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
      rethrow; // Relance l'exception pour la gestion dans le provider
    }
  }

  // =============================================================================
  // MÉTHODES DE RÉCUPÉRATION DE DONNÉES
  // =============================================================================
  
  /// Récupère les données utilisateur depuis la base de données locale
  /// 
  /// [userId] : Identifiant unique de l'utilisateur
  /// 
  /// Retourne le modèle utilisateur complet ou null si non trouvé
  Future<UserModel?> getUserData(String userId) async {
    try {
      return await _databaseService.getUser(userId);
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
      return null;
    }
  }
} 