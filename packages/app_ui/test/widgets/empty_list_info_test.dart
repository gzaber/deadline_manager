import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('EmptyListInfo', () {
    testWidgets('is rendered', (tester) async {
      await tester.pumpTestWidget(
        builder: (_) => const EmptyListInfo(text: 'info'),
      );

      expect(find.byType(EmptyListInfo), findsOneWidget);
    });

    testWidgets('renders text and default icon', (tester) async {
      await tester.pumpTestWidget(
        builder: (_) => const EmptyListInfo(text: 'info'),
      );

      expect(find.text('info'), findsOneWidget);
      expect(find.byIcon(AppIcons.emptyListInfoIcon), findsOneWidget);
    });
  });
}
