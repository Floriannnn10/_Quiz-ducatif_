// =============================================================================
// PROVIDER DE THÈME - GESTION DES THÈMES DE L'APPLICATION
// =============================================================================
// Ce provider gère les thèmes de l'application (clair/sombre) et permet
// aux utilisateurs de personnaliser l'apparence de l'interface.
// 
// Fonctionnalités :
// - Basculement entre thème clair et sombre
// - Persistance des préférences utilisateur
// - Thèmes personnalisables avec couleurs
// - Notifications automatiques des changements

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// =============================================================================
// CLASSE PRINCIPALE DU PROVIDER DE THÈME
// =============================================================================
/// Provider qui gère les thèmes de l'application
/// Utilise SharedPreferences pour persister les préférences utilisateur
/// Notifie automatiquement les widgets des changements de thème
class ThemeProvider with ChangeNotifier {
  // =============================================================================
  // PROPRIÉTÉS ET ÉTAT
  // =============================================================================
  
  /// État actuel du thème (clair ou sombre)
  bool _isDarkMode = false;
  
  /// Instance SharedPreferences pour la persistance
  SharedPreferences? _prefs;
  
  /// Couleur primaire personnalisable
  Color _primaryColor = Colors.blue;
  
  /// Couleur d'accent personnalisable
  Color _accentColor = Colors.orange;

  // =============================================================================
  // GETTERS PUBLICS
  // =============================================================================
  
  /// Indique si le thème sombre est actif
  bool get isDarkMode => _isDarkMode;
  
  /// Couleur primaire actuelle
  Color get primaryColor => _primaryColor;
  
  /// Couleur d'accent actuelle
  Color get accentColor => _accentColor;
  
  /// Thème Material actuel basé sur l'état
  ThemeData get theme => _isDarkMode ? _darkTheme : _lightTheme;

  // =============================================================================
  // CONSTRUCTEUR ET INITIALISATION
  // =============================================================================
  
  /// Constructeur qui initialise le provider et charge les préférences
  ThemeProvider() {
    _loadPreferences();
  }

  // =============================================================================
  // MÉTHODES DE GESTION DES PRÉFÉRENCES
  // =============================================================================
  
  /// Charge les préférences de thème depuis SharedPreferences
  /// Cette méthode est appelée au démarrage de l'application
  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs?.getBool('isDarkMode') ?? false;
    _primaryColor = Color(_prefs?.getInt('primaryColor') ?? Colors.blue.value);
    _accentColor = Color(_prefs?.getInt('accentColor') ?? Colors.orange.value);
    notifyListeners();
  }

  /// Sauvegarde les préférences de thème dans SharedPreferences
  /// Cette méthode est appelée à chaque changement de thème
  Future<void> _savePreferences() async {
    await _prefs?.setBool('isDarkMode', _isDarkMode);
    await _prefs?.setInt('primaryColor', _primaryColor.value);
    await _prefs?.setInt('accentColor', _accentColor.value);
  }

  // =============================================================================
  // MÉTHODES DE CHANGEMENT DE THÈME
  // =============================================================================
  
  /// Bascule entre le thème clair et sombre
  /// Sauvegarde automatiquement la préférence
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _savePreferences();
    notifyListeners();
  }

  /// Définit explicitement le mode sombre
  /// 
  /// [isDark] : true pour thème sombre, false pour thème clair
  Future<void> setDarkMode(bool isDark) async {
    if (_isDarkMode != isDark) {
      _isDarkMode = isDark;
      await _savePreferences();
      notifyListeners();
    }
  }

  /// Change la couleur primaire du thème
  /// 
  /// [color] : Nouvelle couleur primaire
  Future<void> setPrimaryColor(Color color) async {
    if (_primaryColor != color) {
      _primaryColor = color;
      await _savePreferences();
      notifyListeners();
    }
  }

  /// Change la couleur d'accent du thème
  /// 
  /// [color] : Nouvelle couleur d'accent
  Future<void> setAccentColor(Color color) async {
    if (_accentColor != color) {
      _accentColor = color;
      await _savePreferences();
      notifyListeners();
    }
  }

  // =============================================================================
  // DÉFINITION DES THÈMES
  // =============================================================================
  
  /// Thème clair de l'application
  /// Utilise les couleurs personnalisées et un design moderne
  ThemeData get _lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: _createMaterialColor(_primaryColor),
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.light(
        primary: _primaryColor,
        secondary: _accentColor,
        surface: Colors.white,
        background: Colors.grey[50]!,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black87,
        onBackground: Colors.black87,
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      cardColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(color: Colors.black87),
        headlineMedium: TextStyle(color: Colors.black87),
        headlineSmall: TextStyle(color: Colors.black87),
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black87),
        bodySmall: TextStyle(color: Colors.grey[600]),
      ),
    );
  }

  /// Thème sombre de l'application
  /// Utilise des couleurs sombres pour réduire la fatigue oculaire
  ThemeData get _darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: _createMaterialColor(_primaryColor),
      primaryColor: _primaryColor,
      colorScheme: ColorScheme.dark(
        primary: _primaryColor,
        secondary: _accentColor,
        surface: Colors.grey[900]!,
        background: Colors.black,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onBackground: Colors.white,
      ),
      scaffoldBackgroundColor: Colors.black,
      cardColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[800],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: Colors.white),
        headlineMedium: TextStyle(color: Colors.white),
        headlineSmall: TextStyle(color: Colors.white),
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        bodySmall: TextStyle(color: Colors.grey),
      ),
    );
  }

  // =============================================================================
  // MÉTHODES UTILITAIRES
  // =============================================================================
  
  /// Crée une MaterialColor à partir d'une couleur
  /// Utilisé pour créer des palettes de couleurs cohérentes
  /// 
  /// [color] : Couleur de base
  /// 
  /// Retourne une MaterialColor avec différentes nuances
  MaterialColor _createMaterialColor(Color color) {
    List<double> strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  /// Réinitialise les couleurs aux valeurs par défaut
  /// Utile pour restaurer l'apparence originale
  Future<void> resetColors() async {
    _primaryColor = Colors.blue;
    _accentColor = Colors.orange;
    await _savePreferences();
    notifyListeners();
  }
}
