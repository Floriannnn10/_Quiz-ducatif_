import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/score_model.dart';
import '../models/user_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'quiz_educatif.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table des utilisateurs
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        username TEXT NOT NULL,
        email TEXT NOT NULL,
        dateNaissance TEXT NOT NULL,
        dateCreation TEXT NOT NULL
      )
    ''');

    // Table des scores
    await db.execute('''
      CREATE TABLE scores (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        categorie TEXT NOT NULL,
        difficulte TEXT NOT NULL,
        score INTEGER NOT NULL,
        totalQuestions INTEGER NOT NULL,
        dateQuiz TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  // Méthodes pour les utilisateurs
  Future<void> insertUser(UserModel user) async {
    final db = await database;
    await db.insert('users', user.toMap());
  }

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

  // Méthodes pour les scores
  Future<void> insertScore(ScoreModel score) async {
    final db = await database;
    await db.insert('scores', score.toMap());
  }

  Future<List<ScoreModel>> getScoresByUser(String userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scores',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'dateQuiz DESC',
    );

    return List.generate(maps.length, (i) => ScoreModel.fromMap(maps[i]));
  }

  Future<List<ScoreModel>> getTopScores({int limit = 5}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scores',
      orderBy: 'score DESC, dateQuiz DESC',
      limit: limit,
    );

    return List.generate(maps.length, (i) => ScoreModel.fromMap(maps[i]));
  }

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

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
} 