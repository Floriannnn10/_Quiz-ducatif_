# Quiz Éducatif - Application Flutter

Une application de quiz éducatif complète avec authentification Firebase, base de données SQLite locale, et interface utilisateur moderne.

## 🚀 Fonctionnalités

### ✅ Authentification
- Inscription avec email, mot de passe, nom d'utilisateur et date de naissance
- Connexion avec email et mot de passe
- Avatar circulaire avec initiale de l'utilisateur
- Interface de bienvenue personnalisée

### 🧠 Quiz Éducatif
- **4 catégories** : Culture Générale, Programmation, Mathématiques, Histoire
- **3 niveaux de difficulté** : Facile, Moyen, Difficile
- **10 questions par quiz** avec 4 réponses possibles (Une seule est la bonne)
- Animations fluides entre les questions
- Feedback visuel immédiat (vert/rouge)

### 📊 Gestion des Scores
- Sauvegarde automatique des scores en base SQLite locale
- Historique complet des parties jouées
- Classement des meilleurs scores par catégorie
- Statistiques personnelles (moyenne, meilleur score, etc.)

### 💄 Interface Utilisateur
- Design moderne avec Material Design 3
- Police Poppins (Google Fonts)
- Interface responsive et intuitive
- Animations avec flutter_animate
- Thème cohérent et épuré

## 🛠️ Technologies Utilisées

- **Flutter** - Framework de développement
- **Firebase Auth** - Authentification des utilisateurs
- **SQLite (sqflite)** - Base de données locale
- **Provider** - Gestion d'état
- **flutter_animate** - Animations
- **google_fonts** - Police Poppins
- **uuid** - Génération d'identifiants uniques

## 📦 Installation

### Prérequis
- Flutter SDK (version 3.8.1)
- Dart SDK
- Android Studio / VS Code
- Compte Firebase

### Étapes d'installation

1. **Cloner le projet**
   git clone <repository-url>
   cd quiz_educatif_3
   ```

2. **Installer les dépendances**
   flutter pub get
   ```

3. **Configurer Firebase**
   
   a. Créer un projet Firebase sur [console.firebase.google.com](https://console.firebase.google.com)
   
   b. Activer l'authentification par email/mot de passe
   
   c. Installer FlutterFire CLI :
   dart pub global activate flutterfire_cli
   ```
   
   d. Configurer Firebase pour votre projet :
   flutterfire configure
   ```
   
   e. Remplacer le fichier `lib/firebase_options.dart` généré

4. **Lancer l'application**
   flutter run
   ```

## 🏗️ Structure du Projet

```
lib/
├── models/
│   ├── user_model.dart          # Modèle utilisateur
│   ├── question_model.dart      # Modèle question et enums
│   └── score_model.dart         # Modèle score
├── services/
│   ├── auth_service.dart        # Service Firebase Auth
│   ├── database_service.dart    # Service SQLite
│   └── question_service.dart    # Service questions
├── providers/
│   ├── auth_provider.dart       # Provider authentification
│   └── score_provider.dart      # Provider scores
├── screens/
│   ├── login_screen.dart        # Écran de connexion
│   ├── register_screen.dart     # Écran d'inscription
│   ├── home_screen.dart         # Écran d'accueil
│   ├── quiz_screen.dart         # Écran de quiz
│   ├── quiz_result_screen.dart  # Écran de résultat
│   └── scores_screen.dart       # Écran des scores
├── widgets/                     # Widgets réutilisables
├── utils/                       # Utilitaires
├── firebase_options.dart        # Configuration Firebase
└── main.dart                    # Point d'entrée
```

## 🎯 Utilisation

### Pour les utilisateurs
1. **Inscription** : Créer un compte avec email, mot de passe, nom d'utilisateur et date de naissance
2. **Connexion** : Se connecter avec email et mot de passe
3. **Choisir un quiz** : Sélectionner une catégorie et un niveau de difficulté
4. **Répondre aux questions** : 10 questions à choix multiple avec feedback visuel
5. **Voir les résultats** : Score final avec classement et statistiques
6. **Consulter l'historique** : Voir tous les scores précédents

### Pour les développeurs
- **Ajouter des questions** : Modifier `lib/services/question_service.dart`
- **Modifier l'interface** : Personnaliser les thèmes dans `lib/main.dart`
- **Étendre les fonctionnalités** : Ajouter de nouvelles catégories ou difficultés

## 🔧 Configuration Firebase

### Variables d'environnement
Créer un fichier `.env` à la racine du projet :
```
FIREBASE_API_KEY=your-api-key
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_MESSAGING_SENDER_ID=your-sender-id
FIREBASE_APP_ID=your-app-id
```

### Règles de sécurité Firebase
```javascript
// firestore.rules
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## 📱 Plateformes Supportées

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🎨 Personnalisation

### Thème
Modifier les couleurs et styles dans `lib/main.dart` :
```dart
theme: ThemeData(
  primarySwatch: Colors.blue,
  primaryColor: Colors.blue[600],
  fontFamily: GoogleFonts.poppins().fontFamily,
  // ...
)
```

### Questions
Ajouter de nouvelles questions dans `lib/services/question_service.dart` :
```dart
QuestionModel(
  id: _uuid.v4(),
  question: 'Votre question ici ?',
  reponses: ['Réponse A', 'Réponse B', 'Réponse C', 'Réponse D'],
  bonneReponse: 0, // Index de la bonne réponse
  categorie: Categorie.cultureGenerale,
  difficulte: Difficulte.facile,
)
```

## 🐛 Dépannage

### Erreurs courantes

1. **Firebase non configuré**
   - Vérifier que `firebase_options.dart` est correctement configuré
   - S'assurer que l'authentification par email/mot de passe est activée

2. **Erreurs de dépendances**
   flutter clean
   flutter pub get
   ```

3. **Problèmes de base de données**
   - Supprimer l'application et la réinstaller
   - Vérifier les permissions SQLite

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- Signaler des bugs
- Proposer de nouvelles fonctionnalités
- Soumettre des pull requests

## 📞 Support

Pour toute question ou problème :
- Ouvrir une issue sur GitHub
- Contacter l'équipe de développement

---

**Développé avec ❤️ en Flutter**
