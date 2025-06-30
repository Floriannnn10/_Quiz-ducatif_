// =============================================================================
// MODÈLE QUESTION - REPRÉSENTATION DES QUESTIONS DU QUIZ
// =============================================================================
// Ce fichier définit la structure des questions, les catégories et niveaux de difficulté
// Il inclut les enums pour la catégorisation et les extensions pour l'affichage

// =============================================================================
// ÉNUMÉRATIONS POUR LA CATÉGORISATION
// =============================================================================

/// Catégories de questions disponibles dans l'application
/// Chaque catégorie représente un domaine de connaissances différent
enum Categorie {
  cultureGenerale,  // Questions de culture générale
  programmation,    // Questions sur la programmation et l'informatique
  mathematiques,    // Questions de mathématiques
  histoire,         // Questions d'histoire
}

/// Niveaux de difficulté des questions
/// Permet d'adapter la complexité selon le niveau de l'utilisateur
enum Difficulte {
  facile,    // Questions simples pour débutants
  moyen,     // Questions intermédiaires
  difficile, // Questions complexes pour experts
}

// =============================================================================
// EXTENSIONS POUR L'AFFICHAGE
// =============================================================================
// Ces extensions permettent d'obtenir les chaînes d'affichage directement
// depuis les enums, facilitant l'utilisation dans l'interface utilisateur

/// Extension pour obtenir le nom affichable des catégories
extension CategorieExtension on Categorie {
  /// Retourne le nom français de la catégorie pour l'affichage
  String get categorieString {
    switch (this) {
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
}

/// Extension pour obtenir le nom affichable des niveaux de difficulté
extension DifficulteExtension on Difficulte {
  /// Retourne le nom français du niveau de difficulté pour l'affichage
  String get difficulteString {
    switch (this) {
      case Difficulte.facile:
        return 'Facile';
      case Difficulte.moyen:
        return 'Moyen';
      case Difficulte.difficile:
        return 'Difficile';
    }
  }
}

// =============================================================================
// CLASSE PRINCIPALE QUESTION
// =============================================================================
/// Modèle représentant une question de quiz avec toutes ses propriétés
/// Inclut les méthodes de sérialisation pour le stockage en base de données
class QuestionModel {
  // =============================================================================
  // PROPRIÉTÉS DE LA QUESTION
  // =============================================================================
  
  /// Identifiant unique de la question
  final String id;
  
  /// Texte de la question
  final String question;
  
  /// Liste des réponses possibles (généralement 4 réponses)
  final List<String> reponses;
  
  /// Index de la bonne réponse dans la liste des réponses (0-3)
  final int bonneReponse;
  
  /// Catégorie de la question
  final Categorie categorie;
  
  /// Niveau de difficulté de la question
  final Difficulte difficulte;

  // =============================================================================
  // CONSTRUCTEUR
  // =============================================================================
  /// Crée une nouvelle question avec toutes ses propriétés
  QuestionModel({
    required this.id,
    required this.question,
    required this.reponses,
    required this.bonneReponse,
    required this.categorie,
    required this.difficulte,
  });

  // =============================================================================
  // MÉTHODES DE SÉRIALISATION
  // =============================================================================
  
  /// Crée un QuestionModel à partir d'une Map (pour la base de données)
  /// Convertit les chaînes de catégorie et difficulté en enums
  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      reponses: List<String>.from(map['reponses']),
      bonneReponse: map['bonneReponse'] ?? 0,
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
    );
  }

  /// Convertit le QuestionModel en Map pour le stockage en base de données
  /// Convertit les enums en chaînes pour la persistance
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'reponses': reponses,
      'bonneReponse': bonneReponse,
      // Conversion des enums en chaînes (sans le préfixe de l'enum)
      'categorie': categorie.toString().split('.').last,
      'difficulte': difficulte.toString().split('.').last,
    };
  }
} 