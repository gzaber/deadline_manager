import 'package:app_ui/app_ui.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/permissions/permissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_repository/permissions_repository.dart';

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PermissionsCubit(
        categoriesRepository: context.read<CategoriesRepository>(),
        permissionsRepository: context.read<PermissionsRepository>(),
        user: context.read<AppCubit>().state.user,
      )
        ..readCategories()
        ..subscribeToPermissions(),
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
        title: Text(AppLocalizations.of(context)!.permissionsTitle),
        actions: [
          AddIconButton(
            onPressed: () =>
                context.go(AppRouter.permissionsToAddEditPermissionsLocation),
          ),
        ],
      ),
      body: BlocConsumer<PermissionsCubit, PermissionsState>(
        listenWhen: (previous, current) =>
            previous.futureStatus != current.futureStatus ||
            previous.streamStatus != current.streamStatus,
        listener: (context, state) {
          if (state.futureStatus == PermissionsFutureStatus.failure ||
              state.streamStatus == PermissionsStreamStatus.failure) {
            FailureSnackBar.show(
              context: context,
              text: AppLocalizations.of(context)!.failureMessage,
            );
          }
        },
        builder: (context, state) {
          if (state.futureStatus == PermissionsFutureStatus.loading ||
              state.streamStatus == PermissionsStreamStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.streamStatus == PermissionsStreamStatus.success &&
              state.permissions.isEmpty) {
            return EmptyListInfo(
                text: AppLocalizations.of(context)!.emptyListMessage);
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
          ...context
              .read<PermissionsCubit>()
              .getPermissionCategories(permission)
              .map((category) => _PermissionsCategoryItem(category: category)),
        ],
      ),
      trailing: UpdateDeleteMenuButton(
        updateText: AppLocalizations.of(context)!.menuUpdateOption,
        deleteText: AppLocalizations.of(context)!.menuDeleteOption,
        onUpdateTap: () {
          context.go(
            AppRouter.permissionsToAddEditPermissionsLocation,
            extra: permission,
          );
        },
        onDeleteTap: () async {
          await ConfirmationAlertDialog.show(
            context: context,
            title: AppLocalizations.of(context)!.dialogDeleteTitle,
            content:
                AppLocalizations.of(context)!.dialogDeletePermissionContent,
            confirmButtonText:
                AppLocalizations.of(context)!.dialogConfirmButtonText,
            cancelButtonText:
                AppLocalizations.of(context)!.dialogCancelButtonText,
          ).then(
            (value) {
              if (value == true && context.mounted) {
                context
                    .read<PermissionsCubit>()
                    .deletePermission(permission.id);
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
