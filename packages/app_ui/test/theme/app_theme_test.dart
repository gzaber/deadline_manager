import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test('static variable can be accessed', () {
      expect(AppTheme.theme.useMaterial3, equals(true));
    });
  });
}
