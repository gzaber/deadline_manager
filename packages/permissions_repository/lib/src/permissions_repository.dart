import 'package:permissions_api/permissions_api.dart';

class PermissionsRepository {
  const PermissionsRepository({
    required PermissionsApi permissionsApi,
  }) : _permissionsApi = permissionsApi;

  final PermissionsApi _permissionsApi;

  Future<void> createPermission(Permission permission) async =>
      await _permissionsApi.createPermission(permission);

  Future<void> updatePermission(Permission permission) async =>
      await _permissionsApi.updatePermission(permission);

  Future<void> deletePermission(String id) async =>
      await _permissionsApi.deletePermission(id);

  Future<List<Permission>> readPermissionsByCategoryId(
          String categoryId) async =>
      await _permissionsApi.readPermissionsByCategoryId(categoryId);

  Future<List<String>> readCategoryIdsByReceiver(String email) async =>
      await _permissionsApi.readCategoryIdsByReceiver(email);

  Future<List<Permission>> readPermissionsByGiver(String email) =>
      _permissionsApi.readPermissionsByGiver(email);

  Stream<List<Permission>> observePermissionsByGiver(String email) =>
      _permissionsApi.observePermissionsByGiver(email);
}
