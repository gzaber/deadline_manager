import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppIcons', () {
    test('static variable can be accessed', () {
      expect(AppIcons.iconFontFamily, equals('MaterialIcons'));
    });

    group('getDeadlineIcon', () {
      final currentDate = DateTime.now();
      test('returns icon with short expiration date color', () {
        final expirationDate = currentDate.add(const Duration(days: 5));
        final icon = AppIcons.getDeadlineIcon(currentDate, expirationDate);
        expect(icon.color, equals(AppColors.shortExpirationDateColor));
      });

      test('returns icon with medium expiration date color', () {
        final expirationDate = currentDate.add(const Duration(days: 15));
        final icon = AppIcons.getDeadlineIcon(currentDate, expirationDate);
        expect(icon.color, equals(AppColors.mediumExpirationDateColor));
      });

      test('returns icon with long expiration date color', () {
        final expirationDate = currentDate.add(const Duration(days: 55));
        final icon = AppIcons.getDeadlineIcon(currentDate, expirationDate);
        expect(icon.color, equals(AppColors.longExpirationDateColor));
      });
    });
  });
}
