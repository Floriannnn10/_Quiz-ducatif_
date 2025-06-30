// =============================================================================
// CONFIGURATION FIREBASE - OPTIONS MULTI-PLATEFORME
// =============================================================================
// Ce fichier contient la configuration Firebase pour toutes les plateformes
// supportées par l'application (Web, Android, iOS, macOS, Windows, Linux).
// Il est généré automatiquement par flutterfire configure et doit être
// personnalisé avec vos propres clés Firebase.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

// =============================================================================
// CLASSE PRINCIPALE DE CONFIGURATION FIREBASE
// =============================================================================
/// Configuration Firebase par défaut pour toutes les plateformes
/// Cette classe fournit les options Firebase appropriées selon la plateforme
/// d'exécution de l'application
class DefaultFirebaseOptions {
  // =============================================================================
  // GETTER POUR LA PLATEFORME COURANTE
  // =============================================================================
  /// Retourne les options Firebase appropriées pour la plateforme actuelle
  /// 
  /// Cette méthode détecte automatiquement la plateforme d'exécution et
  /// retourne la configuration Firebase correspondante.
  /// 
  /// Plateformes supportées :
  /// - Web (Chrome, Firefox, Safari, Edge)
  /// - Android (APK, App Bundle)
  /// - iOS (iPhone, iPad)
  /// - macOS (Mac)
  /// - Windows (PC)
  /// - Linux (Ubuntu, etc.)
  static FirebaseOptions get currentPlatform {
    // Détection de la plateforme Web
    if (kIsWeb) {
      return web;
    }
    
    // Détection des plateformes natives
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        return linux;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // =============================================================================
  // ⚠️  CONFIGURATION FIREBASE - À PERSONNALISER
  // =============================================================================
  // REMPLACEZ CES VALEURS PAR VOS VRAIES CLÉS FIREBASE
  // 
  // Pour obtenir vos clés :
  // 1. Allez sur : console.firebase.google.com
  // 2. Sélectionnez votre projet
  // 3. Project Settings → General → Your apps
  // 4. Téléchargez les fichiers de configuration
  // 5. Remplacez les valeurs ci-dessous
  
  // =============================================================================
  // CONFIGURATION WEB
  // =============================================================================
  /// Configuration Firebase pour les applications Web
  /// Utilisée quand l'application s'exécute dans un navigateur
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAKPDayzU1-1v9DC1yYV-OooFeDncRPrBY',
    appId: '1:861922845822:web:xxxxx',
    messagingSenderId: '861922845822',
    projectId: 'quizz-39616',
    authDomain: 'quizz-39616.firebaseapp.com',
    storageBucket: 'quizz-39616.firebasestorage.app',
  );

  // =============================================================================
  // CONFIGURATION ANDROID
  // =============================================================================
  /// Configuration Firebase pour les applications Android
  /// Utilisée pour les APK et App Bundles
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAKPDayzU1-1v9DC1yYV-OooFeDncRPrBY',
    appId: '1:861922845822:android:25370e6059e2a61bcfa42f',
    messagingSenderId: '861922845822',
    projectId: 'quizz-39616',
    storageBucket: 'quizz-39616.firebasestorage.app',
  );

  // =============================================================================
  // CONFIGURATION iOS
  // =============================================================================
  /// Configuration Firebase pour les applications iOS
  /// Utilisée pour iPhone et iPad
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAKPDayzU1-1v9DC1yYV-OooFeDncRPrBY',
    appId: '1:861922845822:ios:xxxxx',
    messagingSenderId: '861922845822',
    projectId: 'quizz-39616',
    storageBucket: 'quizz-39616.firebasestorage.app',
    iosClientId: 'COLLEZ-VOTRE-IOS-CLIENT-ID-ICI',
    iosBundleId: 'com.example.quizEducatif3',
  );

  // =============================================================================
  // CONFIGURATION macOS
  // =============================================================================
  /// Configuration Firebase pour les applications macOS
  /// Utilisée pour les applications Mac natives
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAKPDayzU1-1v9DC1yYV-OooFeDncRPrBY',
    appId: '1:861922845822:macos:xxxxx',
    messagingSenderId: '861922845822',
    projectId: 'quizz-39616',
    storageBucket: 'quizz-39616.firebasestorage.app',
    iosClientId: 'COLLEZ-VOTRE-IOS-CLIENT-ID-ICI',
    iosBundleId: 'com.example.quizEducatif3',
  );

  // =============================================================================
  // CONFIGURATION WINDOWS
  // =============================================================================
  /// Configuration Firebase pour les applications Windows
  /// Utilisée pour les applications PC Windows
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAKPDayzU1-1v9DC1yYV-OooFeDncRPrBY',
    appId: '1:861922845822:windows:xxxxx',
    messagingSenderId: '861922845822',
    projectId: 'quizz-39616',
    storageBucket: 'quizz-39616.firebasestorage.app',
  );

  // =============================================================================
  // CONFIGURATION LINUX
  // =============================================================================
  /// Configuration Firebase pour les applications Linux
  /// Utilisée pour les applications Linux natives
  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyAKPDayzU1-1v9DC1yYV-OooFeDncRPrBY',
    appId: '1:861922845822:linux:xxxxx',
    messagingSenderId: '861922845822',
    projectId: 'quizz-39616',
    storageBucket: 'quizz-39616.firebasestorage.app',
  );
} 
