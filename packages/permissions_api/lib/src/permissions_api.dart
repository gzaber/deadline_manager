import 'models/models.dart';

abstract interface class PermissionsApi {
  Future<void> createPermission(Permission permission);
  Future<void> updatePermission(Permission permission);
  Future<void> deletePermission(String id);
  Stream<List<Permission>> observePermissionsByGiver(String email);
  Stream<List<Permission>> observePermissionsByReceiver(String email);
}
