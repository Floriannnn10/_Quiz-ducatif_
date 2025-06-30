// =============================================================================
// POINT D'ENTRÉE PRINCIPAL DE L'APPLICATION QUIZ ÉDUCATIF
// =============================================================================
// Ce fichier contient la configuration initiale de l'application Flutter,
// l'initialisation de Firebase, la configuration des providers et le thème.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'providers/score_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// =============================================================================
// FONCTION MAIN - POINT D'ENTRÉE DE L'APPLICATION
// =============================================================================
// Cette fonction est appelée au démarrage de l'application
// Elle initialise Firebase et lance l'application Flutter
void main() async {
  // Assure que Flutter est initialisé avant d'utiliser les plugins
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialise Firebase avec les options de configuration
  // Ces options sont générées automatiquement par flutterfire configure
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Lance l'application Flutter
  runApp(const MyApp());
}

// =============================================================================
// CLASSE PRINCIPALE DE L'APPLICATION
// =============================================================================
// Cette classe configure l'application Flutter avec :
// - Les providers pour la gestion d'état
// - Le thème de l'application
// - La navigation initiale
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // =============================================================================
      // CONFIGURATION DES PROVIDERS
      // =============================================================================
      // Les providers permettent de gérer l'état global de l'application
      // Chaque provider est accessible dans toute l'application
      providers: [
        // Provider pour la gestion de l'authentification
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Provider pour la gestion des scores
        ChangeNotifierProvider(create: (_) => ScoreProvider()),
      ],
      child: MaterialApp(
        title: 'Quiz Éducatif',
        // Désactive la bannière de debug en mode développement
        debugShowCheckedModeBanner: false,
        
        // =============================================================================
        // CONFIGURATION DU THÈME
        // =============================================================================
        theme: ThemeData(
          // Mode clair par défaut
          brightness: Brightness.light,
          // Couleur principale de l'application
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue[600],
          // Couleur de fond de l'application
          scaffoldBackgroundColor: Colors.grey[50],
          // Couleur des cartes
          cardColor: Colors.white,
          
          // =============================================================================
          // THÈME DE LA BARRE D'APPLICATION
          // =============================================================================
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black87),
          ),
          
          // =============================================================================
          // THÈME DES BOUTONS ÉLEVÉS
          // =============================================================================
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          
          // =============================================================================
          // THÈME DES CHAMPS DE SAISIE
          // =============================================================================
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        
        // =============================================================================
        // ÉCRAN D'ACCUEIL
        // =============================================================================
        // L'application commence par l'écran de splash
        home: const SplashScreen(),
      ),
    );
  }
}

// =============================================================================
// WRAPPER D'AUTHENTIFICATION
// =============================================================================
// Cette classe gère la navigation automatique selon l'état d'authentification
// Elle affiche l'écran approprié selon que l'utilisateur est connecté ou non
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // =============================================================================
        // ÉTAT DE CHARGEMENT
        // =============================================================================
        // Affiche un indicateur de chargement pendant l'initialisation
        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // =============================================================================
        // UTILISATEUR AUTHENTIFIÉ
        // =============================================================================
        // Si l'utilisateur est connecté, affiche l'écran principal
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        }

        // =============================================================================
        // UTILISATEUR NON AUTHENTIFIÉ
        // =============================================================================
        // Si l'utilisateur n'est pas connecté, affiche l'écran de connexion
        return const LoginScreen();
      },
    );
  }
}
