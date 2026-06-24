import 'dart:async';

import 'package:academic_planner/src/shared/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BackIconButtonWidget', () {
    testWidgets('renders the chevron_left_rounded icon at size 28', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: BackIconButtonWidget(onPressed: () {})),
        ),
      );

      final icon = tester.widget<Icon>(
        find.byIcon(Icons.chevron_left_rounded),
      );
      expect(icon.size, 28.0);
    });

    testWidgets('onPressed provided → tap calls it instead of popping', (
      tester,
    ) async {
      var calls = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BackIconButtonWidget(onPressed: () => calls++),
          ),
        ),
      );

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(calls, 1);
    });

    testWidgets('onPressed omitted → tap pops the current route', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    unawaited(
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              const Scaffold(body: BackIconButtonWidget()),
                        ),
                      ),
                    );
                  },
                  child: const Text('push'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('push'));
      await tester.pumpAndSettle();

      expect(find.byType(BackIconButtonWidget), findsOneWidget);

      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(find.byType(BackIconButtonWidget), findsNothing);
      expect(find.text('push'), findsOneWidget);
    });
  });
}
