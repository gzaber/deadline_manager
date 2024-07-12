import 'package:flutter/material.dart';

class ConfirmationAlertDialog extends StatelessWidget {
  const ConfirmationAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmButtonText,
    required this.cancelButtonText,
  });

  final String title;
  final String content;
  final String confirmButtonText;
  final String cancelButtonText;

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmButtonText,
    required String cancelButtonText,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConfirmationAlertDialog(
          title: title,
          content: content,
          confirmButtonText: confirmButtonText,
          cancelButtonText: cancelButtonText),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelButtonText),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmButtonText),
        ),
      ],
    );
  }
}
