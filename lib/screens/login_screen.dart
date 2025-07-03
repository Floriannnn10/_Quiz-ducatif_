// =============================================================================
// ÉCRAN DE CONNEXION - AUTHENTIFICATION UTILISATEUR
// =============================================================================
// Cet écran permet aux utilisateurs de se connecter à l'application avec
// leur email et mot de passe. Il gère la validation des champs, l'affichage
// des erreurs et la redirection vers l'inscription si nécessaire.
// 
// Fonctionnalités :
// - Formulaire de connexion avec validation
// - Gestion des erreurs d'authentification
// - Navigation vers l'écran d'inscription
// - Indicateur de chargement pendant la connexion
// - Design responsive et accessible

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';
import 'home_screen.dart';

// =============================================================================
// CLASSE PRINCIPALE DE L'ÉCRAN DE CONNEXION
// =============================================================================
/// Écran de connexion avec formulaire et gestion d'état
/// Utilise le AuthProvider pour gérer l'authentification Firebase
/// StatefulWidget pour gérer l'état de l'écran 
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// =============================================================================
// ÉTAT DE L'ÉCRAN DE CONNEXION
// =============================================================================
/// Gère l'état du formulaire de connexion et les interactions utilisateur
class _LoginScreenState extends State<LoginScreen> {
  // =============================================================================
  // CONTRÔLEURS DE FORMULAIRE
  // =============================================================================
  /// Contrôleur pour le champ email
  final TextEditingController _emailController = TextEditingController();
  
  /// Contrôleur pour le champ mot de passe
  final TextEditingController _passwordController = TextEditingController();
  
  /// Clé globale pour valider le formulaire
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  /// État de visibilité du mot de passe (caché/visible)
  bool _obscurePassword = true;

  // =============================================================================
  // MÉTHODES DE VALIDATION
  // =============================================================================
  
  /// Valide le format de l'email saisi
  /// 
  /// [value] : Valeur du champ email
  /// 
  /// Retourne un message d'erreur si l'email est invalide, null sinon
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Veuillez saisir un email valide';
    }
    return null;
  }

  /// Valide le mot de passe saisi
  /// 
  /// [value] : Valeur du champ mot de passe
  /// 
  /// Retourne un message d'erreur si le mot de passe est invalide, null sinon
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir votre mot de passe';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  // =============================================================================
  // MÉTHODE DE CONNEXION
  // =============================================================================
  /// Tente de connecter l'utilisateur avec les identifiants saisis
  /// Affiche les erreurs et gère la redirection en cas de succès
  Future<void> _login() async {
    // Vérifier que le formulaire est valide
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Récupérer le provider d'authentification
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Tenter la connexion
    final success = await authProvider.signIn(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    // Gérer le résultat de la connexion
    if (success && mounted) {
      // Connexion réussie - navigation automatique vers l'écran principal
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (mounted) {
      // Échec de la connexion - afficher un message d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Email ou mot de passe incorrect',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =============================================================================
  // MÉTHODE DE NAVIGATION VERS L'INSCRIPTION
  // =============================================================================
  /// Navigue vers l'écran d'inscription pour créer un nouveau compte
  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  void dispose() {
    // Libérer les contrôleurs pour éviter les fuites mémoire
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // =============================================================================
      // CONFIGURATION DE L'ÉCRAN
      // =============================================================================
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // =============================================================================
                  // EN-TÊTE DE L'ÉCRAN
                  // =============================================================================
                  _buildHeader(),
                  
                  const SizedBox(height: 48),
                  
                  // =============================================================================
                  // FORMULAIRE DE CONNEXION
                  // =============================================================================
                  _buildLoginForm(),
                  
                  const SizedBox(height: 32),
                  
                  // =============================================================================
                  // BOUTON DE CONNEXION
                  // =============================================================================
                  _buildLoginButton(),
                  
                  const SizedBox(height: 24),
                  
                  // =============================================================================
                  // LIEN VERS L'INSCRIPTION
                  // =============================================================================
                  _buildRegisterLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================================
  // WIDGETS DE CONSTRUCTION DE L'INTERFACE
  // =============================================================================
  
  /// Construit l'en-tête de l'écran avec logo et titre
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo de l'application
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.asset(
              'assets/image/Logo_image.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Titre de l'écran
        Text(
          'Connexion',
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Sous-titre
        Text(
          'Connectez-vous à votre compte',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  /// Construit le formulaire de connexion avec les champs email et mot de passe
  Widget _buildLoginForm() {
    return Column(
      children: [
        // Champ email
        TextFormField(
          controller: _emailController,
          validator: _validateEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Champ mot de passe
        TextFormField(
          controller: _passwordController,
          validator: _validatePassword,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Mot de passe',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  /// Construit le bouton de connexion avec gestion du chargement
  Widget _buildLoginButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return ElevatedButton(
          onPressed: authProvider.isLoading ? null : _login,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: authProvider.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Se connecter',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        );
      },
    );
  }

  /// Construit le lien vers l'écran d'inscription
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Pas encore de compte ? ',
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
          ),
        ),
        TextButton(
          onPressed: _navigateToRegister,
          child: Text(
            'S\'inscrire',
            style: GoogleFonts.poppins(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
} 