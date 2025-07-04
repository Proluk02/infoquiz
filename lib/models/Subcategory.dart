class Subcategory {
  final String id;
  final String title;

  Subcategory({required this.id, required this.title});

  factory Subcategory.fromFirestore(Map<String, dynamic> data, String id) {
    return Subcategory(id: id, title: data['title'] ?? id);
  }
}
