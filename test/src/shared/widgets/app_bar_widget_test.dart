import 'dart:async';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(PreferredSizeWidget appBar) {
  return MaterialApp(home: Scaffold(appBar: appBar));
}

Widget _pushedHarness(PreferredSizeWidget appBar) {
  return MaterialApp(
    home: Builder(
      builder: (context) {
        return Scaffold(
          body: ElevatedButton(
            onPressed: () {
              unawaited(
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => Scaffold(appBar: appBar),
                  ),
                ),
              );
            },
            child: const Text('push'),
          ),
        );
      },
    ),
  );
}

void main() {
  group('AppBarWidget', () {
    test('preferredSize height is 80', () {
      const appBar = AppBarWidget();

      expect(appBar.preferredSize.height, 80.0);
    });

    testWidgets('renders the title', (tester) async {
      await tester.pumpWidget(_harness(const AppBarWidget(title: 'Notas')));

      expect(find.text('Notas'), findsOneWidget);
    });

    testWidgets(
      'showBackButton omitted, cannot pop → hides the back button',
      (tester) async {
        await tester.pumpWidget(_harness(const AppBarWidget()));

        expect(find.byType(BackIconButtonWidget), findsNothing);
      },
    );

    testWidgets('showBackButton omitted, can pop → shows the back button', (
      tester,
    ) async {
      await tester.pumpWidget(_pushedHarness(const AppBarWidget()));

      await tester.tap(find.text('push'));
      await tester.pumpAndSettle();

      expect(find.byType(BackIconButtonWidget), findsOneWidget);
    });

    testWidgets('showBackButton: false overrides a poppable route', (
      tester,
    ) async {
      await tester.pumpWidget(
        _pushedHarness(const AppBarWidget(showBackButton: false)),
      );

      await tester.tap(find.text('push'));
      await tester.pumpAndSettle();

      expect(find.byType(BackIconButtonWidget), findsNothing);
    });

    testWidgets('showBackButton: true overrides a non-poppable route', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(const AppBarWidget(showBackButton: true)),
      );

      expect(find.byType(BackIconButtonWidget), findsOneWidget);
    });

    testWidgets('tapping the back button pops the route', (tester) async {
      await tester.pumpWidget(_pushedHarness(const AppBarWidget()));

      await tester.tap(find.text('push'));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(BackIconButtonWidget));
      await tester.pumpAndSettle();

      expect(find.text('push'), findsOneWidget);
    });

    testWidgets('renders the given actions', (tester) async {
      await tester.pumpWidget(
        _harness(
          const AppBarWidget(
            actions: [
              Icon(Icons.search),
              Icon(Icons.more_vert),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.byIcon(Icons.more_vert), findsOneWidget);
    });

    testWidgets('backgroundColor defaults to colorScheme.surface', (
      tester,
    ) async {
      await tester.pumpWidget(_harness(const AppBarWidget()));

      final context = tester.element(find.byType(AppBar));
      final colorScheme = Theme.of(context).colorScheme;

      final appBar = tester.widget<AppBar>(find.byType(AppBar));

      expect(appBar.backgroundColor, colorScheme.surface);
    });

    testWidgets('backgroundColor override is applied', (tester) async {
      await tester.pumpWidget(
        _harness(const AppBarWidget(backgroundColor: Colors.amber)),
      );

      final appBar = tester.widget<AppBar>(find.byType(AppBar));

      expect(appBar.backgroundColor, Colors.amber);
    });
  });
}
