// Modèle représentant une catégorie de quiz
class Category {
  // Identifiant unique de la catégorie
  final String id;
  // Titre de la catégorie (ex : Mathématiques)
  final String title;
  // Nombre de sous-catégories (optionnel)
  final int? subcategoriesCount;

  // Constructeur de la classe
  Category({required this.id, required this.title, this.subcategoriesCount});

  // Méthode utilitaire pour créer une catégorie à partir des données Firestore
  factory Category.fromFirestore(Map<String, dynamic> data, String id) {
    return Category(
      id: id,
      title: data['title'] ?? id,
      subcategoriesCount: data['subcategoriesCount'],
    );
  }
}
