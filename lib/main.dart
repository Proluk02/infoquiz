import 'package:flutter/material.dart';
import 'theme/theme.dart';
import 'screens/home_screen.dart';
import 'screens/auth/sign_in_screen.dart';

void main() {
  runApp(const InfoquizApp());
}

class InfoquizApp extends StatelessWidget {
  const InfoquizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infoquiz',
      home: SignInScreen(), // 👈 on démarre avec SignInScreen
      routes: {
        // '/signup': (context) => const SignUpScreen(),
        //'/reset': (context) => const ResetPasswordScreen(),
        '/home': (context) => const HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: infoquizTheme,
    );
  }
}
