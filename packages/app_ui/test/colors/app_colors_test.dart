import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppColors', () {
    test('static variable can be accessed', () {
      expect(AppColors.seedColor, equals(Colors.deepPurple));
    });
  });
}
