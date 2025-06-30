import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
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

  // REMPLACEZ CES VALEURS PAR VOS VRAIES CLÉS FIREBASE
  // Allez dans : console.firebase.google.com → Project Settings → General → Your apps
  
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAKPDayzU1-1v9DC1yYV-OooFeDncRPrBY',
    appId: '1:861922845822:web:xxxxx',
    messagingSenderId: '861922845822',
    projectId: 'quizz-39616',
    authDomain: 'quizz-39616.firebaseapp.com',
    storageBucket: 'quizz-39616.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAKPDayzU1-1v9DC1yYV-OooFeDncRPrBY',
    appId: '1:861922845822:android:25370e6059e2a61bcfa42f',
    messagingSenderId: '861922845822',
    projectId: 'quizz-39616',
    storageBucket: 'quizz-39616.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAKPDayzU1-1v9DC1yYV-OooFeDncRPrBY',
    appId: '1:861922845822:ios:xxxxx',
    messagingSenderId: '861922845822',
    projectId: 'quizz-39616',
    storageBucket: 'quizz-39616.firebasestorage.app',
    iosClientId: 'COLLEZ-VOTRE-IOS-CLIENT-ID-ICI',
    iosBundleId: 'com.example.quizEducatif3',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAKPDayzU1-1v9DC1yYV-OooFeDncRPrBY',
    appId: '1:861922845822:macos:xxxxx',
    messagingSenderId: '861922845822',
    projectId: 'quizz-39616',
    storageBucket: 'quizz-39616.firebasestorage.app',
    iosClientId: 'COLLEZ-VOTRE-IOS-CLIENT-ID-ICI',
    iosBundleId: 'com.example.quizEducatif3',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAKPDayzU1-1v9DC1yYV-OooFeDncRPrBY',
    appId: '1:861922845822:windows:xxxxx',
    messagingSenderId: '861922845822',
    projectId: 'quizz-39616',
    storageBucket: 'quizz-39616.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'AIzaSyAKPDayzU1-1v9DC1yYV-OooFeDncRPrBY',
    appId: '1:861922845822:linux:xxxxx',
    messagingSenderId: '861922845822',
    projectId: 'quizz-39616',
    storageBucket: 'quizz-39616.firebasestorage.app',
  );
} 
