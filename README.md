# Quiz Éducatif - Application Flutter

## 📱 Description

Application de quiz éducatif développée en Flutter avec authentification Firebase et base de données locale SQLite. L'application permet aux utilisateurs de tester leurs connaissances dans différentes catégories avec des niveaux de difficulté variés.

## 🏗️ Architecture du Projet

### Structure des Dossiers

```
lib/
├── main.dart                 # Point d'entrée de l'application
├── firebase_options.dart     # Configuration Firebase
├── models/                   # Modèles de données
│   ├── user_model.dart      # Modèle utilisateur
│   ├── question_model.dart  # Modèle question
│   └── score_model.dart     # Modèle score
├── providers/               # Gestion d'état (Provider pattern)
│   ├── auth_provider.dart   # Provider d'authentification
│   ├── score_provider.dart  # Provider des scores
│   └── theme_provider.dart  # Provider du thème
├── services/                # Services métier
│   ├── auth_service.dart    # Service d'authentification Firebase
│   ├── database_service.dart # Service base de données SQLite
│   └── question_service.dart # Service de gestion des questions
├── screens/                 # Écrans de l'application
│   ├── splash_screen.dart   # Écran de démarrage
│   ├── login_screen.dart    # Écran de connexion
│   ├── register_screen.dart # Écran d'inscription
│   ├── home_screen.dart     # Écran principal
│   ├── quiz_screen.dart     # Écran de quiz
│   ├── quiz_result_screen.dart # Écran de résultats
│   ├── scores_screen.dart   # Écran des scores
│   └── profile_screen.dart  # Écran de profil
├── widgets/                 # Widgets réutilisables
└── utils/                   # Utilitaires
```

## 🔧 Technologies Utilisées

### Frontend
- **Flutter** : Framework de développement cross-platform
- **Dart** : Langage de programmation
- **Provider** : Gestion d'état de l'application
- **Google Fonts** : Polices personnalisées
- **Flutter Animate** : Animations fluides

### Backend & Base de Données
- **Firebase Auth** : Authentification des utilisateurs
- **SQLite** : Base de données locale pour les scores
- **Firebase Core** : Configuration Firebase

### Outils de Développement
- **flutter_lints** : Règles de qualité de code
- **uuid** : Génération d'identifiants uniques
- **intl** : Internationalisation et formatage
- **shared_preferences** : Stockage de préférences

## 🎯 Fonctionnalités Principales

### 1. Authentification
- **Inscription** : Création de compte avec email, mot de passe, nom d'utilisateur et date de naissance
- **Connexion** : Authentification avec email et mot de passe
- **Déconnexion** : Fermeture de session sécurisée
- **Persistance** : Maintien de la session entre les redémarrages

### 2. Quiz Éducatif
- **4 Catégories** : Culture Générale, Programmation, Mathématiques, Histoire
- **3 Niveaux** : Facile, Moyen, Difficile
- **10 Questions par quiz** : Questions à choix multiples
- **Feedback immédiat** : Affichage des bonnes/mauvaises réponses

### 3. Système de Scores
- **Sauvegarde locale** : Tous les scores sont stockés en local
- **Historique personnel** : Consultation de ses propres résultats
- **Classements** : Meilleurs scores par catégorie et difficulté
- **Statistiques** : Moyenne des performances utilisateur

### 4. Interface Utilisateur
- **Design moderne** : Interface Material Design
- **Animations fluides** : Transitions et animations d'interface
- **Responsive** : Adaptation à différentes tailles d'écran
- **Thème cohérent** : Couleurs et typographie uniformes

## 🚀 Installation et Configuration

### Prérequis
- Flutter SDK (version 3.8.1 ou supérieure)
- Dart SDK
- Android Studio / VS Code
- Compte Firebase

### Étapes d'Installation

1. **Cloner le projet**
   ```bash
   git clone [URL_DU_REPO]
   cd quiz_educatif_3
   ```

2. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

3. **Configuration Firebase**
   - Créer un projet Firebase
   - Télécharger `google-services.json` (Android) et `GoogleService-Info.plist` (iOS)
   - Placer les fichiers dans les dossiers appropriés
   - Exécuter `flutterfire configure`

4. **Lancer l'application**
   ```bash
   flutter run
   ```

## 📊 Structure des Données

### Modèle Utilisateur (UserModel)
```dart
class UserModel {
  final String id;              // ID Firebase
  final String username;        // Nom d'utilisateur
  final String email;           // Adresse email
  final DateTime dateNaissance; // Date de naissance
  final DateTime dateCreation;  // Date de création du compte
}
```

### Modèle Question (QuestionModel)
```dart
class QuestionModel {
  final String id;                    // ID unique
  final String question;              // Texte de la question
  final List<String> reponses;        // Liste des réponses
  final int bonneReponse;             // Index de la bonne réponse
  final Categorie categorie;          // Catégorie
  final Difficulte difficulte;        // Niveau de difficulté
}
```

### Modèle Score (ScoreModel)
```dart
class ScoreModel {
  final String id;                    // ID unique
  final String userId;                // ID de l'utilisateur
  final Categorie categorie;          // Catégorie du quiz
  final Difficulte difficulte;        // Niveau de difficulté
  final int score;                    // Nombre de bonnes réponses
  final int totalQuestions;           // Nombre total de questions
  final DateTime dateQuiz;            // Date du quiz
}
```

## 🔐 Sécurité et Authentification

### Firebase Authentication
- **Email/Password** : Méthode d'authentification principale
- **Validation** : Vérification des formats email et force du mot de passe
- **Sécurité** : Gestion sécurisée des sessions Firebase

### Base de Données Locale
- **SQLite** : Stockage local sécurisé
- **Contraintes** : Clés étrangères pour l'intégrité des données
- **Isolation** : Données utilisateur isolées par ID

## 🎨 Interface Utilisateur

### Design System
- **Couleurs** : Palette bleue avec accents
- **Typographie** : Google Fonts Poppins
- **Espacement** : Système de grille cohérent
- **Animations** : Transitions fluides et feedback visuel

### Écrans Principaux
1. **Splash Screen** : Écran de démarrage avec animations
2. **Login/Register** : Authentification utilisateur
3. **Home Screen** : Sélection des catégories de quiz
4. **Quiz Screen** : Interface de quiz interactive
5. **Results Screen** : Affichage des résultats
6. **Scores Screen** : Historique et classements
7. **Profile Screen** : Gestion du profil utilisateur

## 📱 Fonctionnalités Avancées

### Gestion d'État
- **Provider Pattern** : Gestion centralisée de l'état
- **ChangeNotifier** : Notifications automatiques des changements
- **Séparation des responsabilités** : Providers spécialisés

### Persistance des Données
- **SQLite** : Base de données locale performante
- **CRUD Operations** : Opérations complètes sur les données
- **Requêtes optimisées** : Index et contraintes pour les performances

### Animations et UX
- **Flutter Animate** : Animations déclaratives
- **Transitions fluides** : Navigation entre écrans
- **Feedback visuel** : Réponses immédiates aux actions utilisateur

## 🧪 Tests et Qualité

### Tests
- **Widget Tests** : Tests des composants UI
- **Unit Tests** : Tests des services et modèles
- **Integration Tests** : Tests de flux complets

### Qualité de Code
- **flutter_lints** : Règles de linting automatiques
- **Documentation** : Commentaires détaillés
- **Architecture** : Pattern MVVM avec Provider

## 🚀 Déploiement

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 📈 Améliorations Futures

### Fonctionnalités Planifiées
- [ ] Mode hors ligne complet
- [ ] Synchronisation cloud des scores
- [ ] Questions personnalisées par utilisateur
- [ ] Mode multijoueur
- [ ] Notifications push
- [ ] Thèmes sombres/clairs
- [ ] Support multilingue

### Optimisations Techniques
- [ ] Cache des questions
- [ ] Lazy loading des données
- [ ] Compression des images
- [ ] Optimisation des requêtes SQL

## 🤝 Contribution

### Guidelines
1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

### Standards de Code
- Respecter les conventions Dart/Flutter
- Ajouter des commentaires pour les fonctions complexes
- Tester les nouvelles fonctionnalités
- Maintenir la cohérence de l'architecture

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

## 👥 Auteurs

- **Développeur Principal** : [Votre Nom]
- **Design UI/UX** : [Nom du Designer]
- **Tests** : [Nom du Testeur]

## 📞 Support

Pour toute question ou problème :
- Ouvrir une issue sur GitHub
- Contacter l'équipe de développement
- Consulter la documentation technique

---

**Quiz Éducatif** - Une application moderne pour l'apprentissage interactif 📚✨
