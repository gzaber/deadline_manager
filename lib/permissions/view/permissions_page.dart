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
        centerTitle: true,
        title: const Text('Permissions'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go(AppRouter.permissionsToAddEditPermissionsLocation);
        },
        child: const Icon(Icons.add),
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
          return ListView.builder(
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
      leading: const Icon(Icons.person),
      title: Text(permission.receiver),
      trailing: _PopupMenuButton(
        onUpdateTap: () {
          context.go(
            AppRouter.permissionsToAddEditPermissionsLocation,
            extra: permission,
          );
        },
        onDeleteTap: () async {
          return await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete'),
              content: const Text('Delete this permission?'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
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

class _PopupMenuButton extends StatelessWidget {
  const _PopupMenuButton({
    required this.onUpdateTap,
    required this.onDeleteTap,
  });

  final Function() onUpdateTap;
  final Function() onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (_) => [
        PopupMenuItem(onTap: onUpdateTap, child: const Text('Update')),
        PopupMenuItem(onTap: onDeleteTap, child: const Text('Delete')),
      ],
    );
  }
}
