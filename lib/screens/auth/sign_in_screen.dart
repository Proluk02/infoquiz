import 'package:flutter/material.dart';
import '/widgets/iq_logo.dart';
import '/widgets/iq_textfield.dart';
import '/widgets/iq_button.dart';
import '/widgets/iq_link_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  bool loading = false;
  String? errorMsg;

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailCtrl.dispose();
    pwdCtrl.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        loading = true;
        errorMsg = null;
      });

      // Simuler un traitement
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          loading = false;
          errorMsg = 'Connexion simulée réussie.';
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const IQLogo(),
                  const SizedBox(height: 24),
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              'Bienvenue !',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 20),
                            IQTextField(
                              controller: emailCtrl,
                              hint: 'Email',
                              icon: Icons.email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer un email';
                                } else if (!value.contains('@')) {
                                  return 'Email invalide';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            IQTextField(
                              controller: pwdCtrl,
                              hint: 'Mot de passe',
                              icon: Icons.lock,
                              obscure: true,
                              validator: (value) {
                                if (value == null || value.length < 6) {
                                  return 'Mot de passe trop court';
                                }
                                return null;
                              },
                            ),
                            if (errorMsg != null) ...[
                              const SizedBox(height: 12),
                              Text(
                                errorMsg!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ],
                            const SizedBox(height: 24),
                            IQButton(
                              label: 'Se connecter',
                              onPressed: _onLogin,
                              loading: loading,
                            ),
                            const SizedBox(height: 12),
                            IQLinkButton(
                              label: 'Pas encore de compte ? Créer un compte',
                              onTap:
                                  () => Navigator.pushNamed(context, '/signup'),
                            ),
                            IQLinkButton(
                              label: 'Mot de passe oublié ?',
                              onTap:
                                  () => Navigator.pushNamed(context, '/reset'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!isMobile) const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
