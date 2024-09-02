import 'package:deadline_manager/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NavDestinations', () {
    group('getDestinations', () {
      testWidgets('returns list of destinations', (tester) async {
        late List<Destination> destinations;
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: Builder(builder: (context) {
              destinations = NavDestinations.getDestinations(context);
              return Container();
            }),
          ),
        );

        expect(destinations, isNotEmpty);
      });
    });
  });
}
