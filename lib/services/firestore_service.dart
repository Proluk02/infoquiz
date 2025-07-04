import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Category>> getCategories() {
    print('📡 FirestoreService: demande des catégories');
    return _db.collection('categories').snapshots().map((snapshot) {
      print('📄 FirestoreService: ${snapshot.docs.length} documents reçus');
      final categories =
          snapshot.docs.map((doc) {
            final data = doc.data();
            print('➡️ Doc id=${doc.id} data=$data');
            return Category.fromFirestore(data, doc.id);
          }).toList();
      print('✅ FirestoreService: ${categories.length} catégories créées');
      return categories;
    });
  }
}
