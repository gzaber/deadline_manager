import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/profile/profile.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permissions_repository/permissions_repository.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        authenticationRepository: context.read<AuthenticationRepository>(),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ProfileStatus.signOutFailure) {
            FailureSnackBar.show(
              context: context,
              text: 'Something went wrong',
            );
          }
          if (state.status == ProfileStatus.deleteUserFailure) {
            FailureSnackBar.show(
              context: context,
              text: 'Something went wrong - re-authenticate and try again',
            );
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppInsets.xLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    AppIcons.profileDestinationIcon,
                    size: AppInsets.xxLarge,
                  ),
                  const SizedBox(height: AppInsets.large),
                  Text(context.read<AppCubit>().state.user.email),
                  const SizedBox(height: AppInsets.xxLarge),
                  const _SignOutButton(),
                  const SizedBox(height: AppInsets.xxLarge),
                  const _DeleteAccountButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => context.read<ProfileCubit>().signOut(),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.signOutIcon),
          SizedBox(width: AppInsets.medium),
          Text('Sign out'),
        ],
      ),
    );
  }
}

class _DeleteAccountButton extends StatelessWidget {
  const _DeleteAccountButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        await ConfirmationAlertDialog.show(
          context: context,
          title: 'Delete',
          content: 'Delete account?',
          confirmButtonText: 'Yes',
          cancelButtonText: 'No',
        ).then(
          (value) {
            if (value == true) {
              context.read<ProfileCubit>().deleteUser();
            }
          },
        );
      },
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(AppIcons.deleteAccountIcon),
          SizedBox(width: AppInsets.medium),
          Text('Delete account'),
        ],
      ),
    );
  }
}
