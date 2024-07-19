import 'package:deadline_manager/app/app.dart';
import 'package:deadline_manager/ui/ui.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      providers: [EmailAuthProvider()],
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
  }
}
