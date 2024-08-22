import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deadlines_api/deadlines_api.dart';

class FirestoreDeadlinesApi implements DeadlinesApi {
  FirestoreDeadlinesApi({
    required FirebaseFirestore firestore,
  }) : _deadlinesRef = firestore.collection(_deadlinesPath);

  final CollectionReference _deadlinesRef;

  static const String _deadlinesPath = 'deadlines';
  static const String _categoryIdField = 'categoryId';

  @override
  Future<void> createDeadline(Deadline deadline) async =>
      await _deadlinesRef.doc(deadline.id).set(deadline.toJson());

  @override
  Future<void> updateDeadline(Deadline deadline) async =>
      await _deadlinesRef.doc(deadline.id).update(deadline.toJson());

  @override
  Future<void> deleteDeadline(String id) async =>
      await _deadlinesRef.doc(id).delete();

  @override
  Future<List<Deadline>> readDeadlinesByCategoryId(String categoryId) async =>
      await _deadlinesRef
          .where(_categoryIdField, isEqualTo: categoryId)
          .get()
          .then((snapshot) => snapshot.docs
              .map(
                (doc) => Deadline.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList());

  @override
  Future<List<Deadline>> readDeadlinesByCategoryIds(
          List<String> categoryIds) async =>
      await _deadlinesRef
          .where(_categoryIdField, whereIn: categoryIds)
          .get()
          .then((snapshot) => snapshot.docs
              .map(
                (doc) => Deadline.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList());

  @override
  Stream<List<Deadline>> observeDeadlinesByCategoryId(String categoryId) =>
      _deadlinesRef
          .where(_categoryIdField, isEqualTo: categoryId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                (doc) => Deadline.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList());
}
