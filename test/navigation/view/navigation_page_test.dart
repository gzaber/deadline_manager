import 'package:deadline_manager/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('NavigationPage', () {
    const firstPath = '/first';
    const secondPath = '/second';
    const firstTitle = 'first-title';
    const secondTitle = 'second-title';
    const mockDestinations = [
      Destination(
        label: 'first',
        icon: Icons.first_page,
        path: firstPath,
      ),
      Destination(
        label: 'second',
        icon: Icons.last_page,
        path: secondPath,
      ),
    ];

    getMockDestinations(BuildContext context) => mockDestinations;

    Widget createNavigationPage() {
      return MaterialApp.router(
        routerConfig: GoRouter(
          initialLocation: firstPath,
          routes: [
            ShellRoute(
              builder: (_, __, child) => NavigationPage(
                getDestinations: getMockDestinations,
                child: child,
              ),
              routes: [
                GoRoute(
                  path: firstPath,
                  builder: (_, __) => const Center(
                    child: Text(firstTitle),
                  ),
                ),
                GoRoute(
                  path: secondPath,
                  builder: (_, __) => const Center(
                    child: Text(secondTitle),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    group('mobile', () {
      testWidgets('renders navigation bar', (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1;

        await tester.pumpWidget(createNavigationPage());

        expect(find.byType(NavigationBar), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('renders first page as initial location', (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1;

        await tester.pumpWidget(createNavigationPage());

        expect(find.text(firstTitle), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('renders second page when selected', (tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1;

        await tester.pumpWidget(createNavigationPage());
        await tester.tap(find.byIcon(mockDestinations.last.icon));
        await tester.pumpAndSettle();

        expect(find.text(secondTitle), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('tablet', () {
      testWidgets('renders navigation rail', (tester) async {
        tester.view.physicalSize = const Size(700, 500);
        tester.view.devicePixelRatio = 1;

        await tester.pumpWidget(createNavigationPage());

        expect(find.byType(NavigationRail), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('renders first page as initial location', (tester) async {
        tester.view.physicalSize = const Size(700, 500);
        tester.view.devicePixelRatio = 1;

        await tester.pumpWidget(createNavigationPage());

        expect(find.text(firstTitle), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('renders second page when selected', (tester) async {
        tester.view.physicalSize = const Size(700, 500);
        tester.view.devicePixelRatio = 1;

        await tester.pumpWidget(createNavigationPage());
        await tester.tap(find.byIcon(mockDestinations.last.icon));
        await tester.pumpAndSettle();

        expect(find.text(secondTitle), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });

    group('desktop', () {
      testWidgets('renders navigation rail', (tester) async {
        tester.view.physicalSize = const Size(1000, 800);
        tester.view.devicePixelRatio = 1;

        await tester.pumpWidget(createNavigationPage());

        expect(find.byType(NavigationRail), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('renders first page as initial location', (tester) async {
        tester.view.physicalSize = const Size(1000, 800);
        tester.view.devicePixelRatio = 1;

        await tester.pumpWidget(createNavigationPage());

        expect(find.text(firstTitle), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      testWidgets('renders second page when selected', (tester) async {
        tester.view.physicalSize = const Size(1000, 800);
        tester.view.devicePixelRatio = 1;

        await tester.pumpWidget(createNavigationPage());
        await tester.tap(find.byIcon(mockDestinations.last.icon));
        await tester.pumpAndSettle();

        expect(find.text(secondTitle), findsOneWidget);

        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
    });
  });
}
