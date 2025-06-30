import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../models/question_model.dart';
import 'quiz_screen.dart';
import 'scores_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Quiz Éducatif',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  // Afficher une boîte de dialogue de confirmation
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Déconnexion',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        content: Text(
                          'Voulez-vous vraiment vous déconnecter ?',
                          style: GoogleFonts.poppins(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              'Annuler',
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              'Déconnecter',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  // Si l'utilisateur confirme, procéder à la déconnexion
                  if (shouldLogout == true) {
                    await authProvider.signOut();
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final userData = authProvider.userData;
          final firebaseUser = authProvider.firebaseUser;
          
          // Utiliser les données Firebase directement pour un affichage immédiat
          String username = 'Utilisateur';
          String email = '';
          String initiale = '?';
          
          if (firebaseUser != null) {
            email = firebaseUser.email ?? '';
            // Extraire le username de l'email (partie avant @) si pas de displayName
            username = firebaseUser.displayName ?? email.split('@')[0];
            initiale = username.isNotEmpty ? username[0].toUpperCase() : '?';
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec avatar et nom d'utilisateur
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
                  child: Row(
                    children: [
                      // Avatar circulaire
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          initiale,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Texte de bienvenue
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonjour $username',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Prêt à tester vos connaissances ?',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Titre des catégories
                Text(
                  'Choisissez une catégorie',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),

                // Grille des catégories
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.1,
                  children: [
                    _buildCategoryCard(
                      context,
                      'Culture Générale',
                      Icons.public,
                      Colors.blue,
                      Categorie.cultureGenerale,
                    ),
                    _buildCategoryCard(
                      context,
                      'Programmation',
                      Icons.code,
                      Colors.green,
                      Categorie.programmation,
                    ),
                    _buildCategoryCard(
                      context,
                      'Mathématiques',
                      Icons.calculate,
                      Colors.orange,
                      Categorie.mathematiques,
                    ),
                    _buildCategoryCard(
                      context,
                      'Histoire',
                      Icons.history_edu,
                      Colors.purple,
                      Categorie.histoire,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Bouton pour voir les scores
                SizedBox(
                  width: double.infinity,
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
                      'Voir mes scores',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Categorie categorie,
  ) {
    return InkWell(
      onTap: () {
        _showDifficultyDialog(context, categorie);
      },
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: color,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showDifficultyDialog(BuildContext context, Categorie categorie) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Choisissez la difficulté',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDifficultyButton(context, 'Facile', Difficulte.facile, Colors.green, categorie),
              const SizedBox(height: 8),
              _buildDifficultyButton(context, 'Moyen', Difficulte.moyen, Colors.orange, categorie),
              const SizedBox(height: 8),
              _buildDifficultyButton(context, 'Difficile', Difficulte.difficile, Colors.red, categorie),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDifficultyButton(
    BuildContext context,
    String text,
    Difficulte difficulte,
    Color color,
    Categorie categorie,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QuizScreen(
                categorie: categorie,
                difficulte: difficulte,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
} 