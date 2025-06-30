// =============================================================================
// MODÈLE SCORE - REPRÉSENTATION DES RÉSULTATS DE QUIZ
// =============================================================================
// Ce fichier définit la structure des scores utilisateur, incluant les calculs
// de pourcentage et les méthodes de sérialisation pour la persistance

import 'question_model.dart';

// =============================================================================
// CLASSE PRINCIPALE SCORE
// =============================================================================
/// Modèle représentant un score de quiz avec toutes ses métadonnées
/// Inclut les calculs de performance et les méthodes de sérialisation
class ScoreModel {
  // =============================================================================
  // PROPRIÉTÉS DU SCORE
  // =============================================================================
  
  /// Identifiant unique du score
  final String id;
  
  /// Identifiant de l'utilisateur qui a obtenu ce score
  final String userId;
  
  /// Catégorie du quiz (Culture Générale, Programmation, etc.)
  final Categorie categorie;
  
  /// Niveau de difficulté du quiz (Facile, Moyen, Difficile)
  final Difficulte difficulte;
  
  /// Nombre de bonnes réponses obtenues
  final int score;
  
  /// Nombre total de questions dans le quiz
  final int totalQuestions;
  
  /// Date et heure de réalisation du quiz
  final DateTime dateQuiz;

  // =============================================================================
  // CONSTRUCTEUR
  // =============================================================================
  /// Crée un nouveau score avec toutes ses propriétés
  ScoreModel({
    required this.id,
    required this.userId,
    required this.categorie,
    required this.difficulte,
    required this.score,
    required this.totalQuestions,
    required this.dateQuiz,
  });

  // =============================================================================
  // MÉTHODES DE SÉRIALISATION
  // =============================================================================
  
  /// Crée un ScoreModel à partir d'une Map (pour la base de données)
  /// Convertit les chaînes de catégorie et difficulté en enums
  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    return ScoreModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      // Conversion de la chaîne en enum Categorie
      categorie: Categorie.values.firstWhere(
        (e) => e.toString() == 'Categorie.${map['categorie']}',
        orElse: () => Categorie.cultureGenerale,
      ),
      // Conversion de la chaîne en enum Difficulte
      difficulte: Difficulte.values.firstWhere(
        (e) => e.toString() == 'Difficulte.${map['difficulte']}',
        orElse: () => Difficulte.facile,
      ),
      score: map['score'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 10,
      // Conversion de la chaîne de date en DateTime
      dateQuiz: DateTime.parse(map['dateQuiz']),
    );
  }

  /// Convertit le ScoreModel en Map pour le stockage en base de données
  /// Convertit les enums en chaînes pour la persistance
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      // Conversion des enums en chaînes (sans le préfixe de l'enum)
      'categorie': categorie.toString().split('.').last,
      'difficulte': difficulte.toString().split('.').last,
      'score': score,
      'totalQuestions': totalQuestions,
      // Conversion du DateTime en chaîne ISO pour le stockage
      'dateQuiz': dateQuiz.toIso8601String(),
    };
  }

  // =============================================================================
  // CALCULS DE PERFORMANCE
  // =============================================================================
  
  /// Calcule le pourcentage de réussite du quiz
  /// Retourne une valeur entre 0.0 et 100.0
  double get pourcentage => (score / totalQuestions) * 100;

  // =============================================================================
  // GETTERS POUR L'AFFICHAGE
  // =============================================================================
  
  /// Retourne le nom français de la catégorie pour l'affichage
  String get categorieString {
    switch (categorie) {
      case Categorie.cultureGenerale:
        return 'Culture Générale';
      case Categorie.programmation:
        return 'Programmation';
      case Categorie.mathematiques:
        return 'Mathématiques';
      case Categorie.histoire:
        return 'Histoire';
    }
  }

  /// Retourne le nom français du niveau de difficulté pour l'affichage
  String get difficulteString {
    switch (difficulte) {
      case Difficulte.facile:
        return 'Facile';
      case Difficulte.moyen:
        return 'Moyen';
      case Difficulte.difficile:
        return 'Difficile';
    }
  }
} 