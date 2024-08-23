import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppInsets', () {
    test('static variable can be accessed', () {
      expect(AppInsets.small, equals(5.0));
    });
  });
}
