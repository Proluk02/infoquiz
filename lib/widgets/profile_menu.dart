// 📁 lib/widgets/profile_menu.dart
import 'package:flutter/material.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const CircleAvatar(
          radius: 16,
          backgroundColor: Colors.white,
          child: Icon(Icons.person_rounded, size: 20, color: Color(0xFF0E4D92)),
        ),
      ),
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      elevation: 4,
      onSelected: (value) {
        if (value == 'logout') {
          Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        } else if (value == 'profile') {
          Navigator.pushNamed(context, '/profile');
        } else if (value == 'settings') {
          Navigator.pushNamed(context, '/settings');
        }
      },
      itemBuilder:
          (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  Icon(Icons.person_rounded, color: Color(0xFF0E4D92)),
                  SizedBox(width: 12),
                  Text('Profil'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  Icon(Icons.settings_rounded, color: Color(0xFF0E4D92)),
                  SizedBox(width: 12),
                  Text('Paramètres'),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  Icon(Icons.logout_rounded, color: Colors.red),
                  SizedBox(width: 12),
                  Text('Déconnexion', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
    );
  }
}
