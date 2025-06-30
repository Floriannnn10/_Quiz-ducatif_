import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _databaseService = DatabaseService();

  // Stream pour écouter les changements d'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Obtenir l'utilisateur actuel
  User? get currentUser => _auth.currentUser;

  // Inscription
  Future<UserCredential?> signUp({
    required String email,
    required String password,
    required String username,
    required DateTime dateNaissance,
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Créer le modèle utilisateur
      UserModel userModel = UserModel(
        id: userCredential.user!.uid,
        username: username,
        email: email,
        dateNaissance: dateNaissance,
        dateCreation: DateTime.now(),
      );

      // Sauvegarder dans la base de données locale
      await _databaseService.insertUser(userModel);

      return userCredential;
    } catch (e) {
      print('Erreur lors de l\'inscription: $e');
      rethrow;
    }
  }

  // Connexion
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
      rethrow;
    }
  }

  // Déconnexion
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Erreur lors de la déconnexion: $e');
      rethrow;
    }
  }

  // Obtenir les informations de l'utilisateur depuis la base locale
  Future<UserModel?> getUserData(String userId) async {
    try {
      return await _databaseService.getUser(userId);
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
      return null;
    }
  }
} 