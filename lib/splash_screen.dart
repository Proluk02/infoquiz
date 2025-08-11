// Écran d'accueil animé (SplashScreen) qui s'affiche au lancement de l'application
// Affiche une animation, une citation inspirante et redirige automatiquement après quelques secondes
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:infoquiz/main.dart';

// Widget principal du SplashScreen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// État du SplashScreen : gère l'animation, la citation et la redirection
class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Contrôleur et animation pour l'icône animée
  late AnimationController _iconController;
  late Animation<double> _iconAnimation;

  // Citation sélectionnée aléatoirement et affichée lettre par lettre
  late String _selectedQuote;
  String _displayedText = '';
  int _charIndex = 0;

  // Liste de citations inspirantes affichées au hasard
  final List<String> _quotes = [
    '“L’apprentissage est un trésor qui suivra son propriétaire partout.”',
    '“Le savoir, c’est le pouvoir.” – Francis Bacon',
    '“L’éducation est l’arme la plus puissante pour changer le monde.” – Nelson Mandela',
    '“Il n’y a pas de réussite sans échec.”',
    '“Chaque jour est une nouvelle occasion d’apprendre.”',
    '“Un esprit qui s’ouvre à une nouvelle idée ne revient jamais à sa taille d’origine.” – A. Einstein',
    '“Pose des questions. C’est le début du savoir.”',
    '“Lire, c’est rêver les yeux ouverts.”',
    '“Apprends comme si tu devais vivre pour toujours.” – Gandhi',
  ];

  @override
  void initState() {
    super.initState();

    // On choisit une citation au hasard à afficher
    _selectedQuote = _quotes[Random().nextInt(_quotes.length)];

    // Initialisation de l'animation de l'icône
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _iconAnimation = CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeInOut,
    );
    _iconController.repeat(reverse: true);

    // Affichage de la citation lettre par lettre (effet machine à écrire)
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_charIndex < _selectedQuote.length) {
        setState(() {
          _displayedText += _selectedQuote[_charIndex];
          _charIndex++;
        });
      } else {
        timer.cancel();
      }
    });

    // Après 15 secondes, on passe automatiquement à l'écran suivant (InitialScreen)
    Timer(const Duration(seconds: 15), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const InitialScreen()),
      );
    });
  }

  @override
  void dispose() {
    // On libère le contrôleur d'animation pour éviter les fuites mémoire
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Bloc : Icône animée au centre de l'écran
              ScaleTransition(
                scale: _iconAnimation,
                child: const Icon(
                  Icons.quiz,
                  size: 100,
                  color: Colors.blueAccent,
                ),
              ),

              const SizedBox(height: 20),

              // Bloc : Titre de l'application
              Text(
                'InfoQuiz',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 30),

              // Bloc : Citation inspirante affichée en mode "machine à écrire"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  _displayedText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Bloc : Mention légale en bas de l'écran
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  '© 2025 Les Bosseurs – InfoQuiz,\nL\'élégance du savoir, la puissance du code.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
