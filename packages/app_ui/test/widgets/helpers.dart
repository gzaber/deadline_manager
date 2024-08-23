import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpTestWidget({required WidgetBuilder builder}) async {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(builder: builder),
        ),
      ),
    );
  }
}

Future<bool?> showConfirmationAlertDialog(BuildContext context) {
  return ConfirmationAlertDialog.show(
      context: context,
      title: 'title',
      content: 'content',
      confirmButtonText: 'ok',
      cancelButtonText: 'cancel');
}

Widget renderUpdateDeleteMenuButton({
  Function()? onUpdateTap,
  Function()? onDeleteTap,
}) {
  return UpdateDeleteMenuButton(
    updateText: 'update',
    deleteText: 'delete',
    onUpdateTap: onUpdateTap ?? () {},
    onDeleteTap: onDeleteTap ?? () {},
  );
}
