import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppDateFormat', () {
    test('static variable can be accessed', () {
      expect(AppDateFormat.pattern, equals('dd-MM-yyyy'));
    });
  });
}
