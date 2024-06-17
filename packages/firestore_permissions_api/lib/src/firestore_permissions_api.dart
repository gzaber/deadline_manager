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
  static const String _giverField = 'giver';
  static const String _receiverField = 'receiver';

  @override
  Future<void> createPermission(Permission permission) async =>
      await _permissionsRef.add(permission.toJson());

  @override
  Future<void> updatePermission(Permission permission) async =>
      await _permissionsRef.doc(permission.id).update(permission.toJson());

  @override
  Future<void> deletePermission(String id) async =>
      await _permissionsRef.doc(id).delete();

  @override
  Stream<List<Permission>> observePermissionsByGiver(String email) =>
      _permissionsRef
          .where(_giverField, isEqualTo: email)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                (doc) => Permission.fromJson(doc.data() as Map<String, dynamic>)
                    .copyWith(id: doc.id),
              )
              .toList());

  @override
  Stream<List<Permission>> observePermissionsByReceiver(String email) =>
      _permissionsRef
          .where(_receiverField, isEqualTo: email)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map(
                (doc) => Permission.fromJson(doc.data() as Map<String, dynamic>)
                    .copyWith(id: doc.id),
              )
              .toList());
}
