import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:infoquiz/firebase_options.dart';
import 'package:infoquiz/screens/auth/sign_in_screen.dart';
import 'package:infoquiz/screens/auth/sign_up_screen.dart';
import 'package:infoquiz/screens/auth/reset_password_screen.dart';
import 'package:infoquiz/screens/home_screen.dart';
import 'package:infoquiz/screens/profile_screen.dart';
import 'package:infoquiz/screens/settings_screen.dart';
import 'package:infoquiz/screens/quiz_screen.dart';
import 'package:infoquiz/theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialisé avec succès');
    runApp(const InfoQuizApp());
  } catch (e) {
    print('Erreur lors de l\'initialisation de Firebase: \$e');
    runApp(const FirebaseErrorApp());
  }
}

class FirebaseErrorApp extends StatelessWidget {
  const FirebaseErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
                  'Impossible de se connecter aux services Firebase. Veuillez vérifier votre connexion internet ou réessayer plus tard.',
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

class InfoQuizApp extends StatelessWidget {
  const InfoQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InfoQuiz',
      debugShowCheckedModeBanner: false,
      theme: infoquizTheme,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
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
            final args = settings.arguments;

            if (args is Map<String, dynamic>) {
              final parsedArgs = QuizScreenArguments.fromMap(args);
              return MaterialPageRoute(
                builder:
                    (_) => QuizScreen(
                      categoryId: parsedArgs.categoryId,
                      subcategoryId: parsedArgs.subcategoryId,
                      level: parsedArgs.level,
                    ),
              );
            } else if (args is QuizScreenArguments) {
              return MaterialPageRoute(
                builder:
                    (_) => QuizScreen(
                      categoryId: args.categoryId,
                      subcategoryId: args.subcategoryId,
                      level: args.level,
                    ),
              );
            } else {
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
