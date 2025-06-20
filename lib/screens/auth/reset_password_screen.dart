import 'package:flutter/material.dart';
import '/services/auth_service.dart';
import '/widgets/iq_textfield.dart';
import '/widgets/iq_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool sent = false;

  void _onReset() async {
    if (_formKey.currentState?.validate() ?? false) {
      await AuthService().resetPassword(emailCtrl.text.trim());
      setState(() => sent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Réinitialiser le mot de passe')),
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
              const SizedBox(height: 20),
              IQButton(label: 'Envoyer', onPressed: _onReset),
              if (sent)
                const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'Lien de réinitialisation envoyé !',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
