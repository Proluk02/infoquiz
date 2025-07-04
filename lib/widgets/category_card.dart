import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infoquiz/models/category.dart';
import 'package:infoquiz/screens/subcategory_screen.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  static const List<List<Color>> _gradientColors = [
    [Color(0xFFA1C4FD), Color(0xFFC2E9FB)], // bleu clair pastel
    [Color(0xFFFBC7AA), Color(0xFFFBE8A6)], // pêche doux
    [Color(0xFFB5FFFC), Color(0xFF6BC1FF)], // cyan clair
    [Color(0xFFC6FFD7), Color(0xFFB5FFFC)], // vert d'eau pastel
    [Color(0xFFFFD3B4), Color(0xFFFFAAA6)], // corail doux
    [Color(0xFFD4FC79), Color(0xFF96E6A1)], // vert clair dégradé
    [Color(0xFFE0C3FC), Color(0xFF8EC5FC)], // violet clair dégradé
  ];

  List<Color> _getGradientColors(String title) {
    return _gradientColors[title.hashCode % _gradientColors.length];
  }

  IconData _getCategoryIcon(String title) {
    final keywords = title.toLowerCase();
    if (keywords.contains('math')) return Icons.calculate;
    if (keywords.contains('info') || keywords.contains('programmation'))
      return Icons.computer;
    if (keywords.contains('science')) return Icons.science;
    if (keywords.contains('geo')) return Icons.public;
    if (keywords.contains('histoire')) return Icons.menu_book;
    return Icons.school;
  }

  Future<bool> _hasSubcategories() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('categories')
            .doc(category.id)
            .collection('subcategories')
            .limit(1)
            .get();
    return snapshot.docs.isNotEmpty;
  }

  void _onTap(BuildContext context) async {
    final hasSubs = await _hasSubcategories();
    if (hasSubs) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => SubcategoryScreen(
                categoryId: category.id,
                categoryTitle: category.title,
              ),
        ),
      );
    } else {
      Navigator.pushNamed(
        context,
        '/quiz',
        arguments: {
          'categoryId': category.id,
          'subcategoryId': '',
          'level': 'débutant',
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gradientColors = _getGradientColors(category.title);
    final icon = _getCategoryIcon(category.title);

    // Texte en noir semi-transparent pour un bon contraste sur fond clair pastel
    final textColor = Colors.black.withOpacity(0.75);
    final iconColor = Colors.black.withOpacity(0.7);

    return GestureDetector(
      onTap: () => _onTap(context),
      child: SizedBox(
        width: 130, // Légèrement réduit pour compacité
        height: 130,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: gradientColors.last.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 28, color: iconColor),
              const SizedBox(height: 6),
              Text(
                category.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  height: 1.2,
                  shadows: [
                    Shadow(
                      color: Colors.white.withOpacity(0.6),
                      blurRadius: 2,
                      offset: const Offset(0.5, 0.5),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
