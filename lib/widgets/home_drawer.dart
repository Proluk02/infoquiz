// Menu latéral (Drawer) affiché sur la page d'accueil
// Permet d'accéder rapidement au profil, paramètres, aide, et déconnexion
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'drawer_tile.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // On récupère l'utilisateur actuellement connecté
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.58,
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            // Bloc : En-tête du drawer avec l'avatar, le nom et l'email
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0E4D92), Color(0xFF48CAE4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundImage:
                        user?.photoURL != null
                            ? NetworkImage(user!.photoURL!)
                            : null,
                    backgroundColor: Colors.white,
                    child:
                        user?.photoURL == null
                            ? const Icon(
                              Icons.person,
                              size: 40,
                              color: Color(0xFF0E4D92),
                            )
                            : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Bloc : Nom d'utilisateur
                        Text(
                          user?.displayName ?? 'Utilisateur',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Bloc : Email de l'utilisateur
                        Text(
                          user?.email ?? '',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Bloc : Liste des options du menu
            Expanded(
              child: ListView(
                children: [
                  DrawerTile(
                    icon: Icons.person_outline,
                    title: 'Mon Profil',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/profile');
                    },
                  ),
                  DrawerTile(
                    icon: Icons.settings,
                    title: 'Paramètres',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/settings');
                    },
                  ),
                  DrawerTile(
                    icon: Icons.help_outline,
                    title: 'Aide',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/help');
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Divider(),
                  ),
                  // Bloc : Déconnexion
                  DrawerTile(
                    icon: Icons.logout,
                    title: 'Déconnexion',
                    color: Colors.red,
                    onTap: () async {
                      Navigator.pop(context);
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (_) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
            // Bloc : Mention légale en bas du drawer
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                '© 2025 InfoQuiz',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
