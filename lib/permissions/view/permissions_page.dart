import 'package:deadline_manager/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_repository/permissions_repository.dart';

import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/permissions/permissions.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PermissionsCubit(
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
      leading: const Icon(AppIcons.permissionItemIcon),
      title: Text(permission.receiver),
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
