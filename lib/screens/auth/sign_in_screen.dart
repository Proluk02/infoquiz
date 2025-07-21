import 'package:flutter/material.dart';
import '/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/widgets/iq_logo.dart';
import '/widgets/iq_textfield.dart';
import '/widgets/iq_button.dart';
import '/widgets/iq_link_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  bool loading = false;
  String? errorMsg;

  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
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

  void _onLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        loading = true;
        errorMsg = null;
      });

      try {
        final user = await AuthService().signIn(
          emailCtrl.text.trim(),
          pwdCtrl.text.trim(),
        );

        if (user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          errorMsg = e.message ?? 'Erreur de connexion.';
        });
      } finally {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const IQLogo(size: 80),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 32,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Bienvenue 👋',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              IQTextField(
                                controller: emailCtrl,
                                hint: 'Adresse email',
                                icon: Icons.email_outlined,
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
                                icon: Icons.lock_outline,
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
                                  textAlign: TextAlign.center,
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
                                    () =>
                                        Navigator.pushNamed(context, '/signup'),
                              ),
                              IQLinkButton(
                                label: 'Mot de passe oublié ?',
                                onTap:
                                    () =>
                                        Navigator.pushNamed(context, '/reset'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (!isMobile) const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
