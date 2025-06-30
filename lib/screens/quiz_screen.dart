import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:uuid/uuid.dart';
import '../models/question_model.dart';
import '../models/score_model.dart';
import '../providers/auth_provider.dart';
import '../providers/score_provider.dart';
import '../services/question_service.dart';
import 'quiz_result_screen.dart'; 

/// Écran principal du quiz
/// Gère l'affichage des questions, la sélection des réponses et le suivi du score
/// Utilise des animations pour une expérience utilisateur fluide et engageante
class QuizScreen extends StatefulWidget {
  final Categorie categorie;
  final Difficulte difficulte;

  const QuizScreen({
    super.key,
    required this.categorie,
    required this.difficulte,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Variables d'état pour gérer le quiz
  late List<QuestionModel> _questions;        // Liste des questions du quiz
  int _currentQuestionIndex = 0;              // Index de la question actuelle
  int _score = 0;                            // Score actuel de l'utilisateur
  int? _selectedAnswer;                       // Réponse sélectionnée par l'utilisateur
  bool _answered = false;                     // Indique si la question a été répondue
  bool _isLoading = true;                     // État de chargement des questions

  @override
  void initState() {
    super.initState();
    // Chargement des questions au démarrage
    _loadQuestions();
  }

  /// Chargement des questions depuis le service selon la catégorie et difficulté
  void _loadQuestions() {
    _questions = QuestionService.getQuestions(widget.categorie, widget.difficulte);
    setState(() {
      _isLoading = false;
    });
  }

  /// Gestion de la sélection d'une réponse par l'utilisateur
  void _selectAnswer(int answerIndex) {
    // Empêcher la sélection multiple
    if (_answered) return;

    setState(() {
      _selectedAnswer = answerIndex;
      _answered = true;
    });

    // Vérification de la réponse et mise à jour du score
    if (answerIndex == _questions[_currentQuestionIndex].bonneReponse) {
      _score++;
    }

    // Délai avant de passer à la question suivante pour permettre la visualisation
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  /// Passage à la question suivante ou fin du quiz
  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      // Passage à la question suivante
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
    } else {
      // Fin du quiz - sauvegarde du score et navigation vers les résultats
      _finishQuiz();
    }
  }

  /// Finalisation du quiz avec sauvegarde du score
  void _finishQuiz() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final scoreProvider = Provider.of<ScoreProvider>(context, listen: false);

    // Création du modèle de score avec un ID unique
    final score = ScoreModel(
      id: const Uuid().v4(),
      userId: authProvider.firebaseUser!.uid,
      categorie: widget.categorie,
      difficulte: widget.difficulte,
      score: _score,
      totalQuestions: _questions.length,
      dateQuiz: DateTime.now(),
    );

    // Sauvegarde du score dans la base de données
    await scoreProvider.saveScore(score);

    // Navigation vers l'écran de résultats
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(
            score: score,
            questions: _questions,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Affichage de l'écran de chargement pendant le chargement des questions
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Récupération de la question actuelle et calcul du progrès
    final currentQuestion = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Barre d'application avec navigation et titre
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${widget.categorie.categorieString} - ${widget.difficulte.difficulteString}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: Column(
        children: [
          // SECTION 1: Barre de progression et informations du quiz
          _buildProgressSection(progress),
          
          // SECTION 2: Contenu principal avec question et réponses
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Affichage de la question actuelle
                  _buildQuestionCard(currentQuestion),
                  
                  const SizedBox(height: 24),
                  
                  // Liste des réponses possibles
                  Expanded(
                    child: _buildAnswersList(currentQuestion),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Construction de la section de progression avec score et barre de progression
  Widget _buildProgressSection(double progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Informations sur la progression et le score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${_currentQuestionIndex + 1}/${_questions.length}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Score: $_score',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Barre de progression visuelle
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  /// Construction de la carte de question
  Widget _buildQuestionCard(QuestionModel currentQuestion) {
    return Container(
      width: double.infinity,
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
      child: Text(
        currentQuestion.question,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0);
  }

  /// Construction de la liste des réponses avec gestion des états
  Widget _buildAnswersList(QuestionModel currentQuestion) {
    return ListView.builder(
      itemCount: currentQuestion.reponses.length,
      itemBuilder: (context, index) {
        // Détermination des états pour l'affichage visuel
        final isCorrect = index == currentQuestion.bonneReponse;
        final isSelected = _selectedAnswer == index;
        final showResult = _answered;

        // Gestion des couleurs selon l'état de la réponse
        Color backgroundColor = Colors.white;
        Color borderColor = Colors.grey.shade300;

        if (showResult) {
          // Affichage des résultats après réponse
          if (isCorrect) {
            backgroundColor = Colors.green.withOpacity(0.1);
            borderColor = Colors.green;
          } else if (isSelected && !isCorrect) {
            backgroundColor = Colors.red.withOpacity(0.1);
            borderColor = Colors.red;
          }
        } else if (isSelected) {
          // Réponse sélectionnée mais pas encore validée
          backgroundColor = Theme.of(context).primaryColor.withOpacity(0.1);
          borderColor = Theme.of(context).primaryColor;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => _selectAnswer(index),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor),
              ),
              child: Row(
                children: [
                  // Indicateur de sélection (radio button personnalisé)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor),
                      color: isSelected ? borderColor : Colors.transparent,
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  // Texte de la réponse
                  Expanded(
                    child: Text(
                      currentQuestion.reponses[index],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // Icônes de validation (correct/incorrect)
                  if (showResult && isCorrect)
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20,
                    ),
                  if (showResult && isSelected && !isCorrect)
                    Icon(
                      Icons.cancel,
                      color: Colors.red,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(delay: (index * 100).ms).slideX(begin: 0.3, end: 0);
      },
    );
  }
} 