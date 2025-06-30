import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/score_model.dart';
import '../models/question_model.dart';
import '../providers/score_provider.dart';
import 'home_screen.dart';
import 'scores_screen.dart';

class QuizResultScreen extends StatefulWidget {
  final ScoreModel score;
  final List<QuestionModel> questions;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.questions,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  List<ScoreModel> _topScores = [];

  @override
  void initState() {
    super.initState();
    _loadTopScores();
  }

  Future<void> _loadTopScores() async {
    final scoreProvider = Provider.of<ScoreProvider>(context, listen: false);
    _topScores = await scoreProvider.getTopScoresByCategory(
      widget.score.categorie.toString().split('.').last,
      widget.score.difficulte.toString().split('.').last,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final percentage = widget.score.pourcentage;
    final isExcellent = percentage >= 90;
    final isGood = percentage >= 70;
    final isAverage = percentage >= 50;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Résultat principal
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Icône de résultat
                    Icon(
                      isExcellent
                          ? Icons.emoji_events
                          : isGood
                              ? Icons.thumb_up
                              : isAverage
                                  ? Icons.sentiment_satisfied
                                  : Icons.sentiment_dissatisfied,
                      size: 80,
                      color: isExcellent
                          ? Colors.amber
                          : isGood
                              ? Colors.green
                              : isAverage
                                  ? Colors.orange
                                  : Colors.red,
                    ).animate().scale(duration: 600.ms).then().shake(),

                    const SizedBox(height: 24),

                    // Score
                    Text(
                      '${widget.score.score}/${widget.score.totalQuestions}',
                      style: GoogleFonts.poppins(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ).animate().fadeIn(delay: 200.ms),

                    Text(
                      '${percentage.toStringAsFixed(0)}%',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ).animate().fadeIn(delay: 400.ms),

                    const SizedBox(height: 16),

                    // Message de félicitations
                    Text(
                      _getCongratulationMessage(percentage),
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(delay: 600.ms),

                    const SizedBox(height: 8),

                    Text(
                      '${widget.score.categorieString} - ${widget.score.difficulteString}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ).animate().fadeIn(delay: 800.ms),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Meilleurs scores
              if (_topScores.isNotEmpty) ...[
                Container(
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
                      Text(
                        'Top 5 - ${widget.score.categorieString} (${widget.score.difficulteString})',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...List.generate(
                        _topScores.length,
                        (index) => _buildTopScoreItem(_topScores[index], index + 1),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.3, end: 0),

                const SizedBox(height: 24),
              ],

              // Boutons d'action
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.home),
                      label: Text(
                        'Accueil',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ScoresScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.leaderboard),
                      label: Text(
                        'Mes scores',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.3, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopScoreItem(ScoreModel score, int rank) {
    final isCurrentUser = score.id == widget.score.id;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrentUser ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: isCurrentUser ? Border.all(color: Theme.of(context).primaryColor) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: rank <= 3 ? Colors.amber : Colors.grey[400],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${score.score}/${score.totalQuestions} (${score.pourcentage.toStringAsFixed(0)}%)',
              style: GoogleFonts.poppins(
                fontWeight: isCurrentUser ? FontWeight.w600 : FontWeight.normal,
                color: isCurrentUser ? Theme.of(context).primaryColor : Colors.black87,
              ),
            ),
          ),
          if (isCurrentUser)
            Icon(
              Icons.star,
              color: Colors.amber,
              size: 20,
            ),
        ],
      ),
    );
  }

  String _getCongratulationMessage(double percentage) {
    if (percentage >= 90) {
      return 'Excellent ! 🎉\nVous êtes un expert !';
    } else if (percentage >= 70) {
      return 'Très bien ! 👏\nBonne performance !';
    } else if (percentage >= 50) {
      return 'Pas mal ! 👍\nContinuez à vous améliorer !';
    } else {
      return 'Pas de panique ! 💪\nLa pratique rend parfait !';
    }
  }
} 