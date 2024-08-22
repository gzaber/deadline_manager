import 'package:categories_api/categories_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreCategoriesApi implements CategoriesApi {
  FirestoreCategoriesApi({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance {
    _categoriesRef = _firestore.collection(_categoriesCollection);
  }

  final FirebaseFirestore _firestore;
  late final CollectionReference _categoriesRef;

  static const String _categoriesCollection = 'categories';
  static const String _ownerField = 'owner';

  @override
  Future<void> createCategory(Category category) async =>
      await _categoriesRef.doc(category.id).set(category.toJson());

  @override
  Future<void> updateCategory(Category category) async =>
      await _categoriesRef.doc(category.id).update(category.toJson());

  @override
  Future<void> deleteCategory(String id) async =>
      await _categoriesRef.doc(id).delete();

  @override
  Future<Category> readCategoryById(String id) async =>
      await _categoriesRef.doc(id).get().then((snapshot) =>
          Category.fromJson(snapshot.data() as Map<String, dynamic>));

  @override
  Future<List<Category>> readCategoriesByOwner(String owner) async =>
      await _categoriesRef
          .where(_ownerField, isEqualTo: owner)
          .get()
          .then((snapshot) => snapshot.docs
              .map(
                (doc) => Category.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList());

  @override
  Stream<List<Category>> observeCategoriesByOwner(String owner) =>
      _categoriesRef.where(_ownerField, isEqualTo: owner).snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) =>
                    Category.fromJson(doc.data() as Map<String, dynamic>))
                .toList(),
          );
}
