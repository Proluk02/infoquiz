import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:infoquiz/screens/auth/reset_password_screen.dart';
import 'package:infoquiz/screens/auth/sign_up_screen.dart';
import 'package:infoquiz/screens/home_screen.dart';
import 'firebase_options.dart';
import 'screens/auth/sign_in_screen.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const InfoQuizApp());
}

class InfoQuizApp extends StatelessWidget {
  const InfoQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InfoQuiz',
      theme: infoquizTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SignInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/reset': (context) => const ResetPasswordScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
