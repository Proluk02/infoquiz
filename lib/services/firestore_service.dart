// Service pour interagir avec la base de données Firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/category.dart';

class FirestoreService {
  // Instance Firestore utilisée pour toutes les opérations
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Récupère la liste des catégories en temps réel depuis Firestore
  Stream<List<Category>> getCategories() {
    print('📡 FirestoreService: demande des catégories');
    return _db.collection('categories').snapshots().map((snapshot) {
      print('📄 FirestoreService: ${snapshot.docs.length} documents reçus');
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

  // (À compléter) : Méthode pour sauvegarder l'historique des scores d'un utilisateur
  static saveScoreHistory({
    required String userId,
    required String categoryId,
    required String subcategoryId,
    required String level,
    required int score,
    required int total,
  }) {}
}
