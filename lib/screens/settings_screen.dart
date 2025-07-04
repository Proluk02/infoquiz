import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0E4D92),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Préférences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            value: true,
            onChanged: (val) {},
            title: const Text('Notifications'),
            secondary: const Icon(Icons.notifications_active),
          ),
          SwitchListTile(
            value: false,
            onChanged: (val) {},
            title: const Text('Mode sombre'),
            secondary: const Icon(Icons.dark_mode),
          ),
          const SizedBox(height: 24),
          const Text(
            'Autres',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: const Text('Politique de confidentialité'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('À propos'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'InfoQuiz',
                applicationVersion: 'v1.0.0',
                applicationIcon: const FlutterLogo(),
                children: const [
                  Text('InfoQuiz est une application éducative interactive.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
