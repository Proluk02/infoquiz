import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoquiz/screens/quiz_screen.dart';

class SubcategoryScreen extends StatelessWidget {
  final String categoryId;
  final String categoryTitle;

  const SubcategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryTitle,
  });

  Future<List<Map<String, dynamic>>> fetchSubcategories() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(categoryId)
            .collection('subcategories')
            .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'title': data['title'] ?? doc.id,
        'quizCount': data['quizCount'] ?? 0,
      };
    }).toList();
  }

  Color _getColor(String text) {
    final colors = [
      Colors.indigo,
      Colors.teal,
      Colors.deepPurple,
      Colors.orange,
      Colors.pink,
      Colors.green,
      Colors.cyan,
    ];
    return colors[text.hashCode % colors.length];
  }

  String _getEmoji(String title) {
    if (title.toLowerCase().contains('algo')) return '🧠';
    if (title.toLowerCase().contains('reseau')) return '🌐';
    if (title.toLowerCase().contains('base')) return '🗃️';
    if (title.toLowerCase().contains('web')) return '🌍';
    return '📘';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _getColor(categoryTitle);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // 🌟 Custom AppBar
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.9), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 12),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Text(
                    _getEmoji(categoryTitle),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    categoryTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // 📋 Contenu
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchSubcategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1D4ED8)),
                  );
                }

                if (snapshot.hasError) {
                  return Center(child: Text('❌ Erreur : ${snapshot.error}'));
                }

                final subcategories = snapshot.data ?? [];

                if (subcategories.isEmpty) {
                  return const Center(
                    child: Text('Aucune sous-catégorie trouvée.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: subcategories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final sub = subcategories[index];
                    final cardColor = _getColor(sub['title']);

                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap:
                          () => _showLevelSheet(
                            context,
                            sub['id'],
                            sub['title'],
                            cardColor,
                          ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 18,
                        ),
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: cardColor.withOpacity(0.35),
                          ),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: cardColor.withOpacity(0.25),
                              child: Icon(
                                Icons.quiz_outlined,
                                color: cardColor,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sub['title'],
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1E293B),
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${sub['quizCount']} quiz disponibles',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: cardColor,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLevelSheet(
    BuildContext context,
    String subId,
    String subTitle,
    Color color,
  ) {
    final levels = ['débutant', 'intermédiaire', 'expert'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '📚 Choisissez un niveau',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...levels.map((level) {
                return ListTile(
                  leading: Icon(Icons.star_border, color: color),
                  title: Text(level.toUpperCase()),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => QuizScreen(
                              categoryId: categoryId,
                              subcategoryId: subId,
                              level: level,
                            ),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}
