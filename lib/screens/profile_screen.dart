import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:infoquiz/screens/HistoryScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _nameController = TextEditingController();
  bool _isLoading = false;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.displayName ?? '';
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);
      final fileSize = await file.length();

      if (fileSize > 5 * 1024 * 1024) {
        _showSnackbar("Image trop lourde (max 5 Mo)");
        return;
      }

      setState(() => _isLoading = true);
      try {
        final ref = FirebaseStorage.instance.ref(
          'profile_pictures/${user!.uid}.jpg',
        );
        await ref.putFile(file);
        final photoUrl = await ref.getDownloadURL();

        await user!.updatePhotoURL(photoUrl);
        await FirebaseAuth.instance.currentUser?.reload();

        _showSnackbar("Photo mise à jour");
        setState(() {});
      } catch (e) {
        _showSnackbar("Erreur : $e");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _updateDisplayName() async {
    final newName = _nameController.text.trim();

    if (newName.isNotEmpty && newName != user!.displayName) {
      setState(() => _isLoading = true);
      try {
        await user!.updateDisplayName(newName);
        await FirebaseAuth.instance.currentUser?.reload();

        _showSnackbar("Nom mis à jour");
        setState(() {});
      } catch (e) {
        _showSnackbar("Erreur : $e");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<Map<String, dynamic>> _fetchUserStats() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();
    return doc.data() ?? {};
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: color),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = user?.photoURL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF212E53),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed:
              () =>
                  Navigator.canPop(context)
                      ? Navigator.pop(context)
                      : Navigator.pushReplacementNamed(context, '/home'),
        ),
        title: const Text('Mon Profil'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF08C5D1),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.person), text: "Profil"),
            Tab(icon: Icon(Icons.history), text: "Historique"),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF0F2F7),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                controller: _tabController,
                children: [
                  _buildProfileTab(photoUrl),
                  user == null
                      ? const Center(child: Text("Utilisateur non connecté"))
                      : HistoryScreen(userId: user!.uid),
                ],
              ),
    );
  }

  Widget _buildProfileTab(String? photoUrl) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage:
                    photoUrl != null ? NetworkImage(photoUrl) : null,
                backgroundColor: const Color(0xFFD0D8E8),
                child:
                    photoUrl == null
                        ? const Icon(
                          Icons.person,
                          size: 60,
                          color: Color(0xFF212E53),
                        )
                        : null,
              ),
              Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 4,
                child: IconButton(
                  icon: const Icon(
                    Icons.camera_alt_rounded,
                    color: Color(0xFF08C5D1),
                    size: 28,
                  ),
                  onPressed: _pickAndUploadImage,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FutureBuilder<Map<String, dynamic>>(
            future: _fetchUserStats(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              final stats = snapshot.data ?? {};
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard(
                    "Score total",
                    "${stats['totalScore'] ?? 0}",
                    Colors.blue,
                  ),
                  _buildStatCard(
                    "Quiz joués",
                    "${stats['quizzesPlayed'] ?? 0}",
                    Colors.green,
                  ),
                  _buildStatCard(
                    "Meilleur",
                    "${stats['highestScore'] ?? 0}",
                    Colors.orange,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _nameController,
            style: const TextStyle(color: Color(0xFF212E53)),
            decoration: InputDecoration(
              labelText: 'Nom',
              prefixIcon: const Icon(Icons.person, color: Color(0xFF212E53)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF08C5D1)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            enabled: false,
            style: const TextStyle(color: Color(0xFF212E53)),
            decoration: InputDecoration(
              labelText: user?.email ?? '',
              prefixIcon: const Icon(Icons.email, color: Color(0xFF212E53)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _updateDisplayName,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF08C5D1),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text(
              "Enregistrer les modifications",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
