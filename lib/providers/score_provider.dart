// =============================================================================
// PROVIDER DE SCORES - GESTION D'ÉTAT DES RÉSULTATS
// =============================================================================
// Ce provider gère l'état des scores et résultats de quiz dans l'application.
// Il fournit des méthodes pour charger, sauvegarder et analyser les performances
// des utilisateurs avec des calculs de statistiques.

import 'package:flutter/material.dart';
import '../models/score_model.dart';
import '../services/database_service.dart';

// =============================================================================
// CLASSE PRINCIPALE DU PROVIDER DE SCORES
// =============================================================================
/// Provider qui gère l'état des scores et résultats de quiz
/// Utilise ChangeNotifier pour notifier les widgets des changements
/// Fournit des méthodes pour analyser les performances utilisateur
class ScoreProvider with ChangeNotifier {
  // =============================================================================
  // INSTANCES ET PROPRIÉTÉS
  // =============================================================================
  
  /// Service de base de données pour la persistance des scores
  final DatabaseService _databaseService = DatabaseService();
  
  /// Liste des scores de l'utilisateur actuel
  List<ScoreModel> _userScores = [];
  
  /// Liste des meilleurs scores globaux
  List<ScoreModel> _topScores = [];
  
  /// État de chargement pour les opérations de scores
  bool _isLoading = false;

  // =============================================================================
  // GETTERS PUBLICS
  // =============================================================================
  
  /// Scores de l'utilisateur actuel (accessible publiquement)
  List<ScoreModel> get userScores => _userScores;
  
  /// Meilleurs scores globaux (accessible publiquement)
  List<ScoreModel> get topScores => _topScores;
  
  /// État de chargement (accessible publiquement)
  bool get isLoading => _isLoading;

  // =============================================================================
  // MÉTHODES DE CHARGEMENT DES DONNÉES
  // =============================================================================
  
  /// Charge tous les scores d'un utilisateur spécifique
  /// 
  /// [userId] : Identifiant unique de l'utilisateur
  /// 
  /// Met à jour la liste _userScores et notifie les widgets
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

  /// Charge les meilleurs scores globaux de l'application
  /// 
  /// [limit] : Nombre maximum de scores à charger (défaut: 5)
  /// 
  /// Met à jour la liste _topScores et notifie les widgets
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

  /// Charge les meilleurs scores pour une catégorie et difficulté spécifiques
  /// 
  /// [categorie] : Catégorie de questions (Culture Générale, Programmation, etc.)
  /// [difficulte] : Niveau de difficulté (Facile, Moyen, Difficile)
  /// [limit] : Nombre maximum de scores à retourner (défaut: 5)
  /// 
  /// Retourne directement la liste des scores (pas de mise à jour d'état)
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

  // =============================================================================
  // MÉTHODES DE SAUVEGARDE
  // =============================================================================
  
  /// Sauvegarde un nouveau score dans la base de données
  /// 
  /// [score] : Modèle score à sauvegarder
  /// 
  /// Sauvegarde le score et recharge automatiquement les listes mises à jour
  Future<void> saveScore(ScoreModel score) async {
    try {
      // Sauvegarde dans la base de données
      await _databaseService.insertScore(score);
      
      // Recharger les scores de l'utilisateur si l'ID est valide
      if (score.userId.isNotEmpty) {
        await loadUserScores(score.userId);
      }
      
      // Recharger les meilleurs scores globaux
      await loadTopScores();
    } catch (e) {
      print('Erreur lors de la sauvegarde du score: $e');
    }
  }

  // =============================================================================
  // MÉTHODES D'ANALYSE ET STATISTIQUES
  // =============================================================================
  
  /// Obtient le meilleur score d'un utilisateur spécifique
  /// 
  /// [userId] : Identifiant unique de l'utilisateur
  /// 
  /// Retourne le score avec le plus grand nombre de bonnes réponses
  /// ou null si l'utilisateur n'a pas encore de scores
  ScoreModel? getBestUserScore(String userId) {
    if (_userScores.isEmpty) return null;
    return _userScores.reduce((a, b) => a.score > b.score ? a : b);
  }

  /// Calcule le score moyen d'un utilisateur en pourcentage
  /// 
  /// [userId] : Identifiant unique de l'utilisateur
  /// 
  /// Retourne la moyenne des pourcentages de réussite de tous les quiz
  /// ou 0.0 si l'utilisateur n'a pas encore de scores
  double getUserAverageScore(String userId) {
    if (_userScores.isEmpty) return 0.0;
    double total = _userScores.fold(0.0, (sum, score) => sum + score.pourcentage);
    return total / _userScores.length;
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