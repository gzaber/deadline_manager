import 'package:app_ui/app_ui.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/profile/profile.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permissions_repository/permissions_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        categoriesRepository: context.read<CategoriesRepository>(),
        deadlinesRepository: context.read<DeadlinesRepository>(),
        permissionsRepository: context.read<PermissionsRepository>(),
        user: context.read<AppCubit>().state.user,
      ),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == ProfileStatus.failure) {
          FailureSnackBar.show(
            context: context,
            text: 'Something went wrong',
          );
        }
      },
      builder: (context, state) {
        if (state.status == ProfileStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ProfileScreen(
          providers: [EmailAuthProvider()],
          actions: [
            AccountDeletedAction(
              (_, user) => context
                  .read<ProfileCubit>()
                  .deleteUserOwnership(user.email ?? ''),
            ),
          ],
          appBar: AppBar(
            title: const Text('Profile'),
            actions: [
              const Icon(AppIcons.profileDestinationIcon),
              const SizedBox(
                width: AppInsets.medium,
              ),
              Text(context.read<AppCubit>().state.user.email),
            ],
          ),
          showDeleteConfirmationDialog: true,
        );
      },
    );
  }
}
