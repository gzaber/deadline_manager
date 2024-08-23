import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('DescriptionText', () {
    testWidgets('is rendered', (tester) async {
      await tester.pumpTestWidget(
        builder: (_) => const DescriptionText(description: 'description'),
      );

      expect(find.byType(DescriptionText), findsOneWidget);
    });

    testWidgets('renders description text', (tester) async {
      await tester.pumpTestWidget(
        builder: (_) => const DescriptionText(description: 'description'),
      );

      expect(find.text('description'), findsOneWidget);
    });
  });
}
