// =============================================================================
// ÉCRAN DE SPLASH - PREMIER ÉCRAN DE L'APPLICATION
// =============================================================================
// Cet écran s'affiche au démarrage de l'application pendant 3 secondes.
// Il présente le logo et le nom de l'application avec des animations fluides
// avant de rediriger vers l'écran d'authentification.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../main.dart';

// =============================================================================
// CLASSE PRINCIPALE DE L'ÉCRAN DE SPLASH
// =============================================================================
/// Écran de démarrage avec animations et redirection automatique
/// Utilise flutter_animate pour des animations fluides et modernes
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// =============================================================================
// ÉTAT DE L'ÉCRAN DE SPLASH
// =============================================================================
/// Gère l'état et les animations de l'écran de splash
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Démarrer la navigation automatique dès l'initialisation
    _navigateToLogin();
  }

  // =============================================================================
  // MÉTHODE DE NAVIGATION AUTOMATIQUE
  // =============================================================================
  /// Navigue automatiquement vers l'écran d'authentification après 3 secondes
  /// Utilise une transition fluide avec fade pour une expérience utilisateur optimale
  Future<void> _navigateToLogin() async {
    // Attendre 3 secondes pour permettre l'affichage des animations
    await Future.delayed(const Duration(seconds: 3));
    
    // Vérifier que le widget est toujours monté avant la navigation
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          // Page de destination : wrapper d'authentification
          pageBuilder: (context, animation, secondaryAnimation) => const AuthWrapper(),
          
          // Configuration de la transition personnalisée
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Transition en fondu pour un effet fluide
            return FadeTransition(opacity: animation, child: child);
          },
          
          // Durée de la transition (500ms)
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Couleur de fond utilisant la couleur primaire de l'application
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // =============================================================================
            // LOGO ANIMÉ
            // =============================================================================
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                // Ombre portée pour un effet de profondeur
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/image/Logo_image.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
            )
            // Animation d'échelle avec effet élastique
            .animate()
              .scale(duration: 800.ms, curve: Curves.elasticOut)
              .then()
              // Animation de secousse après l'échelle
              .shake(duration: 400.ms),

            const SizedBox(height: 40),

            // =============================================================================
            // TITRE PRINCIPAL
            // =============================================================================
            Text(
              'Quiz Éducatif',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
            // Animation d'apparition en fondu avec délai
            .animate()
              .fadeIn(delay: 300.ms, duration: 800.ms)
              // Animation de glissement depuis le bas
              .slideY(begin: 0.3, end: 0),

            const SizedBox(height: 16),

            // =============================================================================
            // SOUS-TITRE
            // =============================================================================
            Text(
              'Testez vos connaissances',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white.withOpacity(0.8),
              ),
            )
            // Animation d'apparition avec délai plus long
            .animate()
              .fadeIn(delay: 600.ms, duration: 800.ms)
              .slideY(begin: 0.3, end: 0),

            const SizedBox(height: 80),

            // =============================================================================
            // INDICATEUR DE CHARGEMENT
            // =============================================================================
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withOpacity(0.8),
                ),
              ),
            )
            // Animation d'apparition avec rotation continue
            .animate()
              .fadeIn(delay: 900.ms, duration: 600.ms)
              .then()
              .rotate(duration: 2000.ms, curve: Curves.linear),
          ],
        ),
      ),
    );
  }
} 