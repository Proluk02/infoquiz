import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.displayName ?? '';
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() => _isLoading = true);
      final ref = FirebaseStorage.instance.ref(
        'profile_pictures/${user!.uid}.jpg',
      );
      await ref.putFile(File(picked.path));
      final photoUrl = await ref.getDownloadURL();
      await user!.updatePhotoURL(photoUrl);
      await user!.reload();
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Photo mise à jour")));
    }
  }

  Future<void> _updateDisplayName() async {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty && newName != user!.displayName) {
      setState(() => _isLoading = true);
      await user!.updateDisplayName(newName);
      await user!.reload();
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Nom mis à jour")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = user?.photoURL;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0E4D92),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              photoUrl != null ? NetworkImage(photoUrl) : null,
                          backgroundColor: const Color(0xFFE2E8F0),
                          child:
                              photoUrl == null
                                  ? const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Color(0xFF0E4D92),
                                  )
                                  : null,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.camera_alt_rounded,
                            color: Color(0xFF0E4D92),
                          ),
                          onPressed: _pickAndUploadImage,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: user?.email ?? '',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _updateDisplayName,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E4D92),
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.save),
                      label: const Text("Enregistrer les modifications"),
                    ),
                  ],
                ),
              ),
    );
  }
}
