class Category {
  final String id;
  final String title;
  final int? subcategoriesCount;

  Category({required this.id, required this.title, this.subcategoriesCount});

  factory Category.fromFirestore(Map<String, dynamic> data, String id) {
    return Category(
      id: id,
      title: data['title'] ?? id,
      subcategoriesCount: data['subcategoriesCount'],
    );
  }
}
