import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/auth_provider.dart';
import '../providers/score_provider.dart';

/// Écran de profil utilisateur
/// Affiche les informations personnelles, statistiques et performances de l'utilisateur
/// Utilise une interface moderne avec des cartes et des animations
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Chargement des données utilisateur après la construction du widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final scoreProvider = Provider.of<ScoreProvider>(context, listen: false);
      
      // Charger les scores de l'utilisateur connecté
      if (authProvider.firebaseUser != null) {
        scoreProvider.loadUserScores(authProvider.firebaseUser!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Récupération des providers pour accéder aux données utilisateur
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userData = authProvider.userData;
    final firebaseUser = authProvider.firebaseUser;
    
    // Extraction des informations utilisateur depuis Firebase
    // Utilisation des données Firebase directement pour un affichage immédiat
    String username = 'Utilisateur';
    String email = '';
    String initiale = '?';
    
    if (firebaseUser != null) {
      email = firebaseUser.email ?? '';
      username = firebaseUser.displayName ?? email.split('@')[0];
      initiale = username.isNotEmpty ? username[0].toUpperCase() : '?';
    }

    return Scaffold(
      // Barre d'application avec titre stylisé
      appBar: AppBar(
        title: Text(
          'Profil', 
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold)
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // SECTION 1: Avatar et informations de base
            _buildAvatarSection(username, initiale),
            
            const SizedBox(height: 24),
            
            // SECTION 2: Informations détaillées du profil
            _buildProfileInfoSection(userData, firebaseUser, email),
            
            const SizedBox(height: 24),
            
            // SECTION 3: Statistiques et performances
            _buildStatisticsSection(),
          ],
        ),
      ),
    );
  }

  /// Construction de la section avatar avec nom d'utilisateur
  Widget _buildAvatarSection(String username, String initiale) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Avatar circulaire avec initiale de l'utilisateur
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              initiale,
              style: GoogleFonts.poppins(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Nom d'utilisateur
          Text(
            username,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          // Date d'inscription
          Text(
            'Membre depuis ${DateFormat('MMM yyyy').format(DateTime.now())}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// Construction de la section informations du profil
  Widget _buildProfileInfoSection(dynamic userData, dynamic firebaseUser, String email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations du profil',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          
          // Email de l'utilisateur
          _buildInfoRow(
            icon: Icons.email,
            label: 'Email',
            value: email,
            color: Colors.blue,
          ),
          
          const SizedBox(height: 16),
          
          // Affichage conditionnel des informations selon les données disponibles
          if (userData != null) ...[
            // Date de naissance si disponible
            _buildInfoRow(
              icon: Icons.cake,
              label: 'Date de naissance',
              value: DateFormat('dd/MM/yyyy').format(userData.dateNaissance),
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            // Date de création du compte
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Membre depuis',
              value: DateFormat('dd/MM/yyyy').format(userData.dateCreation),
              color: Colors.green,
            ),
          ] else ...[
            // Valeurs par défaut si les données ne sont pas disponibles
            _buildInfoRow(
              icon: Icons.cake,
              label: 'Date de naissance',
              value: 'Non renseignée',
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.calendar_today,
              label: 'Membre depuis',
              value: DateFormat('MMM yyyy').format(DateTime.now()),
              color: Colors.green,
            ),
          ],
          
          const SizedBox(height: 16),
          
          // ID utilisateur Firebase (tronqué pour la sécurité)
          _buildInfoRow(
            icon: Icons.fingerprint,
            label: 'ID utilisateur',
            value: firebaseUser?.uid != null ? '${firebaseUser!.uid.substring(0, 8)}...' : 'N/A',
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  /// Construction de la section statistiques avec données en temps réel
  Widget _buildStatisticsSection() {
    return Consumer<ScoreProvider>(
      builder: (context, scoreProvider, child) {
        final userScores = scoreProvider.userScores;
        final isLoading = scoreProvider.isLoading;
        
        // Calcul des statistiques à partir des scores utilisateur
        final nombreQuiz = userScores.length;
        final meilleurScore = userScores.isNotEmpty 
            ? userScores.reduce((a, b) => a.pourcentage > b.pourcentage ? a : b)
            : null;
        final scoreMoyen = userScores.isNotEmpty 
            ? userScores.fold(0.0, (sum, score) => sum + score.pourcentage) / userScores.length
            : 0.0;
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec indicateur de chargement
              Row(
                children: [
                  Text(
                    'Statistiques',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  if (isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Première ligne de statistiques
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.quiz,
                      label: 'Quiz joués',
                      value: nombreQuiz.toString(),
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.emoji_events,
                      label: 'Meilleur score',
                      value: meilleurScore != null 
                          ? '${meilleurScore.pourcentage.toStringAsFixed(0)}%'
                          : 'N/A',
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Deuxième ligne de statistiques
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.trending_up,
                      label: 'Score moyen',
                      value: scoreMoyen > 0 
                          ? '${scoreMoyen.toStringAsFixed(1)}%'
                          : 'N/A',
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.category,
                      label: 'Catégories',
                      value: userScores.map((s) => s.categorie).toSet().length.toString(),
                      color: Colors.purple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Construction d'une ligne d'information avec icône et valeur
  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        // Icône avec fond coloré
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        // Informations textuelles
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Construction d'une carte de statistique avec icône et valeur
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 