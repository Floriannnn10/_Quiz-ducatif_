import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/score_provider.dart';
import '../models/score_model.dart';
import '../models/question_model.dart';

/// Écran d'affichage des scores utilisateur
/// Présente un résumé des performances, l'historique des parties et les statistiques
/// Interface moderne avec cartes et graphiques de performance
class ScoresScreen extends StatefulWidget {
  const ScoresScreen({super.key});

  @override
  State<ScoresScreen> createState() => _ScoresScreenState();
}

class _ScoresScreenState extends State<ScoresScreen> {
  @override
  void initState() {
    super.initState();
    // Chargement des données utilisateur après la construction du widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final scoreProvider = Provider.of<ScoreProvider>(context, listen: false);
      
      // Chargement des scores de l'utilisateur connecté et des meilleurs scores
      if (authProvider.firebaseUser != null) {
        scoreProvider.loadUserScores(authProvider.firebaseUser!.uid);
        scoreProvider.loadTopScores();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Barre d'application avec titre et navigation
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Mes Scores',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer2<AuthProvider, ScoreProvider>(
        builder: (context, authProvider, scoreProvider, child) {
          // Affichage de l'indicateur de chargement pendant le chargement des données
          if (scoreProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SECTION 1: Résumé des performances avec statistiques
                _buildSummaryCard(authProvider, scoreProvider),
                const SizedBox(height: 24),

                // SECTION 2: Titre de l'historique
                Text(
                  'Historique des parties',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // SECTION 3: Liste des scores ou état vide
                if (scoreProvider.userScores.isEmpty)
                  _buildEmptyState()
                else
                  _buildScoresList(scoreProvider.userScores),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Construction de la carte de résumé des performances
  Widget _buildSummaryCard(AuthProvider authProvider, ScoreProvider scoreProvider) {
    // Calcul des statistiques de performance
    final bestScore = scoreProvider.getBestUserScore(authProvider.firebaseUser!.uid);
    final averageScore = scoreProvider.getUserAverageScore(authProvider.firebaseUser!.uid);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre de la section
          Text(
            'Résumé de vos performances',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          // Première ligne de statistiques
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Meilleur score',
                  bestScore != null ? '${bestScore.score}/${bestScore.totalQuestions}' : 'N/A',
                  Icons.emoji_events,
                  Colors.amber,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Moyenne',
                  '${averageScore.toStringAsFixed(1)}%',
                  Icons.trending_up,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Deuxième ligne de statistiques
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Parties jouées',
                  '${scoreProvider.userScores.length}',
                  Icons.play_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Catégories',
                  '${scoreProvider.userScores.map((s) => s.categorie).toSet().length}',
                  Icons.category,
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construction d'une carte de statistique individuelle
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          // Icône de la statistique
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          // Valeur de la statistique
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          // Titre de la statistique
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Construction de l'état vide quand aucun score n'est disponible
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          // Icône illustrative
          Icon(
            Icons.quiz_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          // Message principal
          Text(
            'Aucun score enregistré',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          // Message d'encouragement
          Text(
            'Commencez par jouer à quelques quiz !',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Construction de la liste des scores utilisateur
  Widget _buildScoresList(List<ScoreModel> scores) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: scores.length,
      itemBuilder: (context, index) {
        final score = scores[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            // Avatar avec icône de catégorie
            leading: CircleAvatar(
              backgroundColor: _getCategoryColor(score.categorie),
              child: Icon(
                _getCategoryIcon(score.categorie),
                color: Colors.white,
              ),
            ),
            // Titre avec nom de la catégorie
            title: Text(
              score.categorieString,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            // Sous-titre avec difficulté et date
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  '${score.difficulteString} • ${DateFormat('dd/MM/yyyy HH:mm').format(score.dateQuiz)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            // Score et pourcentage à droite
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${score.score}/${score.totalQuestions}',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getScoreColor(score.pourcentage),
                  ),
                ),
                Text(
                  '${score.pourcentage.toStringAsFixed(0)}%',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Obtention de la couleur associée à une catégorie
  Color _getCategoryColor(Categorie categorie) {
    switch (categorie) {
      case Categorie.cultureGenerale:
        return Colors.blue;
      case Categorie.programmation:
        return Colors.green;
      case Categorie.mathematiques:
        return Colors.orange;
      case Categorie.histoire:
        return Colors.purple;
    }
  }

  /// Obtention de l'icône associée à une catégorie
  IconData _getCategoryIcon(Categorie categorie) {
    switch (categorie) {
      case Categorie.cultureGenerale:
        return Icons.public;
      case Categorie.programmation:
        return Icons.code;
      case Categorie.mathematiques:
        return Icons.calculate;
      case Categorie.histoire:
        return Icons.history_edu;
    }
  }

  /// Obtention de la couleur du score selon le pourcentage de réussite
  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }
} 