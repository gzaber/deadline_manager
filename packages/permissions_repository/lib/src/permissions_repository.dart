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

  Stream<List<Permission>> observePermissionsByGiver(String email) =>
      _permissionsApi.observePermissionsByGiver(email);

  Stream<List<Permission>> observePermissionsByReceiver(String email) =>
      _permissionsApi.observePermissionsByReceiver(email);
}
