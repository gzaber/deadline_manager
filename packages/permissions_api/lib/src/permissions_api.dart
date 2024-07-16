import 'models/models.dart';

abstract interface class PermissionsApi {
  Future<void> createPermission(Permission permission);
  Future<void> updatePermission(Permission permission);
  Future<void> deletePermission(String id);
  Future<List<Permission>> readPermissionsByCategoryId(String categoryId);
  Future<List<String>> readCategoryIdsByReceiver(String email);
  Stream<List<Permission>> observePermissionsByGiver(String email);
}
