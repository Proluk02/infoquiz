import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:infoquiz/screens/HistoryScreen.dart';
import 'package:infoquiz/screens/LeaderboardScreen.dart';
import 'package:infoquiz/models/category.dart';
import 'package:infoquiz/services/firestore_service.dart';
import 'package:infoquiz/theme/theme.dart';
import 'package:infoquiz/theme/colors.dart';
import 'package:infoquiz/widgets/category_card.dart';
import 'package:infoquiz/widgets/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String query = '';

  User? get currentUser => FirebaseAuth.instance.currentUser;
  String get userName => currentUser?.displayName ?? 'Utilisateur';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleMenuOption(String value) {
    Navigator.pop(context);
    switch (value) {
      case 'profile':
        Navigator.pushNamed(context, '/profile');
        break;
      case 'settings':
        Navigator.pushNamed(context, '/settings');
        break;
      case 'about':
        Navigator.pushNamed(context, '/about');
        break;
      case 'logout':
        FirebaseAuth.instance.signOut();
        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600 && screenWidth <= 1024;
    final isDesktop = screenWidth > 1024;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const HomeDrawer(),
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF212E53),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.menu_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                    onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'InfoQuiz',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: CircleAvatar(
                      radius: 18,
                      backgroundImage:
                          currentUser?.photoURL != null
                              ? NetworkImage(currentUser!.photoURL!)
                              : null,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child:
                          currentUser?.photoURL == null
                              ? const Icon(Icons.person, color: Colors.white)
                              : null,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: _handleMenuOption,
                    itemBuilder:
                        (_) => [
                          const PopupMenuItem(
                            value: 'profile',
                            child: Text('Mon profil'),
                          ),
                          const PopupMenuItem(
                            value: 'settings',
                            child: Text('Paramètres'),
                          ),
                          const PopupMenuItem(
                            value: 'about',
                            child: Text('À propos de nous'),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            value: 'logout',
                            child: Row(
                              children: const [
                                Icon(Icons.logout, color: Colors.red, size: 18),
                                SizedBox(width: 8),
                                Text('Déconnexion'),
                              ],
                            ),
                          ),
                        ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const LeaderboardScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.emoji_events),
                    label: const Text("Classement"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF08C5D1),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      final userId = FirebaseAuth.instance.currentUser?.uid;
                      if (userId != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HistoryScreen(userId: userId),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.history),
                    label: const Text("Historique"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4AA3A2),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      '👋 Bonjour, $userName',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: const Color(0xFF212E53),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => query = val),
                      decoration: InputDecoration(
                        hintText: 'Rechercher une catégorie...',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFF08C5D1),
                        ),
                        suffixIcon:
                            query.isNotEmpty
                                ? IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Color(0xFF4AA3A2),
                                  ),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => query = '');
                                  },
                                )
                                : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: StreamBuilder<List<Category>>(
                  stream: FirestoreService().getCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final categories = snapshot.data ?? [];
                    final filtered =
                        categories
                            .where(
                              (cat) => cat.title.toLowerCase().contains(
                                query.toLowerCase(),
                              ),
                            )
                            .toList();
                    if (filtered.isEmpty) {
                      return Center(
                        child: Text(
                          'Aucune catégorie trouvée',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.error,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.only(top: 8, bottom: 20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            isDesktop
                                ? 5
                                : isTablet
                                ? 3
                                : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final category = filtered[index];
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: CategoryCard(category: category),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
