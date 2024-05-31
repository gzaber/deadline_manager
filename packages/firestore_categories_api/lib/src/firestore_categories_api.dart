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
  static const String _userEmailField = 'userEmail';
  static const String _authorizedUserEmailsField = 'authorizedUserEmails';

  @override
  Future<void> createCategory(Category category) async =>
      await _categoriesRef.add(category.toJson());

  @override
  Future<void> updateCategory(Category category) async =>
      await _categoriesRef.doc(category.id).update(category.toJson());

  @override
  Future<void> deleteCategory(String id) async =>
      await _categoriesRef.doc(id).delete();

  @override
  Future<Category> readCategory(String id) async => await _categoriesRef
      .doc(id)
      .get()
      .then((snapshot) => Category.fromJson(snapshot as Map<String, dynamic>));

  @override
  Stream<List<Category>> observeCategoriesByUserEmail(String email) =>
      _categoriesRef
          .where(_userEmailField, isEqualTo: email)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                (doc) => Category.fromJson(doc as Map<String, dynamic>),
              )
              .toList());

  @override
  Stream<List<Category>> observeCategoriesByAuthorizedUserEmail(String email) =>
      _categoriesRef
          .where(_authorizedUserEmailsField, arrayContains: email)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                (doc) => Category.fromJson(doc as Map<String, dynamic>),
              )
              .toList());
}
