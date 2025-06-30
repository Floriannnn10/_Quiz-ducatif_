// =============================================================================
// SERVICE DE BASE DE DONNÉES - GESTION SQLITE LOCALE
// =============================================================================
// Ce service gère la base de données SQLite locale pour stocker les données
// utilisateur et les scores. Il utilise le pattern Singleton pour garantir
// une seule instance de base de données.

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/score_model.dart';
import '../models/user_model.dart';

// =============================================================================
// CLASSE PRINCIPALE DU SERVICE DE BASE DE DONNÉES
// =============================================================================
/// Service centralisé pour la gestion de la base de données SQLite locale
/// Implémente le pattern Singleton pour optimiser les performances
/// Gère les tables utilisateurs et scores avec des méthodes CRUD complètes
class DatabaseService {
  // =============================================================================
  // PATTERN SINGLETON
  // =============================================================================
  
  /// Instance unique du service (pattern Singleton)
  static final DatabaseService _instance = DatabaseService._internal();
  
  /// Constructeur factory qui retourne l'instance unique
  factory DatabaseService() => _instance;
  
  /// Constructeur privé pour le pattern Singleton
  DatabaseService._internal();

  // =============================================================================
  // GESTION DE LA BASE DE DONNÉES
  // =============================================================================
  
  /// Instance de la base de données SQLite
  static Database? _database;

  /// Getter qui initialise la base de données si nécessaire
  /// Retourne l'instance de base de données existante ou en crée une nouvelle
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialise la base de données SQLite avec les tables nécessaires
  /// Crée le fichier de base de données s'il n'existe pas
  Future<Database> _initDatabase() async {
    // Chemin vers le fichier de base de données
    String path = join(await getDatabasesPath(), 'quiz_educatif.db');
    
    // Ouverture/création de la base de données
    return await openDatabase(
      path,
      version: 1, // Version de la base de données pour les migrations
      onCreate: _onCreate, // Callback appelé lors de la création
    );
  }

  /// Callback appelé lors de la création de la base de données
  /// Crée toutes les tables nécessaires à l'application
  Future<void> _onCreate(Database db, int version) async {
    // =============================================================================
    // TABLE UTILISATEURS
    // =============================================================================
    // Stocke les informations des utilisateurs inscrits
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,           -- Identifiant unique Firebase
        username TEXT NOT NULL,        -- Nom d'utilisateur
        email TEXT NOT NULL,           -- Adresse email
        dateNaissance TEXT NOT NULL,   -- Date de naissance (ISO string)
        dateCreation TEXT NOT NULL     -- Date de création du compte (ISO string)
      )
    ''');

    // =============================================================================
    // TABLE SCORES
    // =============================================================================
    // Stocke les résultats de quiz des utilisateurs
    await db.execute('''
      CREATE TABLE scores (
        id TEXT PRIMARY KEY,           -- Identifiant unique du score
        userId TEXT NOT NULL,          -- Référence vers l'utilisateur
        categorie TEXT NOT NULL,       -- Catégorie du quiz
        difficulte TEXT NOT NULL,      -- Niveau de difficulté
        score INTEGER NOT NULL,        -- Nombre de bonnes réponses
        totalQuestions INTEGER NOT NULL, -- Nombre total de questions
        dateQuiz TEXT NOT NULL,        -- Date du quiz (ISO string)
        FOREIGN KEY (userId) REFERENCES users (id) -- Contrainte d'intégrité
      )
    ''');
  }

  // =============================================================================
  // MÉTHODES CRUD POUR LES UTILISATEURS
  // =============================================================================
  
  /// Insère un nouvel utilisateur dans la base de données
  /// 
  /// [user] : Modèle utilisateur à insérer
  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert('users', user.toMap());
  }

  /// Récupère un utilisateur par son identifiant
  /// 
  /// [id] : Identifiant unique de l'utilisateur
  /// 
  /// Retourne le modèle utilisateur ou null si non trouvé
  Future<UserModel?> getUser(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  // =============================================================================
  // MÉTHODES CRUD POUR LES SCORES
  // =============================================================================
  
  /// Insère un nouveau score dans la base de données
  /// 
  /// [score] : Modèle score à insérer
  Future<void> insertScore(ScoreModel score) async {
    final db = await database;
    await db.insert('scores', score.toMap());
  }

  /// Récupère tous les scores d'un utilisateur spécifique
  /// 
  /// [userId] : Identifiant de l'utilisateur
  /// 
  /// Retourne la liste des scores triés par date (plus récent en premier)
  Future<List<ScoreModel>> getScoresByUser(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scores',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'dateQuiz DESC', // Tri par date décroissante
    );

    return List.generate(maps.length, (i) => ScoreModel.fromMap(maps[i]));
  }

  /// Récupère les meilleurs scores globaux
  /// 
  /// [limit] : Nombre maximum de scores à retourner (défaut: 5)
  /// 
  /// Retourne les scores triés par performance (meilleur score en premier)
  Future<List<ScoreModel>> getTopScores({int limit = 5}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scores',
      orderBy: 'score DESC, dateQuiz DESC', // Tri par score puis par date
      limit: limit,
    );

    return List.generate(maps.length, (i) => ScoreModel.fromMap(maps[i]));
  }

  /// Récupère les meilleurs scores pour une catégorie et difficulté spécifiques
  /// 
  /// [categorie] : Catégorie de questions
  /// [difficulte] : Niveau de difficulté
  /// [limit] : Nombre maximum de scores à retourner (défaut: 5)
  /// 
  /// Retourne les scores filtrés et triés par performance
  Future<List<ScoreModel>> getTopScoresByCategory(
    String categorie,
    String difficulte, {
    int limit = 5,
  }) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scores',
      where: 'categorie = ? AND difficulte = ?',
      whereArgs: [categorie, difficulte],
      orderBy: 'score DESC, dateQuiz DESC',
      limit: limit,
    );

    return List.generate(maps.length, (i) => ScoreModel.fromMap(maps[i]));
  }

  // =============================================================================
  // MÉTHODES DE MAINTENANCE
  // =============================================================================
  
  /// Ferme la connexion à la base de données
  /// À appeler lors de la fermeture de l'application
  Future<void> close() async {
    final db = await database;
    await db.close();
  }
} 