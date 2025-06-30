import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const AuthWrapper(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo animé
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.quiz,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
            ).animate()
              .scale(duration: 800.ms, curve: Curves.elasticOut)
              .then()
              .shake(duration: 400.ms),

            const SizedBox(height: 40),

            // Titre principal
            Text(
              'Quiz Éducatif',
              style: GoogleFonts.poppins(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ).animate()
              .fadeIn(delay: 300.ms, duration: 800.ms)
              .slideY(begin: 0.3, end: 0),

            const SizedBox(height: 16),

            // Sous-titre
            Text(
              'Testez vos connaissances',
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white.withOpacity(0.8),
              ),
            ).animate()
              .fadeIn(delay: 600.ms, duration: 800.ms)
              .slideY(begin: 0.3, end: 0),

            const SizedBox(height: 80),

            // Indicateur de chargement
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withOpacity(0.8),
                ),
              ),
            ).animate()
              .fadeIn(delay: 900.ms, duration: 600.ms)
              .then()
              .rotate(duration: 2000.ms, curve: Curves.linear),
          ],
        ),
      ),
    );
  }
} 