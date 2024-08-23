import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppScreenSize', () {
    test('static variable can be accessed', () {
      expect(AppScreenSize.tabletBreakpoint, equals(600));
    });

    group('getSize', () {
      testWidgets('returns desktop screen size', (tester) async {
        late ScreenSize screenSize;
        tester.view.devicePixelRatio = 1.0;
        tester.view.physicalSize = const Size(1200, 800);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              screenSize = AppScreenSize.getSize(context);
              return Container();
            }),
          ),
        );

        expect(screenSize, equals(ScreenSize.desktop));
      });

      testWidgets('returns tablet screen size', (tester) async {
        late ScreenSize screenSize;
        tester.view.devicePixelRatio = 1.0;
        tester.view.physicalSize = const Size(700, 400);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              screenSize = AppScreenSize.getSize(context);
              return Container();
            }),
          ),
        );

        expect(screenSize, equals(ScreenSize.tablet));
      });

      testWidgets('returns mobile screen size', (tester) async {
        late ScreenSize screenSize;
        tester.view.devicePixelRatio = 1.0;
        tester.view.physicalSize = const Size(500, 800);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(builder: (context) {
              screenSize = AppScreenSize.getSize(context);
              return Container();
            }),
          ),
        );

        expect(screenSize, equals(ScreenSize.mobile));
      });
    });
  });
}
