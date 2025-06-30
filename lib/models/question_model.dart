enum Categorie {
  cultureGenerale,
  programmation,
  mathematiques,
  histoire,
}

enum Difficulte {
  facile,
  moyen,
  difficile,
}

// Extensions pour accéder aux getters directement sur les enums
extension CategorieExtension on Categorie {
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

extension DifficulteExtension on Difficulte {
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

class QuestionModel {
  final String id;
  final String question;
  final List<String> reponses;
  final int bonneReponse;
  final Categorie categorie;
  final Difficulte difficulte;

  QuestionModel({
    required this.id,
    required this.question,
    required this.reponses,
    required this.bonneReponse,
    required this.categorie,
    required this.difficulte,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] ?? '',
      question: map['question'] ?? '',
      reponses: List<String>.from(map['reponses']),
      bonneReponse: map['bonneReponse'] ?? 0,
      categorie: Categorie.values.firstWhere(
        (e) => e.toString() == 'Categorie.${map['categorie']}',
        orElse: () => Categorie.cultureGenerale,
      ),
      difficulte: Difficulte.values.firstWhere(
        (e) => e.toString() == 'Difficulte.${map['difficulte']}',
        orElse: () => Difficulte.facile,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'reponses': reponses,
      'bonneReponse': bonneReponse,
      'categorie': categorie.toString().split('.').last,
      'difficulte': difficulte.toString().split('.').last,
    };
  }
} 