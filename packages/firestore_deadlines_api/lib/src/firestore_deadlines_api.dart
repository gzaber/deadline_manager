import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deadlines_api/deadlines_api.dart';

class FirestoreDeadlinesApi implements DeadlinesApi {
  FirestoreDeadlinesApi({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance {
    _deadlinesRef = _firestore.collection(_deadlinesCollection);
  }

  final FirebaseFirestore _firestore;
  late final CollectionReference _deadlinesRef;

  static const String _categoryIdField = 'categoryId';
  static const String _deadlinesCollection = 'deadlines';

  @override
  Future<void> createDeadline(Deadline deadline) async =>
      await _deadlinesRef.add(deadline.toJson());

  @override
  Future<void> updateDeadline(Deadline deadline) async =>
      await _deadlinesRef.doc(deadline.id).update(deadline.toJson());

  @override
  Future<void> deleteDeadline(String id) async =>
      await _deadlinesRef.doc(id).delete();

  @override
  Future<void> deleteDeadlinesByCategoryId(String categoryId) async =>
      await _deadlinesRef
          .where(_categoryIdField, isEqualTo: categoryId)
          .get()
          .then((querySnapshot) async {
        for (var docSnapshot in querySnapshot.docs) {
          await _deadlinesRef.doc(docSnapshot.id).delete();
        }
      });

  @override
  Future<Deadline> readDeadline(String id) async => await _deadlinesRef
      .doc(id)
      .get()
      .then((snapshot) => Deadline.fromJson(snapshot as Map<String, dynamic>));

  @override
  Stream<List<Deadline>> observeDeadlinesByCategory(String categoryId) =>
      _deadlinesRef
          .where(_categoryIdField, isEqualTo: categoryId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                (doc) => Deadline.fromJson(doc.data() as Map<String, dynamic>)
                    .copyWith(id: doc.id),
              )
              .toList());
}
