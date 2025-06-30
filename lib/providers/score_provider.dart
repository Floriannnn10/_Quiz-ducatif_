import 'package:flutter/material.dart';
import '../models/score_model.dart';
import '../services/database_service.dart';

class ScoreProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<ScoreModel> _userScores = [];
  List<ScoreModel> _topScores = [];
  bool _isLoading = false;

  List<ScoreModel> get userScores => _userScores;
  List<ScoreModel> get topScores => _topScores;
  bool get isLoading => _isLoading;

  // Charger les scores de l'utilisateur
  Future<void> loadUserScores(String userId) async {
    _setLoading(true);
    try {
      _userScores = await _databaseService.getScoresByUser(userId);
      notifyListeners();
    } catch (e) {
      print('Erreur lors du chargement des scores: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Charger les meilleurs scores
  Future<void> loadTopScores({int limit = 5}) async {
    _setLoading(true);
    try {
      _topScores = await _databaseService.getTopScores(limit: limit);
      notifyListeners();
    } catch (e) {
      print('Erreur lors du chargement des meilleurs scores: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Charger les meilleurs scores par catégorie et difficulté
  Future<List<ScoreModel>> getTopScoresByCategory(
    String categorie,
    String difficulte, {
    int limit = 5,
  }) async {
    try {
      return await _databaseService.getTopScoresByCategory(
        categorie,
        difficulte,
        limit: limit,
      );
    } catch (e) {
      print('Erreur lors du chargement des scores par catégorie: $e');
      return [];
    }
  }

  // Sauvegarder un nouveau score
  Future<void> saveScore(ScoreModel score) async {
    try {
      await _databaseService.insertScore(score);
      // Recharger les scores de l'utilisateur
      if (score.userId.isNotEmpty) {
        await loadUserScores(score.userId);
      }
      // Recharger les meilleurs scores
      await loadTopScores();
    } catch (e) {
      print('Erreur lors de la sauvegarde du score: $e');
    }
  }

  // Obtenir le meilleur score de l'utilisateur
  ScoreModel? getBestUserScore(String userId) {
    if (_userScores.isEmpty) return null;
    return _userScores.reduce((a, b) => a.score > b.score ? a : b);
  }

  // Obtenir le score moyen de l'utilisateur
  double getUserAverageScore(String userId) {
    if (_userScores.isEmpty) return 0.0;
    double total = _userScores.fold(0.0, (sum, score) => sum + score.pourcentage);
    return total / _userScores.length;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
} 