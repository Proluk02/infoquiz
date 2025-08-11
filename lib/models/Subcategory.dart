// Modèle représentant une sous-catégorie de quiz
class Subcategory {
  // Identifiant unique de la sous-catégorie
  final String id;
  // Titre de la sous-catégorie (ex : Algèbre)
  final String title;

  // Constructeur de la classe
  Subcategory({required this.id, required this.title});

  // Méthode utilitaire pour créer une sous-catégorie à partir des données Firestore
  factory Subcategory.fromFirestore(Map<String, dynamic> data, String id) {
    return Subcategory(id: id, title: data['title'] ?? id);
  }
}
