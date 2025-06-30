// =============================================================================
// SERVICE DE QUESTIONS - GESTION DE LA BASE DE DONNÉES DE QUESTIONS
// =============================================================================
// Ce service contient toutes les questions du quiz organisées par catégorie
// et niveau de difficulté. Il fournit une méthode pour récupérer les questions
// appropriées selon les critères sélectionnés par l'utilisateur.
// 
// Structure des questions :
// - 4 catégories : Culture Générale, Programmation, Mathématiques, Histoire
// - 3 niveaux : Facile, Moyen, Difficile
// - 10 questions par catégorie/niveau (120 questions au total)
// - Format : Question + 4 réponses + index de la bonne réponse

import '../models/question_model.dart';
import 'package:uuid/uuid.dart';

// =============================================================================
// CLASSE PRINCIPALE DU SERVICE DE QUESTIONS
// =============================================================================
/// Service centralisé pour la gestion et la récupération des questions de quiz
/// Utilise des Maps statiques pour organiser les questions par catégorie et difficulté
/// Génère des IDs uniques pour chaque question avec le package uuid
class QuestionService {
  // =============================================================================
  // INSTANCE UUID POUR GÉNÉRATION D'IDENTIFIANTS
  // =============================================================================
  /// Instance UUID pour générer des identifiants uniques pour chaque question
  /// Assure l'unicité des questions dans l'application
  static final Uuid _uuid = Uuid();

  // =============================================================================
  // MÉTHODE PRINCIPALE DE RÉCUPÉRATION DES QUESTIONS
  // =============================================================================
  /// Récupère la liste des questions pour une catégorie et difficulté données
  /// 
  /// [categorie] : Catégorie de questions (Culture Générale, Programmation, etc.)
  /// [difficulte] : Niveau de difficulté (Facile, Moyen, Difficile)
  /// 
  /// Retourne une liste de 10 questions QuestionModel
  static List<QuestionModel> getQuestions(Categorie categorie, Difficulte difficulte) {
    switch (categorie) {
      case Categorie.cultureGenerale:
        return _cultureGenerale[difficulte]!;
      case Categorie.programmation:
        return _programmation[difficulte]!;
      case Categorie.mathematiques:
        return _mathematiques[difficulte]!;
      case Categorie.histoire:
        return _histoire[difficulte]!;
    }
  }

  // =============================================================================
  // BASE DE DONNÉES DE QUESTIONS - CULTURE GÉNÉRALE
  // =============================================================================
  /// Questions de culture générale couvrant la géographie, les sciences,
  /// la nature et les connaissances générales du monde
  static final Map<Difficulte, List<QuestionModel>> _cultureGenerale = {
    // =============================================================================
    // QUESTIONS FACILES - CULTURE GÉNÉRALE
    // =============================================================================
    /// Questions de base sur la géographie, les sciences et la nature
    /// Niveau accessible à tous les publics
    Difficulte.facile: [
      QuestionModel(id: _uuid.v4(), question: 'Quelle est la capitale de la France ?', reponses: ['Paris', 'Londres', 'Berlin', 'Madrid'], bonneReponse: 0, categorie: Categorie.cultureGenerale, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Combien de continents y a-t-il sur Terre ?', reponses: ['5', '6', '7', '8'], bonneReponse: 2, categorie: Categorie.cultureGenerale, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le plus grand océan du monde ?', reponses: ['Atlantique', 'Pacifique', 'Indien', 'Arctique'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel animal est le roi de la jungle ?', reponses: ['Lion', 'Tigre', 'Éléphant', 'Gorille'], bonneReponse: 0, categorie: Categorie.cultureGenerale, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Combien de couleurs y a-t-il dans un arc-en-ciel ?', reponses: ['5', '6', '7', '8'], bonneReponse: 2, categorie: Categorie.cultureGenerale, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le plus grand désert du monde ?', reponses: ['Sahara', 'Gobi', 'Antarctique', 'Kalahari'], bonneReponse: 2, categorie: Categorie.cultureGenerale, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le symbole chimique de l\'or ?', reponses: ['Ag', 'Au', 'Fe', 'Cu'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Combien de planètes dans notre système solaire ?', reponses: ['7', '8', '9', '10'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le plus grand mammifère terrestre ?', reponses: ['Girafe', 'Éléphant d\'Afrique', 'Rhinocéros', 'Hippopotame'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le nom de la plus haute montagne du monde ?', reponses: ['K2', 'Mont Everest', 'Kangchenjunga', 'Lhotse'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.facile),
    ],
    // =============================================================================
    // QUESTIONS MOYENNES - CULTURE GÉNÉRALE
    // =============================================================================
    /// Questions intermédiaires sur l'histoire, la géographie avancée et les sciences
    /// Niveau nécessitant des connaissances générales solides
    Difficulte.moyen: [
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la Révolution française ?', reponses: ['1492', '1789', '1914', '1848'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le plus grand pays du monde en superficie ?', reponses: ['Chine', 'États-Unis', 'Canada', 'Russie'], bonneReponse: 3, categorie: Categorie.cultureGenerale, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Combien d\'os y a-t-il dans le corps humain adulte ?', reponses: ['156', '206', '256', '306'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le plus grand volcan actif d\'Europe ?', reponses: ['Vésuve', 'Etna', 'Stromboli', 'Piton de la Fournaise'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le nom de la plus grande forêt tropicale du monde ?', reponses: ['Forêt du Congo', 'Amazonie', 'Forêt de Bornéo', 'Forêt de Sumatra'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Combien de langues officielles y a-t-il en Suisse ?', reponses: ['2', '3', '4', '5'], bonneReponse: 2, categorie: Categorie.cultureGenerale, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le plus grand lac d\'eau douce du monde ?', reponses: ['Lac Supérieur', 'Lac Victoria', 'Lac Baïkal', 'Lac Tanganyika'], bonneReponse: 2, categorie: Categorie.cultureGenerale, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le nom de la plus grande île du monde ?', reponses: ['Australie', 'Groenland', 'Nouvelle-Guinée', 'Bornéo'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Combien de chromosomes a l\'être humain ?', reponses: ['23', '46', '69', '92'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le plus grand oiseau volant du monde ?', reponses: ['Condor des Andes', 'Albatros hurleur', 'Marabout d\'Afrique', 'Aigle royal'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.moyen),
    ],
    // =============================================================================
    // QUESTIONS DIFFICILES - CULTURE GÉNÉRALE
    // =============================================================================
    /// Questions avancées sur des sujets spécialisés et des connaissances pointues
    /// Niveau expert nécessitant une culture générale très étendue
    Difficulte.difficile: [
      QuestionModel(id: _uuid.v4(), question: 'Quel est le nom du président du Conseil pendant la Seconde Guerre mondiale en France ?', reponses: ['Charles de Gaulle', 'Philippe Pétain', 'Georges Clemenceau', 'Paul Reynaud'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le plus grand canyon du monde ?', reponses: ['Grand Canyon', 'Canyon du Yarlung Tsangpo', 'Canyon du Colca', 'Canyon de Copper'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Combien de muscles y a-t-il dans le corps humain ?', reponses: ['400', '600', '800', '1000'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le plus grand récif corallien du monde ?', reponses: ['Barrière de corail de Belize', 'Grande Barrière de Corail', 'Récif de Tubbataha', 'Récif de Raja Ampat'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le nom de la plus haute chute d\'eau du monde ?', reponses: ['Chutes du Niagara', 'Chutes Victoria', 'Salto Angel', 'Chutes d\'Iguazu'], bonneReponse: 2, categorie: Categorie.cultureGenerale, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Combien de pays composent l\'Union européenne (2024) ?', reponses: ['25', '27', '28', '30'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le plus grand désert de sable du monde ?', reponses: ['Sahara', 'Désert d\'Arabie', 'Désert de Gobi', 'Désert de Kalahari'], bonneReponse: 0, categorie: Categorie.cultureGenerale, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le nom de la plus grande grotte du monde ?', reponses: ['Grotte de Mammoth', 'Grotte de Son Doong', 'Grotte de Clearwater', 'Grotte de Sistema Sac Actun'], bonneReponse: 1, categorie: Categorie.cultureGenerale, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Combien de langues sont parlées dans le monde ?', reponses: ['3000', '5000', '7000', '9000'], bonneReponse: 2, categorie: Categorie.cultureGenerale, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le plus grand glacier du monde ?', reponses: ['Glacier de l\'Antarctique', 'Glacier de Vatnajökull', 'Glacier de Perito Moreno', 'Glacier de Columbia'], bonneReponse: 0, categorie: Categorie.cultureGenerale, difficulte: Difficulte.difficile),
    ],
  };

  // PROGRAMMATION
  static final Map<Difficulte, List<QuestionModel>> _programmation = {
    Difficulte.facile: [
      QuestionModel(id: _uuid.v4(), question: 'Quel langage est utilisé pour le développement Android natif ?', reponses: ['Kotlin', 'Swift', 'JavaScript', 'Ruby'], bonneReponse: 0, categorie: Categorie.programmation, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le langage de programmation le plus populaire ?', reponses: ['Python', 'Java', 'JavaScript', 'C++'], bonneReponse: 2, categorie: Categorie.programmation, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Que signifie HTML ?', reponses: ['HyperText Markup Language', 'High Tech Modern Language', 'Home Tool Markup Language', 'Hyperlink and Text Markup Language'], bonneReponse: 0, categorie: Categorie.programmation, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le symbole pour les commentaires en Python ?', reponses: ['//', '#', '/*', '--'], bonneReponse: 1, categorie: Categorie.programmation, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel framework est utilisé pour Flutter ?', reponses: ['Dart', 'Java', 'Kotlin', 'Swift'], bonneReponse: 0, categorie: Categorie.programmation, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Que signifie CSS ?', reponses: ['Computer Style Sheets', 'Cascading Style Sheets', 'Creative Style Sheets', 'Colorful Style Sheets'], bonneReponse: 1, categorie: Categorie.programmation, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le langage de base du web ?', reponses: ['HTML', 'CSS', 'JavaScript', 'PHP'], bonneReponse: 0, categorie: Categorie.programmation, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel IDE est développé par Microsoft ?', reponses: ['Eclipse', 'IntelliJ', 'Visual Studio Code', 'NetBeans'], bonneReponse: 2, categorie: Categorie.programmation, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le langage de programmation de Google ?', reponses: ['Go', 'Rust', 'Kotlin', 'Swift'], bonneReponse: 0, categorie: Categorie.programmation, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Que signifie API ?', reponses: ['Application Programming Interface', 'Advanced Programming Interface', 'Automated Programming Interface', 'Application Process Interface'], bonneReponse: 0, categorie: Categorie.programmation, difficulte: Difficulte.facile),
    ],
    Difficulte.moyen: [
      QuestionModel(id: _uuid.v4(), question: 'Quel design pattern permet de créer des objets sans spécifier leur classe exacte ?', reponses: ['Singleton', 'Factory', 'Observer', 'Strategy'], bonneReponse: 1, categorie: Categorie.programmation, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le principe fondamental de la POO qui permet de cacher les détails d\'implémentation ?', reponses: ['Héritage', 'Encapsulation', 'Polymorphisme', 'Abstraction'], bonneReponse: 1, categorie: Categorie.programmation, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel protocole est utilisé pour les requêtes HTTP sécurisées ?', reponses: ['HTTP', 'HTTPS', 'FTP', 'SMTP'], bonneReponse: 1, categorie: Categorie.programmation, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le nom du gestionnaire de paquets pour Node.js ?', reponses: ['npm', 'pip', 'composer', 'gradle'], bonneReponse: 0, categorie: Categorie.programmation, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel framework JavaScript est développé par Facebook ?', reponses: ['Angular', 'React', 'Vue.js', 'Ember'], bonneReponse: 1, categorie: Categorie.programmation, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le langage de requête pour les bases de données relationnelles ?', reponses: ['SQL', 'NoSQL', 'MongoDB', 'GraphQL'], bonneReponse: 0, categorie: Categorie.programmation, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le nom du système de contrôle de version le plus populaire ?', reponses: ['SVN', 'Git', 'Mercurial', 'CVS'], bonneReponse: 1, categorie: Categorie.programmation, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le paradigme de programmation utilisé par Haskell ?', reponses: ['Impératif', 'Fonctionnel', 'Logique', 'Orienté objet'], bonneReponse: 1, categorie: Categorie.programmation, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le nom du compilateur JavaScript de Google ?', reponses: ['V8', 'SpiderMonkey', 'Chakra', 'JavaScriptCore'], bonneReponse: 0, categorie: Categorie.programmation, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le langage de programmation le plus ancien encore utilisé ?', reponses: ['FORTRAN', 'COBOL', 'LISP', 'BASIC'], bonneReponse: 0, categorie: Categorie.programmation, difficulte: Difficulte.moyen),
    ],
    Difficulte.difficile: [
      QuestionModel(id: _uuid.v4(), question: 'Quel algorithme de tri a la complexité temporelle moyenne O(n log n) ?', reponses: ['Tri à bulles', 'Tri rapide', 'Tri par insertion', 'Tri par sélection'], bonneReponse: 1, categorie: Categorie.programmation, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le nom du problème de programmation dynamique pour trouver la plus longue sous-séquence commune ?', reponses: ['LCS', 'LIS', 'LPS', 'LDS'], bonneReponse: 0, categorie: Categorie.programmation, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le protocole de communication utilisé par les microservices ?', reponses: ['REST', 'SOAP', 'gRPC', 'GraphQL'], bonneReponse: 2, categorie: Categorie.programmation, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le nom de l\'algorithme de consensus utilisé par Bitcoin ?', reponses: ['Proof of Stake', 'Proof of Work', 'Proof of Authority', 'Proof of Space'], bonneReponse: 1, categorie: Categorie.programmation, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le langage de programmation utilisé pour développer le noyau Linux ?', reponses: ['C', 'C++', 'Assembly', 'Rust'], bonneReponse: 0, categorie: Categorie.programmation, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le nom du pattern architectural qui sépare les données de la logique métier ?', reponses: ['MVC', 'MVP', 'MVVM', 'Clean Architecture'], bonneReponse: 3, categorie: Categorie.programmation, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le protocole de routage utilisé par Internet ?', reponses: ['HTTP', 'TCP/IP', 'BGP', 'DNS'], bonneReponse: 2, categorie: Categorie.programmation, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le nom de l\'algorithme de compression sans perte le plus efficace ?', reponses: ['ZIP', 'RAR', 'LZMA', 'BZIP2'], bonneReponse: 2, categorie: Categorie.programmation, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le langage de programmation utilisé pour développer Docker ?', reponses: ['Go', 'Rust', 'C++', 'Python'], bonneReponse: 0, categorie: Categorie.programmation, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le nom du problème de programmation linéaire pour optimiser les ressources ?', reponses: ['Problème du voyageur de commerce', 'Problème du sac à dos', 'Problème d\'affectation', 'Problème de transport'], bonneReponse: 1, categorie: Categorie.programmation, difficulte: Difficulte.difficile),
    ],
  };

  // MATHÉMATIQUES
  static final Map<Difficulte, List<QuestionModel>> _mathematiques = {
    Difficulte.facile: [
      QuestionModel(id: _uuid.v4(), question: 'Combien font 2 + 2 ?', reponses: ['3', '4', '5', '6'], bonneReponse: 1, categorie: Categorie.mathematiques, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le résultat de 5 × 6 ?', reponses: ['25', '30', '35', '40'], bonneReponse: 1, categorie: Categorie.mathematiques, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Combien font 10 - 3 ?', reponses: ['5', '6', '7', '8'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le résultat de 15 ÷ 3 ?', reponses: ['3', '4', '5', '6'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Combien font 7 + 8 ?', reponses: ['13', '14', '15', '16'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le carré de 4 ?', reponses: ['8', '12', '16', '20'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Combien font 20 ÷ 4 ?', reponses: ['3', '4', '5', '6'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le résultat de 3 × 7 ?', reponses: ['18', '21', '24', '27'], bonneReponse: 1, categorie: Categorie.mathematiques, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Combien font 12 - 5 ?', reponses: ['5', '6', '7', '8'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le double de 9 ?', reponses: ['16', '18', '20', '22'], bonneReponse: 1, categorie: Categorie.mathematiques, difficulte: Difficulte.facile),
    ],
    Difficulte.moyen: [
      QuestionModel(id: _uuid.v4(), question: 'Quel est le résultat de 25 × 4 ?', reponses: ['80', '90', '100', '110'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Combien font 144 ÷ 12 ?', reponses: ['10', '11', '12', '13'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le carré de 12 ?', reponses: ['120', '132', '144', '156'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Combien font 17 + 23 ?', reponses: ['38', '39', '40', '41'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le résultat de 8 × 9 ?', reponses: ['64', '72', '80', '88'], bonneReponse: 1, categorie: Categorie.mathematiques, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Combien font 100 - 37 ?', reponses: ['61', '62', '63', '64'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le cube de 3 ?', reponses: ['9', '18', '27', '36'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Combien font 56 ÷ 7 ?', reponses: ['6', '7', '8', '9'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le résultat de 15 × 6 ?', reponses: ['80', '85', '90', '95'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Combien font 200 ÷ 8 ?', reponses: ['20', '22', '25', '28'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.moyen),
    ],
    Difficulte.difficile: [
      QuestionModel(id: _uuid.v4(), question: 'Quel est le résultat de 17 × 23 ?', reponses: ['361', '371', '381', '391'], bonneReponse: 3, categorie: Categorie.mathematiques, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Combien font 1 000 000 ÷ 125 ?', reponses: ['6000', '7000', '8000', '9000'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le carré de 25 ?', reponses: ['500', '525', '600', '625'], bonneReponse: 3, categorie: Categorie.mathematiques, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Combien font 47 × 53 ?', reponses: ['2491', '2492', '2493', '2494'], bonneReponse: 0, categorie: Categorie.mathematiques, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le cube de 7 ?', reponses: ['343', '350', '357', '364'], bonneReponse: 0, categorie: Categorie.mathematiques, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Combien font 999 × 11 ?', reponses: ['10989', '10990', '10991', '10992'], bonneReponse: 0, categorie: Categorie.mathematiques, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le résultat de 256 ÷ 16 ?', reponses: ['14', '15', '16', '17'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Combien font 89 × 91 ?', reponses: ['8099', '8100', '8101', '8102'], bonneReponse: 0, categorie: Categorie.mathematiques, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel est le carré de 32 ?', reponses: ['1024', '1025', '1026', '1027'], bonneReponse: 0, categorie: Categorie.mathematiques, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Combien font 1000 ÷ 7 (arrondi à l\'entier) ?', reponses: ['140', '141', '142', '143'], bonneReponse: 2, categorie: Categorie.mathematiques, difficulte: Difficulte.difficile),
    ],
  };

  // HISTOIRE
  static final Map<Difficulte, List<QuestionModel>> _histoire = {
    Difficulte.facile: [
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la prise de la Bastille ?', reponses: ['1789', '1790', '1791', '1792'], bonneReponse: 0, categorie: Categorie.histoire, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel roi de France était surnommé le Roi Soleil ?', reponses: ['Louis XIII', 'Louis XIV', 'Louis XV', 'Louis XVI'], bonneReponse: 1, categorie: Categorie.histoire, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel était le nom de la première femme dans l\'espace ?', reponses: ['Sally Ride', 'Valentina Terechkova', 'Mae Jemison', 'Eileen Collins'], bonneReponse: 1, categorie: Categorie.histoire, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la découverte de l\'Amérique par Christophe Colomb ?', reponses: ['1490', '1491', '1492', '1493'], bonneReponse: 2, categorie: Categorie.histoire, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel était le nom du premier empereur romain ?', reponses: ['Jules César', 'Auguste', 'Tibère', 'Caligula'], bonneReponse: 1, categorie: Categorie.histoire, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la chute du mur de Berlin ?', reponses: ['1987', '1988', '1989', '1990'], bonneReponse: 2, categorie: Categorie.histoire, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel était le nom du pharaon qui a fait construire la plus grande pyramide ?', reponses: ['Ramsès II', 'Toutânkhamon', 'Khéops', 'Khéphren'], bonneReponse: 2, categorie: Categorie.histoire, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la bataille de Waterloo ?', reponses: ['1813', '1814', '1815', '1816'], bonneReponse: 2, categorie: Categorie.histoire, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'Quel était le nom du premier président des États-Unis ?', reponses: ['John Adams', 'Thomas Jefferson', 'George Washington', 'Benjamin Franklin'], bonneReponse: 2, categorie: Categorie.histoire, difficulte: Difficulte.facile),
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la Révolution russe ?', reponses: ['1915', '1916', '1917', '1918'], bonneReponse: 2, categorie: Categorie.histoire, difficulte: Difficulte.facile),
    ],
    Difficulte.moyen: [
      QuestionModel(id: _uuid.v4(), question: 'Quel était le nom de la reine d\'Égypte qui a régné avec César et Marc Antoine ?', reponses: ['Néfertiti', 'Cléopâtre', 'Hatchepsout', 'Nefertari'], bonneReponse: 1, categorie: Categorie.histoire, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la bataille de Hastings ?', reponses: ['1066', '1067', '1068', '1069'], bonneReponse: 0, categorie: Categorie.histoire, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel était le nom du roi d\'Angleterre qui a eu 6 épouses ?', reponses: ['Henri VII', 'Henri VIII', 'Édouard VI', 'Marie Tudor'], bonneReponse: 1, categorie: Categorie.histoire, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la découverte de la pénicilline ?', reponses: ['1928', '1929', '1930', '1931'], bonneReponse: 0, categorie: Categorie.histoire, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel était le nom de l\'empereur romain qui a construit le Colisée ?', reponses: ['Néron', 'Vespasien', 'Titus', 'Domitien'], bonneReponse: 1, categorie: Categorie.histoire, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la bataille de Verdun ?', reponses: ['1914', '1915', '1916', '1917'], bonneReponse: 2, categorie: Categorie.histoire, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel était le nom du premier homme à marcher sur la Lune ?', reponses: ['Buzz Aldrin', 'Neil Armstrong', 'Michael Collins', 'Alan Shepard'], bonneReponse: 1, categorie: Categorie.histoire, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la chute de Constantinople ?', reponses: ['1451', '1452', '1453', '1454'], bonneReponse: 2, categorie: Categorie.histoire, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'Quel était le nom du roi de France qui a signé l\'édit de Nantes ?', reponses: ['Henri III', 'Henri IV', 'Louis XIII', 'Louis XIV'], bonneReponse: 1, categorie: Categorie.histoire, difficulte: Difficulte.moyen),
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la bataille de Trafalgar ?', reponses: ['1803', '1804', '1805', '1806'], bonneReponse: 2, categorie: Categorie.histoire, difficulte: Difficulte.moyen),
    ],
    Difficulte.difficile: [
      QuestionModel(id: _uuid.v4(), question: 'Quel était le nom du général carthaginois qui a traversé les Alpes avec des éléphants ?', reponses: ['Hannibal', 'Hasdrubal', 'Magon', 'Hamilcar'], bonneReponse: 0, categorie: Categorie.histoire, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la bataille de Cannes ?', reponses: ['216 av. J.-C.', '215 av. J.-C.', '214 av. J.-C.', '213 av. J.-C.'], bonneReponse: 0, categorie: Categorie.histoire, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel était le nom de l\'empereur byzantin qui a codifié le droit romain ?', reponses: ['Justinien', 'Théodose', 'Constantin', 'Héraclius'], bonneReponse: 0, categorie: Categorie.histoire, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la bataille de Poitiers (732) ?', reponses: ['730', '731', '732', '733'], bonneReponse: 2, categorie: Categorie.histoire, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel était le nom du roi wisigoth qui a saccagé Rome en 410 ?', reponses: ['Alaric', 'Athaulf', 'Wallia', 'Théodoric'], bonneReponse: 0, categorie: Categorie.histoire, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la bataille de Hastings ?', reponses: ['1064', '1065', '1066', '1067'], bonneReponse: 2, categorie: Categorie.histoire, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel était le nom du pape qui a lancé la première croisade ?', reponses: ['Urbain II', 'Grégoire VII', 'Pascal II', 'Gélase II'], bonneReponse: 0, categorie: Categorie.histoire, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la bataille de Bouvines ?', reponses: ['1212', '1213', '1214', '1215'], bonneReponse: 2, categorie: Categorie.histoire, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'Quel était le nom du roi de France qui a été fait prisonnier à Pavie ?', reponses: ['François Ier', 'Henri II', 'Charles IX', 'Henri III'], bonneReponse: 0, categorie: Categorie.histoire, difficulte: Difficulte.difficile),
      QuestionModel(id: _uuid.v4(), question: 'En quelle année a eu lieu la bataille de Lépante ?', reponses: ['1569', '1570', '1571', '1572'], bonneReponse: 2, categorie: Categorie.histoire, difficulte: Difficulte.difficile),
    ],
  };
} 