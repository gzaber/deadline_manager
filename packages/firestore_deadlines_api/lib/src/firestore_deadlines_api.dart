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

  static const String _idField = 'id';
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
  Future<Deadline> readDeadline(String id) async => await _deadlinesRef
      .doc(id)
      .get()
      .then((snapshot) => Deadline.fromJson(snapshot as Map<String, dynamic>));

  @override
  Stream<List<Deadline>> observeDeadlinesByCategory(String categoryId) =>
      _deadlinesRef
          .where(_idField, isEqualTo: categoryId)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                (doc) => Deadline.fromJson(doc as Map<String, dynamic>),
              )
              .toList());
}
