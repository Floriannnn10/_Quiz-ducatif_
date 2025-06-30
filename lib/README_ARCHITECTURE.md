# Architecture du Projet Quiz Éducatif

## 📁 Structure des Dossiers

### `lib/` - Code Source Principal

```
lib/
├── main.dart                    # Point d'entrée de l'application
├── firebase_options.dart        # Configuration Firebase multi-plateforme
├── README_ARCHITECTURE.md       # Ce fichier de documentation
├── models/                      # Modèles de données
├── providers/                   # Gestion d'état (Provider pattern)
├── services/                    # Services métier et API
├── screens/                     # Écrans de l'application
├── utils/                       # Utilitaires et helpers
└── widgets/                     # Widgets réutilisables
```

## 🏗️ Architecture MVVM avec Provider

### 1. **Models** (`models/`)
**Responsabilité** : Représentation des données et logique métier

#### `user_model.dart`
- **Rôle** : Modèle utilisateur avec données Firebase et locales
- **Fonctionnalités** :
  - Sérialisation/désérialisation pour Firebase et SQLite
  - Gestion des dates de naissance et création
  - Calcul de l'initiale pour l'avatar

#### `question_model.dart`
- **Rôle** : Modèle des questions avec enums pour catégories et difficultés
- **Fonctionnalités** :
  - Enums `Categorie` et `Difficulte` avec extensions
  - Gestion des réponses multiples
  - Index de la bonne réponse

#### `score_model.dart`
- **Rôle** : Modèle des scores avec calculs de performance
- **Fonctionnalités** :
  - Calcul automatique du pourcentage
  - Gestion des métadonnées (date, utilisateur, catégorie)
  - Méthodes d'affichage pour l'interface

### 2. **Providers** (`providers/`)
**Responsabilité** : Gestion d'état globale et communication entre composants

#### `auth_provider.dart`
- **Rôle** : Gestion de l'état d'authentification
- **Fonctionnalités** :
  - Synchronisation Firebase Auth avec l'interface
  - Gestion des données utilisateur locales
  - État de chargement et notifications

#### `score_provider.dart`
- **Rôle** : Gestion des scores et statistiques
- **Fonctionnalités** :
  - Chargement et sauvegarde des scores
  - Calculs de statistiques (moyenne, meilleur score)
  - Gestion des classements

#### `theme_provider.dart`
- **Rôle** : Gestion du thème de l'application
- **Fonctionnalités** :
  - Basculement entre thèmes clair/sombre
  - Personnalisation des couleurs
  - Persistance des préférences

### 3. **Services** (`services/`)
**Responsabilité** : Logique métier et communication avec les APIs

#### `auth_service.dart`
- **Rôle** : Service d'authentification Firebase
- **Fonctionnalités** :
  - Inscription, connexion, déconnexion
  - Gestion des erreurs Firebase
  - Synchronisation avec base locale

#### `database_service.dart`
- **Rôle** : Service de base de données SQLite
- **Fonctionnalités** :
  - Pattern Singleton pour optimiser les performances
  - CRUD complet pour utilisateurs et scores
  - Requêtes optimisées avec index

#### `question_service.dart`
- **Rôle** : Service de gestion des questions
- **Fonctionnalités** :
  - Base de données de 120 questions (4 catégories × 3 niveaux × 10 questions)
  - Génération d'IDs uniques avec UUID
  - Organisation par catégorie et difficulté

### 4. **Screens** (`screens/`)
**Responsabilité** : Interface utilisateur et navigation

#### `splash_screen.dart`
- **Rôle** : Écran de démarrage avec animations
- **Fonctionnalités** :
  - Animations fluides avec flutter_animate
  - Redirection automatique après 3 secondes
  - Transition en fondu vers l'authentification

#### `login_screen.dart`
- **Rôle** : Écran de connexion utilisateur
- **Fonctionnalités** :
  - Validation des champs email/mot de passe
  - Gestion des erreurs d'authentification
  - Navigation vers l'inscription

#### `register_screen.dart`
- **Rôle** : Écran d'inscription nouveau utilisateur
- **Fonctionnalités** :
  - Formulaire complet avec validation
  - Sélecteur de date de naissance
  - Création de compte Firebase

#### `home_screen.dart`
- **Rôle** : Écran principal après connexion
- **Fonctionnalités** :
  - Affichage du profil utilisateur
  - Sélection des catégories de quiz
  - Navigation vers les autres écrans

#### `quiz_screen.dart`
- **Rôle** : Interface de quiz interactive
- **Fonctionnalités** :
  - Affichage des questions une par une
  - Feedback visuel immédiat
  - Calcul du score en temps réel

#### `quiz_result_screen.dart`
- **Rôle** : Affichage des résultats de quiz
- **Fonctionnalités** :
  - Score final avec pourcentage
  - Sauvegarde automatique du score
  - Options de rejouer ou retour

#### `scores_screen.dart`
- **Rôle** : Historique et classements
- **Fonctionnalités** :
  - Liste des scores personnels
  - Classements par catégorie
  - Statistiques détaillées

#### `profile_screen.dart`
- **Rôle** : Gestion du profil utilisateur
- **Fonctionnalités** :
  - Affichage des informations personnelles
  - Statistiques de performance
  - Option de déconnexion

### 5. **Utils** (`utils/`)
**Responsabilité** : Fonctions utilitaires et helpers

- **Fonctions de formatage** : Dates, nombres, textes
- **Validations** : Email, mot de passe, formulaires
- **Constantes** : Couleurs, dimensions, textes
- **Extensions** : Méthodes utilitaires pour les types Dart

### 6. **Widgets** (`widgets/`)
**Responsabilité** : Composants réutilisables

- **Widgets de formulaire** : Champs personnalisés
- **Widgets de navigation** : Boutons, liens
- **Widgets d'affichage** : Cartes, listes, indicateurs
- **Widgets d'animation** : Transitions, effets visuels

## 🔄 Flux de Données

### 1. **Authentification**
```
LoginScreen → AuthProvider → AuthService → Firebase Auth
                                    ↓
                              DatabaseService → SQLite
```

### 2. **Quiz**
```
HomeScreen → QuizScreen → QuestionService → QuestionModel
     ↓
QuizResultScreen → ScoreProvider → DatabaseService → SQLite
```

### 3. **Scores**
```
ScoresScreen → ScoreProvider → DatabaseService → ScoreModel
```

## 🎨 Design Patterns Utilisés

### 1. **Provider Pattern**
- **Avantage** : Gestion d'état centralisée et réactive
- **Implémentation** : ChangeNotifier avec notifyListeners()
- **Utilisation** : AuthProvider, ScoreProvider, ThemeProvider

### 2. **Singleton Pattern**
- **Avantage** : Instance unique pour optimiser les performances
- **Implémentation** : DatabaseService avec instance privée
- **Utilisation** : Connexion SQLite unique

### 3. **Factory Pattern**
- **Avantage** : Création d'objets avec validation
- **Implémentation** : fromMap() dans les modèles
- **Utilisation** : Conversion données base → objets

### 4. **Repository Pattern**
- **Avantage** : Abstraction de la source de données
- **Implémentation** : Services comme couche d'abstraction
- **Utilisation** : AuthService, DatabaseService

## 🔧 Configuration et Déploiement

### 1. **Firebase Configuration**
- **Fichier** : `firebase_options.dart`
- **Plateformes** : Web, Android, iOS, macOS, Windows, Linux
- **Génération** : `flutterfire configure`

### 2. **Dépendances**
- **Authentification** : firebase_auth, firebase_core
- **Base de données** : sqflite, path
- **UI/UX** : flutter_animate, google_fonts
- **État** : provider
- **Utilitaires** : uuid, intl, shared_preferences

### 3. **Structure de Base de Données**
```sql
-- Table utilisateurs
CREATE TABLE users (
  id TEXT PRIMARY KEY,
  username TEXT NOT NULL,
  email TEXT NOT NULL,
  dateNaissance TEXT NOT NULL,
  dateCreation TEXT NOT NULL
);

-- Table scores
CREATE TABLE scores (
  id TEXT PRIMARY KEY,
  userId TEXT NOT NULL,
  categorie TEXT NOT NULL,
  difficulte TEXT NOT NULL,
  score INTEGER NOT NULL,
  totalQuestions INTEGER NOT NULL,
  dateQuiz TEXT NOT NULL,
  FOREIGN KEY (userId) REFERENCES users (id)
);
```

## 🚀 Points Clés pour la Présentation

### 1. **Architecture Modulaire**
- Séparation claire des responsabilités
- Code maintenable et extensible
- Réutilisabilité des composants

### 2. **Gestion d'État Réactive**
- Provider pattern pour la réactivité
- Notifications automatiques des changements
- État centralisé et prévisible

### 3. **Persistance des Données**
- Firebase pour l'authentification
- SQLite pour les données locales
- Synchronisation automatique

### 4. **Interface Utilisateur**
- Design Material Design moderne
- Animations fluides et feedback visuel
- Interface responsive et accessible

### 5. **Sécurité**
- Authentification Firebase sécurisée
- Validation des données côté client
- Gestion sécurisée des sessions

## 📈 Évolutions Futures

### 1. **Fonctionnalités**
- Mode hors ligne complet
- Synchronisation cloud des scores
- Questions personnalisées
- Mode multijoueur

### 2. **Techniques**
- Tests unitaires et d'intégration
- Optimisation des performances
- Support multilingue
- Thèmes personnalisables

### 3. **Architecture**
- Migration vers Riverpod ou Bloc
- Architecture modulaire avancée
- Injection de dépendances
- Tests automatisés

---

**Cette architecture garantit une application robuste, maintenable et évolutive !** 🎯 