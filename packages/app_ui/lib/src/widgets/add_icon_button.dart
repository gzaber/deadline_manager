import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AddIconButton extends StatelessWidget {
  const AddIconButton({
    super.key,
    required this.onPressed,
  });

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: const Icon(AppIcons.addIcon),
    );
  }
}
