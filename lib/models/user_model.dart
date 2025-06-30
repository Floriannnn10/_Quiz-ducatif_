// =============================================================================
// MODÈLE UTILISATEUR - REPRÉSENTATION DES DONNÉES UTILISATEUR
// =============================================================================
// Cette classe définit la structure des données utilisateur dans l'application
// Elle inclut les méthodes de sérialisation/désérialisation pour Firebase et SQLite

class UserModel {
  // =============================================================================
  // PROPRIÉTÉS DE L'UTILISATEUR
  // =============================================================================
  
  /// Identifiant unique de l'utilisateur (généré par Firebase Auth)
  final String id;
  
  /// Nom d'utilisateur choisi par l'utilisateur
  final String username;
  
  /// Adresse email de l'utilisateur (utilisée pour la connexion)
  final String email;
  
  /// Date de naissance de l'utilisateur
  final DateTime dateNaissance;
  
  /// Date de création du compte utilisateur
  final DateTime dateCreation;

  // =============================================================================
  // CONSTRUCTEUR
  // =============================================================================
  /// Crée une nouvelle instance d'utilisateur avec toutes les propriétés requises
  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.dateNaissance,
    required this.dateCreation,
  });

  // =============================================================================
  // MÉTHODES DE SÉRIALISATION
  // =============================================================================
  
  /// Crée un UserModel à partir d'une Map (utilisé pour Firebase/SQLite)
  /// Cette méthode est utilisée pour convertir les données de la base de données
  /// en objet UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      // Conversion des chaînes de date en objets DateTime
      dateNaissance: DateTime.parse(map['dateNaissance']),
      dateCreation: DateTime.parse(map['dateCreation']),
    );
  }

  /// Convertit le UserModel en Map pour le stockage en base de données
  /// Cette méthode est utilisée pour sauvegarder les données utilisateur
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      // Conversion des DateTime en chaînes ISO pour le stockage
      'dateNaissance': dateNaissance.toIso8601String(),
      'dateCreation': dateCreation.toIso8601String(),
    };
  }

  // =============================================================================
  // GETTERS UTILITAIRES
  // =============================================================================
  
  /// Retourne l'initiale du nom d'utilisateur pour l'avatar
  /// Utilisé pour afficher un avatar avec l'initiale de l'utilisateur
  String get initiale => username.isNotEmpty ? username[0].toUpperCase() : '?';
} 