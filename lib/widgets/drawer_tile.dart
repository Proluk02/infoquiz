import 'package:flutter/material.dart';

// Élément de menu réutilisable pour le Drawer (menu latéral)
class DrawerTile extends StatelessWidget {
  // Icône à afficher à gauche
  final IconData icon;
  // Texte du menu
  final String title;
  // Couleur personnalisée (optionnelle)
  final Color? color;
  // Action à effectuer au clic
  final VoidCallback onTap;

  const DrawerTile({
    super.key,
    required this.icon,
    required this.title,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Bloc : Icône du menu
      leading: Icon(
        icon,
        color: color ?? Theme.of(context).colorScheme.primary,
      ),
      // Bloc : Titre du menu
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      // Bloc : Action au clic
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      minLeadingWidth: 24,
    );
  }
}
