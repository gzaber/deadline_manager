import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('ConfirmationAlertDialog', () {
    testWidgets('is rendered', (tester) async {
      await tester.pumpTestWidget(
        builder: (context) => IconButton(
          onPressed: () => showConfirmationAlertDialog(context),
          icon: const Icon(Icons.check),
        ),
      );

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();

      expect(find.byType(ConfirmationAlertDialog), findsOneWidget);
    });

    testWidgets('pops when confirmation button is tapped', (tester) async {
      await tester.pumpTestWidget(
        builder: (context) => IconButton(
          onPressed: () => showConfirmationAlertDialog(context),
          icon: const Icon(Icons.check),
        ),
      );

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();
      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();

      expect(find.byType(ConfirmationAlertDialog), findsNothing);
    });

    testWidgets('pops when cancel button is tapped', (tester) async {
      await tester.pumpTestWidget(
        builder: (context) => IconButton(
          onPressed: () => showConfirmationAlertDialog(context),
          icon: const Icon(Icons.check),
        ),
      );

      await tester.tap(find.byIcon(Icons.check));
      await tester.pumpAndSettle();
      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(ConfirmationAlertDialog), findsNothing);
    });
  });
}
