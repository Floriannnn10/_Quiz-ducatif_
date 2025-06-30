import 'question_model.dart';

class ScoreModel {
  final String id;
  final String userId;
  final Categorie categorie;
  final Difficulte difficulte;
  final int score;
  final int totalQuestions;
  final DateTime dateQuiz;

  ScoreModel({
    required this.id,
    required this.userId,
    required this.categorie,
    required this.difficulte,
    required this.score,
    required this.totalQuestions,
    required this.dateQuiz,
  });

  factory ScoreModel.fromMap(Map<String, dynamic> map) {
    return ScoreModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      categorie: Categorie.values.firstWhere(
        (e) => e.toString() == 'Categorie.${map['categorie']}',
        orElse: () => Categorie.cultureGenerale,
      ),
      difficulte: Difficulte.values.firstWhere(
        (e) => e.toString() == 'Difficulte.${map['difficulte']}',
        orElse: () => Difficulte.facile,
      ),
      score: map['score'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 10,
      dateQuiz: DateTime.parse(map['dateQuiz']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'categorie': categorie.toString().split('.').last,
      'difficulte': difficulte.toString().split('.').last,
      'score': score,
      'totalQuestions': totalQuestions,
      'dateQuiz': dateQuiz.toIso8601String(),
    };
  }

  double get pourcentage => (score / totalQuestions) * 100;

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