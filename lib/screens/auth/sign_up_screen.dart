import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/services/auth_service.dart';
import '/widgets/iq_textfield.dart';
import '/widgets/iq_button.dart';
import '/widgets/iq_link_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  bool loading = false;
  String? errorMsg;

  void _onSignUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => loading = true);

      try {
        final user = await AuthService().signUp(
          emailCtrl.text.trim(),
          pwdCtrl.text.trim(),
        );
        if (user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } on FirebaseAuthException catch (e) {
        setState(() => errorMsg = e.message);
      } finally {
        setState(() => loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créer un compte')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              IQTextField(
                controller: emailCtrl,
                hint: 'Email',
                icon: Icons.email_outlined,
                validator:
                    (value) =>
                        value != null && value.contains('@')
                            ? null
                            : 'Email invalide',
              ),
              const SizedBox(height: 16),
              IQTextField(
                controller: pwdCtrl,
                hint: 'Mot de passe',
                icon: Icons.lock_outline,
                obscure: true,
                validator:
                    (value) =>
                        value != null && value.length >= 6
                            ? null
                            : 'Mot de passe trop court',
              ),
              const SizedBox(height: 20),
              if (errorMsg != null)
                Text(errorMsg!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              IQButton(
                label: 'Créer un compte',
                onPressed: _onSignUp,
                loading: loading,
              ),
              IQLinkButton(
                label: 'Retour à la connexion',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
