import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';

/// Écran d'inscription utilisateur
/// Permet aux nouveaux utilisateurs de créer un compte avec validation des données
/// Interface moderne avec sélecteur de date et validation en temps réel
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Clé pour la validation du formulaire
  final _formKey = GlobalKey<FormState>();
  
  // Contrôleurs pour les champs de saisie
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  // Variables d'état pour la visibilité des mots de passe
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  
  // Date de naissance sélectionnée par l'utilisateur
  DateTime? _selectedDate;

  @override
  void dispose() {
    // Nettoyage des contrôleurs pour éviter les fuites mémoire
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Sélection de la date de naissance via un sélecteur de date
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 ans par défaut
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Traitement de l'inscription utilisateur
  Future<void> _register() async {
    // Validation du formulaire et vérification de la date de naissance
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      // Tentative d'inscription via le provider d'authentification
      final errorMsg = await authProvider.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        username: _usernameController.text.trim(),
        dateNaissance: _selectedDate!,
      );

      // Gestion du succès ou de l'erreur
      if (errorMsg == null && mounted) {
        // Navigation vers l'écran d'accueil en cas de succès
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else if (mounted) {
        // Affichage du message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg ?? "Erreur lors de l'inscription. Veuillez réessayer."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else if (_selectedDate == null) {
      // Message d'erreur si la date de naissance n'est pas sélectionnée
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez sélectionner votre date de naissance.'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Barre d'application avec bouton de retour
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // SECTION 1: En-tête avec titre et description
                _buildHeaderSection(),
                const SizedBox(height: 32),

                // SECTION 2: Champs de saisie du formulaire
                _buildFormFields(),
                const SizedBox(height: 32),

                // SECTION 3: Bouton d'inscription
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construction de la section d'en-tête
  Widget _buildHeaderSection() {
    return Column(
      children: [
        // Titre principal
        Text(
          'Créer un compte',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        // Description
        Text(
          'Rejoignez notre communauté de quiz',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Construction des champs du formulaire
  Widget _buildFormFields() {
    return Column(
      children: [
        // Champ nom d'utilisateur
        _buildUsernameField(),
        const SizedBox(height: 16),

        // Champ email
        _buildEmailField(),
        const SizedBox(height: 16),

        // Sélecteur de date de naissance
        _buildDateOfBirthField(),
        const SizedBox(height: 16),

        // Champ mot de passe
        _buildPasswordField(),
        const SizedBox(height: 16),

        // Champ confirmation du mot de passe
        _buildConfirmPasswordField(),
      ],
    );
  }

  /// Construction du champ nom d'utilisateur
  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        labelText: 'Nom d\'utilisateur',
        prefixIcon: const Icon(Icons.person),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer un nom d\'utilisateur';
        }
        if (value.length < 3) {
          return 'Le nom d\'utilisateur doit contenir au moins 3 caractères';
        }
        return null;
      },
    );
  }

  /// Construction du champ email
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: const Icon(Icons.email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer votre email';
        }
        // Validation du format email avec expression régulière
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return 'Veuillez entrer un email valide';
        }
        return null;
      },
    );
  }

  /// Construction du sélecteur de date de naissance
  Widget _buildDateOfBirthField() {
    return InkWell(
      onTap: _selectDate,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.grey),
            const SizedBox(width: 12),
            Text(
              _selectedDate == null
                  ? 'Date de naissance'
                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
              style: GoogleFonts.poppins(
                color: _selectedDate == null ? Colors.grey : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construction du champ mot de passe
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Mot de passe',
        prefixIcon: const Icon(Icons.lock),
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
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez entrer un mot de passe';
        }
        if (value.length < 6) {
          return 'Le mot de passe doit contenir au moins 6 caractères';
        }
        return null;
      },
    );
  }

  /// Construction du champ confirmation du mot de passe
  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: 'Confirmer le mot de passe',
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Veuillez confirmer votre mot de passe';
        }
        if (value != _passwordController.text) {
          return 'Les mots de passe ne correspondent pas';
        }
        return null;
      },
    );
  }

  /// Construction du bouton d'inscription
  Widget _buildRegisterButton() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return ElevatedButton(
          onPressed: authProvider.isLoading ? null : _register,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: authProvider.isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  'S\'inscrire',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        );
      },
    );
  }
}