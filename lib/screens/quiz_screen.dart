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
  late List<QuestionModel> _questions;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  bool _answered = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() {
    _questions = QuestionService.getQuestions(widget.categorie, widget.difficulte);
    setState(() {
      _isLoading = false;
    });
  }

  void _selectAnswer(int answerIndex) {
    if (_answered) return;

    setState(() {
      _selectedAnswer = answerIndex;
      _answered = true;
    });

    // Vérifier si la réponse est correcte
    if (answerIndex == _questions[_currentQuestionIndex].bonneReponse) {
      _score++;
    }

    // Attendre un peu avant de passer à la question suivante
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _answered = false;
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final scoreProvider = Provider.of<ScoreProvider>(context, listen: false);

    // Créer le score
    final score = ScoreModel(
      id: const Uuid().v4(),
      userId: authProvider.firebaseUser!.uid,
      categorie: widget.categorie,
      difficulte: widget.difficulte,
      score: _score,
      totalQuestions: _questions.length,
      dateQuiz: DateTime.now(),
    );

    // Sauvegarder le score
    await scoreProvider.saveScore(score);

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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: Colors.grey[50],
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
          // Barre de progression
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
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
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Contenu principal
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Question
                  Container(
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
                  ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 24),

                  // Réponses
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQuestion.reponses.length,
                      itemBuilder: (context, index) {
                        final isCorrect = index == currentQuestion.bonneReponse;
                        final isSelected = _selectedAnswer == index;
                        final showResult = _answered;

                        Color backgroundColor = Colors.white;
                        Color borderColor = Colors.grey.shade300;

                        if (showResult) {
                          if (isCorrect) {
                            backgroundColor = Colors.green.withOpacity(0.1);
                            borderColor = Colors.green;
                          } else if (isSelected && !isCorrect) {
                            backgroundColor = Colors.red.withOpacity(0.1);
                            borderColor = Colors.red;
                          }
                        } else if (isSelected) {
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
                                  Expanded(
                                    child: Text(
                                      currentQuestion.reponses[index],
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
} 