import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('FailureSnackBar', () {
    testWidgets('snack bar is rendered', (tester) async {
      await tester.pumpTestWidget(
        builder: (context) => IconButton(
          onPressed: () => FailureSnackBar.show(context: context, text: 'text'),
          icon: const Icon(Icons.check),
        ),
      );

      await tester.tap(find.byIcon(Icons.check));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('renders snack bar content text', (tester) async {
      await tester.pumpTestWidget(
        builder: (context) => IconButton(
          onPressed: () => FailureSnackBar.show(context: context, text: 'text'),
          icon: const Icon(Icons.check),
        ),
      );

      await tester.tap(find.byIcon(Icons.check));
      await tester.pump();

      expect(find.text('text'), findsOneWidget);
    });
  });
}
