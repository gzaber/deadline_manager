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
  Stream<Deadline> observeDeadlineById(String id) =>
      _deadlinesRef.doc(id).snapshots().map(
            (snapshot) =>
                Deadline.fromJson(snapshot.data() as Map<String, dynamic>)
                    .copyWith(id: snapshot.id),
          );

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

  @override
  Stream<List<Deadline>> observeDeadlinesByCategories(
          List<String> categoryIds) =>
      _deadlinesRef
          .where(_categoryIdField, whereIn: categoryIds)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                (doc) => Deadline.fromJson(doc.data() as Map<String, dynamic>)
                    .copyWith(id: doc.id),
              )
              .toList());
}
