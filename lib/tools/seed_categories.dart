// Script utilitaire pour insérer les catégories et sous-catégories dans Firestore
// À lancer une seule fois pour initialiser la base de données
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart'; // adapte le chemin si besoin

Future<void> main() async {
  // Initialisation de Flutter et de Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;

  // Liste des catégories à insérer (avec icône et sous-catégories)
  final List<Map<String, dynamic>> categories = [
    {
      "title": "Informatique & TIC",
      "icon": "computer",
      "subcategories": [
        "Programmation",
        "Réseaux",
        "Systèmes",
        "Bureautique",
        "Base de données",
      ],
    },
    {
      "title": "Culture générale",
      "icon": "public",
      "subcategories": [
        "Histoire",
        "Géographie",
        "Actualité",
        "Civisme",
        "Société",
      ],
    },
    {
      "title": "Mathématiques",
      "icon": "calculate",
      "subcategories": [
        "Algèbre",
        "Analyse",
        "Géométrie",
        "Probabilités",
        "Statistiques",
      ],
    },
    {
      "title": "Sciences",
      "icon": "science",
      "subcategories": [
        "Biologie",
        "Chimie",
        "Physique",
        "Géologie",
        "Astronomie",
      ],
    },
    {
      "title": "Langue & Communication",
      "icon": "language",
      "subcategories": [
        "Français",
        "Anglais",
        "Communication orale",
        "Communication écrite",
      ],
    },
    {
      "title": "Économie & Finance",
      "icon": "attach_money",
      "subcategories": [
        "Microéconomie",
        "Macroéconomie",
        "Comptabilité",
        "Finance publique",
      ],
    },
    {
      "title": "Droit",
      "icon": "gavel",
      "subcategories": [
        "Droit civil",
        "Droit pénal",
        "Droit constitutionnel",
        "Droit commercial",
      ],
    },
    {
      "title": "Technologies émergentes",
      "icon": "auto_awesome",
      "subcategories": [
        "IA",
        "Blockchain",
        "Réalité virtuelle",
        "IoT",
        "Robotique",
      ],
    },
    {
      "title": "Éducation civique",
      "icon": "flag",
      "subcategories": [
        "Citoyenneté",
        "Valeurs républicaines",
        "Constitution",
        "Droits et devoirs",
      ],
    },
    {
      "title": "Santé & Bien-être",
      "icon": "health_and_safety",
      "subcategories": [
        "Nutrition",
        "Hygiène",
        "Santé mentale",
        "Sport",
        "Médecine",
      ],
    },
    {
      "title": "Environnement & Développement durable",
      "icon": "eco",
      "subcategories": [
        "Climat",
        "Énergies renouvelables",
        "Recyclage",
        "Biodiversité",
      ],
    },
    {
      "title": "Culture & Loisirs",
      "icon": "movie",
      "subcategories": ["Cinéma", "Musique", "Peinture", "Jeux", "Voyages"],
    },
    {
      "title": "Entrepreneuriat & Innovation",
      "icon": "lightbulb",
      "subcategories": [
        "Startup",
        "Gestion de projet",
        "Pitch",
        "Business Model",
        "Marketing",
      ],
    },
    {
      "title": "Religion",
      "icon": "menu_book",
      "subcategories": [
        "Christianisme",
        "Islam",
        "Judaïsme",
        "Croyances africaines",
      ],
    },
    {
      "title": "Quiz personnalisés",
      "icon": "extension",
      "subcategories": ["Mes Quiz", "Quiz de Groupe", "Entraînement libre"],
    },
  ];

  // Ajout de chaque catégorie dans Firestore
  for (var category in categories) {
    await firestore.collection('categories').add(category);
    print("✔️ Catégorie '${category['title']}' ajoutée !");
  }

  print("✅ Toutes les catégories ont été ajoutées avec succès !");
}
