import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('AddIconButton', () {
    testWidgets('is rendered', (tester) async {
      await tester.pumpTestWidget(
        builder: (_) => AddIconButton(onPressed: () {}),
      );

      expect(find.byType(AddIconButton), findsOneWidget);
    });

    testWidgets('renders default icon', (tester) async {
      await tester.pumpTestWidget(
        builder: (_) => AddIconButton(onPressed: () {}),
      );

      expect(find.byIcon(AppIcons.addIcon), findsOneWidget);
    });

    testWidgets('invokes onPressed function', (tester) async {
      var isPressed = false;
      await tester.pumpTestWidget(
        builder: (_) => AddIconButton(
          onPressed: () {
            isPressed = true;
          },
        ),
      );

      await tester.tap(find.byType(AddIconButton));
      expect(isPressed, isTrue);
    });
  });
}
