import 'package:flutter/material.dart';

class UpdateDeleteMenuButton extends StatelessWidget {
  const UpdateDeleteMenuButton({
    super.key,
    required this.updateText,
    required this.deleteText,
    required this.onUpdateTap,
    required this.onDeleteTap,
  });

  final String updateText;
  final String deleteText;
  final Function() onUpdateTap;
  final Function() onDeleteTap;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (_) => [
        PopupMenuItem(
          onTap: onUpdateTap,
          child: Text(updateText),
        ),
        PopupMenuItem(
          onTap: onDeleteTap,
          child: Text(deleteText),
        ),
      ],
    );
  }
}
