// Importation des packages nécessaires pour l'application Flutter et Firebase
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Importation des fichiers internes de l'application
import 'package:infoquiz/firebase_options.dart';
import 'package:infoquiz/splash_screen.dart';
import 'package:infoquiz/theme/theme.dart';

// Importation des différents écrans de l'application
import 'package:infoquiz/screens/auth/sign_in_screen.dart';
import 'package:infoquiz/screens/auth/sign_up_screen.dart';
import 'package:infoquiz/screens/auth/reset_password_screen.dart';
import 'package:infoquiz/screens/home_screen.dart';
import 'package:infoquiz/screens/profile_screen.dart';
import 'package:infoquiz/screens/settings_screen.dart';
import 'package:infoquiz/screens/quiz_screen.dart';

// Point d'entrée principal de l'application
// On initialise d'abord les widgets Flutter puis Firebase
// Si tout se passe bien, on lance l'application principale
// Sinon, on affiche un écran d'erreur
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialisé avec succès');
    runApp(const InfoQuizApp());
  } catch (e) {
    print('❌ Erreur Firebase: $e');
    runApp(const FirebaseErrorApp());
  }
}

// Widget affiché si la connexion à Firebase échoue
class FirebaseErrorApp extends StatelessWidget {
  const FirebaseErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: infoquizTheme,
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 20),
                Text(
                  'Erreur de connexion',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Impossible de se connecter à Firebase. Vérifiez votre connexion.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Classe pour transporter les arguments nécessaires à l'écran Quiz
// Permet de passer la catégorie, la sous-catégorie et le niveau
class QuizScreenArguments {
  final String categoryId;
  final String subcategoryId;
  final String level;

  QuizScreenArguments({
    required this.categoryId,
    required this.subcategoryId,
    required this.level,
  });

  factory QuizScreenArguments.fromMap(Map<String, dynamic> map) {
    return QuizScreenArguments(
      categoryId: map['categoryId'] as String,
      subcategoryId: map['subcategoryId'] as String,
      level: map['level'] as String,
    );
  }
}

// Widget principal de l'application
// Définit le thème, l'écran de démarrage et la navigation entre les pages
class InfoQuizApp extends StatelessWidget {
  const InfoQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InfoQuiz',
      debugShowCheckedModeBanner: false,
      theme: infoquizTheme,
      home: const SplashScreen(), // On affiche d'abord l'écran d'animation
      onGenerateRoute: (settings) {
        // Gestion de la navigation selon le nom de la route
        switch (settings.name) {
          case '/signin':
            return MaterialPageRoute(builder: (_) => const SignInScreen());
          case '/signup':
            return MaterialPageRoute(builder: (_) => const SignUpScreen());
          case '/reset':
            return MaterialPageRoute(
              builder: (_) => const ResetPasswordScreen(),
            );
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfileScreen());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/quiz':
            // On récupère les arguments passés à l'écran Quiz
            final args = settings.arguments;
            if (args is Map<String, dynamic>) {
              final parsedArgs = QuizScreenArguments.fromMap(args);
              return MaterialPageRoute(
                builder:
                    (_) => QuizScreen(
                      categoryId: parsedArgs.categoryId,
                      subcategoryId: parsedArgs.subcategoryId,
                      level: parsedArgs.level,
                      userId: '',
                    ),
              );
            } else if (args is QuizScreenArguments) {
              return MaterialPageRoute(
                builder:
                    (_) => QuizScreen(
                      categoryId: args.categoryId,
                      subcategoryId: args.subcategoryId,
                      level: args.level,
                      userId: '',
                    ),
              );
            } else {
              // Si les arguments sont invalides, on affiche un message d'erreur
              return MaterialPageRoute(
                builder:
                    (_) => Scaffold(
                      body: Center(
                        child: Text(
                          'Arguments invalides pour l\'écran Quiz',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                    ),
              );
            }
          default:
            // Si la page n'existe pas, on affiche un message d'erreur
            return MaterialPageRoute(
              builder:
                  (_) => Scaffold(
                    body: Center(
                      child: Text(
                        'Page non trouvée',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ),
            );
        }
      },
    );
  }
}

// Écran qui décide si l'utilisateur doit voir la page d'accueil ou la page de connexion
// Pratique pour la redirection automatique après le splash screen
class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: Future.value(FirebaseAuth.instance.currentUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // On affiche un loader pendant la vérification
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          // Si l'utilisateur est connecté, on va à l'accueil
          return const HomeScreen();
        } else {
          // Sinon, on affiche la page de connexion
          return const SignInScreen();
        }
      },
    );
  }
}
