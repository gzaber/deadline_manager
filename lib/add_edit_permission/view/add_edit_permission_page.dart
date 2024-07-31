import 'package:app_ui/app_ui.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/add_edit_permission/add_edit_permission.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permissions_repository/permissions_repository.dart';

class AddEditPermissionPage extends StatelessWidget {
  const AddEditPermissionPage({
    super.key,
    this.permission,
  });

  final Permission? permission;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddEditPermissionCubit(
        categoriesRepository: context.read<CategoriesRepository>(),
        permissionsRepository: context.read<PermissionsRepository>(),
        user: context.read<AppCubit>().state.user,
        permission: permission,
      )..readCategories(),
      child: const AddEditPermissionView(),
    );
  }
}

class AddEditPermissionView extends StatelessWidget {
  const AddEditPermissionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.read<AddEditPermissionCubit>().state.initialPermission == null
              ? 'Create permission'
              : 'Update permission',
        ),
        actions: const [_SaveButton()],
      ),
      body: BlocConsumer<AddEditPermissionCubit, AddEditPermissionState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == AddEditPermissionStatus.saved) {
            context.pop();
          }
          if (state.status == AddEditPermissionStatus.failure) {
            FailureSnackBar.show(
              context: context,
              text: 'Something went wrong',
            );
          }
        },
        builder: (context, state) {
          if (state.status == AddEditPermissionStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(AppInsets.xLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReceiverField(),
                  DescriptionText(description: 'Select category to share:'),
                  _CategorySelector(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context) {
    final stateStatus =
        context.select((AddEditPermissionCubit cubit) => cubit.state.status);
    final stateEmptyReceiver = context
        .select((AddEditPermissionCubit cubit) => cubit.state.receiver.isEmpty);

    return IconButton(
      onPressed: () {
        stateEmptyReceiver
            ? null
            : context.read<AddEditPermissionCubit>().savePermission();
      },
      icon: stateStatus == AddEditPermissionStatus.loading
          ? const CircularProgressIndicator()
          : const Icon(AppIcons.saveIcon),
    );
  }
}

class _ReceiverField extends StatelessWidget {
  const _ReceiverField();

  @override
  Widget build(BuildContext context) {
    final stateReceiver =
        context.select((AddEditPermissionCubit cubit) => cubit.state.receiver);

    return TextFormField(
      initialValue: stateReceiver,
      onChanged: (value) {
        context.read<AddEditPermissionCubit>().onReceiverChanged(value);
      },
      decoration: const InputDecoration(labelText: 'User email'),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  const _CategorySelector();

  @override
  Widget build(BuildContext context) {
    final stateCategories = context
        .select((AddEditPermissionCubit cubit) => cubit.state.categories);
    final stateCategoryIds = context
        .select((AddEditPermissionCubit cubit) => cubit.state.categoryIds);

    return Wrap(
      spacing: AppInsets.medium,
      children: [
        ...stateCategories.map(
          (category) => ChoiceChip(
            onSelected: (_) {
              context
                  .read<AddEditPermissionCubit>()
                  .onCategoryChanged(category.id);
            },
            selected: stateCategoryIds.contains(category.id),
            label: Text(category.name),
          ),
        ),
      ],
    );
  }
}
