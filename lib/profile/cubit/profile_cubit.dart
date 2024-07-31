import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:permissions_repository/permissions_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required AuthenticationRepository authenticationRepository,
    required CategoriesRepository categoriesRepository,
    required DeadlinesRepository deadlinesRepository,
    required PermissionsRepository permissionsRepository,
    required User user,
  })  : _authenticationRepository = authenticationRepository,
        _categoriesRepository = categoriesRepository,
        _deadlinesRepository = deadlinesRepository,
        _permissionsRepository = permissionsRepository,
        super(ProfileState(user: user));

  final AuthenticationRepository _authenticationRepository;
  final CategoriesRepository _categoriesRepository;
  final DeadlinesRepository _deadlinesRepository;
  final PermissionsRepository _permissionsRepository;

  void deleteUser() async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final categories =
          await _categoriesRepository.readCategoriesByOwner(state.user.email);
      final categoryIds = categories.map((c) => c.id).toList();
      for (final id in categoryIds) {
        await _categoriesRepository.deleteCategory(id);
      }

      final deadlines =
          await _deadlinesRepository.readDeadlinesByCategoryIds(categoryIds);
      for (final deadline in deadlines) {
        await _deadlinesRepository.deleteDeadline(deadline.id);
      }

      final permissions =
          await _permissionsRepository.readPermissionsByGiver(state.user.email);
      for (final permission in permissions) {
        await _permissionsRepository.deletePermission(permission.id);
      }

      await _authenticationRepository.deleteUser();

      emit(state.copyWith(status: ProfileStatus.success));
    } catch (_) {
      emit(state.copyWith(status: ProfileStatus.deleteUserFailure));
    }
  }

  void signOut() async {
    try {
      await _authenticationRepository.signOut();
    } catch (_) {
      emit(state.copyWith(status: ProfileStatus.success));
    }
  }
}
