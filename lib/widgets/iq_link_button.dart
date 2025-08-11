// Bouton texte cliquable, utilisé pour les liens (ex : "Mot de passe oublié ?")
import 'package:flutter/material.dart';

class IQLinkButton extends StatelessWidget {
  // Texte du lien
  final String label;
  // Action à effectuer au clic
  final VoidCallback onTap;

  const IQLinkButton({Key? key, required this.label, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }
}
