import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permissions_api/permissions_api.dart';

class FirestorePermissionsApi implements PermissionsApi {
  FirestorePermissionsApi({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance {
    _permissionsRef = _firestore.collection(_permissionsPath);
  }

  final FirebaseFirestore _firestore;
  late final CollectionReference _permissionsRef;

  static const String _permissionsPath = 'permissions';
  static const String _categoryIdsField = 'categoryIds';
  static const String _giverField = 'giver';
  static const String _receiverField = 'receiver';

  @override
  Future<void> createPermission(Permission permission) async =>
      await _permissionsRef.doc(permission.id).set(permission.toJson());

  @override
  Future<void> updatePermission(Permission permission) async =>
      await _permissionsRef.doc(permission.id).update(permission.toJson());

  @override
  Future<void> deletePermission(String id) async =>
      await _permissionsRef.doc(id).delete();

  @override
  Future<List<Permission>> readPermissionsByCategoryId(
          String categoryId) async =>
      await _permissionsRef
          .where(_categoryIdsField, arrayContains: categoryId)
          .get()
          .then((snapshot) => snapshot.docs
              .map(
                (doc) =>
                    Permission.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList());

  @override
  Future<List<String>> readCategoryIdsByReceiver(String email) async =>
      await _permissionsRef
          .where(_receiverField, isEqualTo: email)
          .get()
          .then(((snapshot) => snapshot.docs
              .map(
                (doc) => Permission.fromJson(doc.data() as Map<String, dynamic>)
                    .categoryIds,
              )
              .expand((id) => id)
              .toList()));

  @override
  Future<List<Permission>> readPermissionsByGiver(String email) async =>
      _permissionsRef
          .where(_giverField, isEqualTo: email)
          .get()
          .then((snapshot) => snapshot.docs
              .map(
                (doc) =>
                    Permission.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList());

  @override
  Stream<List<Permission>> observePermissionsByGiver(String email) =>
      _permissionsRef
          .where(_giverField, isEqualTo: email)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                (doc) =>
                    Permission.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList());
}
