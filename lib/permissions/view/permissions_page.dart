import 'package:categories_repository/categories_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_repository/permissions_repository.dart';

import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/permissions/permissions.dart';
import 'package:deadline_manager/ui/ui.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PermissionsCubit(
        categoriesRepository: context.read<CategoriesRepository>(),
        permissionsRepository: context.read<PermissionsRepository>(),
        user: context.read<AppCubit>().state.user,
      ),
      child: const PermissionsView(),
    );
  }
}

class PermissionsView extends StatelessWidget {
  const PermissionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permissions'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(AppRouter.permissionsToAddEditPermissionsLocation);
        },
        child: const Icon(AppIcons.fabIcon),
      ),
      body: BlocConsumer<PermissionsCubit, PermissionsState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == PermissionsStatus.failure) {
            FailureSnackBar.show(
              context: context,
              text: 'Something went wrong',
            );
          }
        },
        builder: (context, state) {
          if (state.status == PermissionsStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            separatorBuilder: (_, __) => const Divider(),
            itemCount: state.permissions.length,
            itemBuilder: (_, index) =>
                _PermissionItem(permission: state.permissions[index]),
          );
        },
      ),
    );
  }
}

class _PermissionItem extends StatelessWidget {
  const _PermissionItem({
    required this.permission,
  });

  final Permission permission;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(
        child: Icon(AppIcons.permissionItemIcon),
      ),
      title: Text(permission.receiver),
      subtitle: Wrap(
        children: [
          ...permission.categoryIds
              .map((id) => context
                  .read<PermissionsCubit>()
                  .state
                  .categories
                  .firstWhere((c) => c.id == id))
              .map(
                (category) => _PermissionsCategoryItem(category: category),
              ),
        ],
      ),
      trailing: UpdateDeleteMenuButton(
        updateText: 'Update',
        deleteText: 'Delete',
        onUpdateTap: () {
          context.go(
            AppRouter.permissionsToAddEditPermissionsLocation,
            extra: permission,
          );
        },
        onDeleteTap: () async {
          await ConfirmationAlertDialog.show(
            context: context,
            title: 'Delete',
            content: 'Delete this permission?',
            confirmButtonText: 'Yes',
            cancelButtonText: 'No',
          ).then(
            (value) {
              if (value == true) {
                context
                    .read<PermissionsCubit>()
                    .deletePermission(permission.id ?? '');
              }
            },
          );
        },
      ),
    );
  }
}

class _PermissionsCategoryItem extends StatelessWidget {
  const _PermissionsCategoryItem({
    required this.category,
  });

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppInsets.small),
      margin: const EdgeInsets.all(AppInsets.small),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.permissionsCategoryBorderColor),
        borderRadius: BorderRadius.circular(AppInsets.small),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            IconData(category.icon, fontFamily: AppIcons.iconFontFamily),
            size: AppInsets.large,
          ),
          const SizedBox(width: AppInsets.small),
          Text(category.name)
        ],
      ),
    );
  }
}
