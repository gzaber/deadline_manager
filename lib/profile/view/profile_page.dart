import 'package:app_ui/app_ui.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:categories_repository/categories_repository.dart';
import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/profile/profile.dart';
import 'package:deadlines_repository/deadlines_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
        title: Text(AppLocalizations.of(context)!.profileTitle),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == ProfileStatus.signOutFailure) {
            FailureSnackBar.show(
              context: context,
              text: AppLocalizations.of(context)!.failureMessage,
            );
          }
          if (state.status == ProfileStatus.deleteUserFailure) {
            FailureSnackBar.show(
              context: context,
              text: AppLocalizations.of(context)!.deleteAccountFailureMessage,
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
                  const SizedBox(height: AppInsets.medium),
                  Text(state.user.email),
                  const SizedBox(height: AppInsets.xxLarge),
                  const _SignOutButton(),
                  const SizedBox(height: AppInsets.xLarge),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(AppIcons.signOutIcon),
          const SizedBox(width: AppInsets.medium),
          Text(AppLocalizations.of(context)!.profileSignOutButtonText),
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
          title: AppLocalizations.of(context)!.dialogDeleteTitle,
          content: AppLocalizations.of(context)!.dialogDeleteAccountContent,
          confirmButtonText:
              AppLocalizations.of(context)!.dialogConfirmButtonText,
          cancelButtonText:
              AppLocalizations.of(context)!.dialogCancelButtonText,
        ).then(
          (value) {
            if (value == true && context.mounted) {
              context.read<ProfileCubit>().deleteUser();
            }
          },
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(AppIcons.deleteAccountIcon),
          const SizedBox(width: AppInsets.medium),
          Text(AppLocalizations.of(context)!.profileDeleteAccountButtonText),
        ],
      ),
    );
  }
}
