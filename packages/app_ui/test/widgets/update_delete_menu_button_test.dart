import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('UpdateDeleteMenuButton', () {
    testWidgets('is rendered', (tester) async {
      await tester.pumpTestWidget(
        builder: (_) => renderUpdateDeleteMenuButton(),
      );

      expect(find.byType(UpdateDeleteMenuButton), findsOneWidget);
    });

    testWidgets('renders popup menu items when button is tapped',
        (tester) async {
      await tester.pumpTestWidget(
        builder: (_) => renderUpdateDeleteMenuButton(),
      );

      await tester.tap(find.byType(UpdateDeleteMenuButton));
      await tester.pumpAndSettle();

      expect(find.byType(PopupMenuItem), findsNWidgets(2));
      expect(find.text('update'), findsOneWidget);
      expect(find.text('delete'), findsOneWidget);
    });

    testWidgets('invokes onUpdateTap function ', (tester) async {
      var isTapped = false;
      await tester.pumpTestWidget(
        builder: (_) => renderUpdateDeleteMenuButton(
          onUpdateTap: () {
            isTapped = true;
          },
        ),
      );

      await tester.tap(find.byType(UpdateDeleteMenuButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('update'));

      expect(isTapped, isTrue);
    });

    testWidgets('invokes onDeleteTap function ', (tester) async {
      var isTapped = false;
      await tester.pumpTestWidget(
        builder: (_) => renderUpdateDeleteMenuButton(
          onDeleteTap: () {
            isTapped = true;
          },
        ),
      );

      await tester.tap(find.byType(UpdateDeleteMenuButton));
      await tester.pumpAndSettle();
      await tester.tap(find.text('delete'));

      expect(isTapped, isTrue);
    });
  });
}
