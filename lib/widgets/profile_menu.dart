import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileMenu extends StatelessWidget {
  final String? profileImageUrl;

  const ProfileMenu({super.key, this.profileImageUrl});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName;

    return Tooltip(
      message:
          displayName != null
              ? 'Bonjour, $displayName'
              : 'Ouvrir le menu utilisateur',
      child: PopupMenuButton<String>(
        icon: Hero(
          tag: 'profile-pic',
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF08C5D1), Color(0xFF4AA3A2)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white,
              backgroundImage:
                  profileImageUrl != null
                      ? NetworkImage(profileImageUrl!)
                      : null,
              child:
                  profileImageUrl == null
                      ? const Icon(
                        Icons.person_outline_rounded,
                        size: 20,
                        color: Color(0xFF212E53),
                      )
                      : null,
            ),
          ),
        ),
        position: PopupMenuPosition.under,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        elevation: 6,
        onSelected: (value) async {
          if (value == 'logout') {
            final confirm = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Déconnexion', style: GoogleFonts.poppins()),
                    content: Text(
                      'Voulez-vous vraiment vous déconnecter ?',
                      style: GoogleFonts.poppins(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Annuler', style: GoogleFonts.poppins()),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(
                          'Déconnexion',
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
            );

            if (confirm == true) {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
              }
            }
          } else if (value == 'profile') {
            Navigator.pushNamed(context, '/profile');
          } else if (value == 'settings') {
            Navigator.pushNamed(context, '/settings');
          } else if (value == 'support') {
            Navigator.pushNamed(context, '/support');
          }
        },
        itemBuilder:
            (context) => [
              if (displayName != null)
                PopupMenuItem(
                  enabled: false,
                  child: Text(
                    '👤 $displayName',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF212E53),
                    ),
                  ),
                ),
              if (displayName != null) const PopupMenuDivider(),

              PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_outline_rounded,
                      color: Color(0xFF212E53),
                    ),
                    const SizedBox(width: 12),
                    Text('Profil', style: GoogleFonts.poppins()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    const Icon(
                      Icons.settings_outlined,
                      color: Color(0xFF212E53),
                    ),
                    const SizedBox(width: 12),
                    Text('Paramètres', style: GoogleFonts.poppins()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'support',
                child: Row(
                  children: [
                    const Icon(
                      Icons.help_outline_rounded,
                      color: Color(0xFF212E53),
                    ),
                    const SizedBox(width: 12),
                    Text('Support / Aide', style: GoogleFonts.poppins()),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    const Icon(Icons.logout_rounded, color: Colors.red),
                    const SizedBox(width: 12),
                    Text(
                      'Déconnexion',
                      style: GoogleFonts.poppins(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ],
      ),
    );
  }
}
