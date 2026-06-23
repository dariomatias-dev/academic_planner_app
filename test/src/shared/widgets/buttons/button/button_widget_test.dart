import 'dart:async';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: Center(child: child)));
}

void main() {
  group('ButtonWidget', () {
    testWidgets('renders the label', (tester) async {
      await tester.pumpWidget(
        _harness(ButtonWidget(label: 'Salvar', onPressed: () {})),
      );

      expect(find.text('Salvar'), findsOneWidget);
    });

    testWidgets('renders leading and trailing icons when provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          ButtonWidget(
            label: 'Avançar',
            icon: Icons.add,
            trailingIcon: Icons.arrow_forward,
            onPressed: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('renders for every AppButtonStyle without throwing', (
      tester,
    ) async {
      for (final style in AppButtonStyle.values) {
        await tester.pumpWidget(
          _harness(
            ButtonWidget(label: 'Botão', style: style, onPressed: () {}),
          ),
        );

        expect(find.text('Botão'), findsOneWidget);
      }
    });

    testWidgets('tap calls onPressed', (tester) async {
      var calls = 0;

      await tester.pumpWidget(
        _harness(ButtonWidget(label: 'Salvar', onPressed: () => calls++)),
      );

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(calls, 1);
    });

    testWidgets('onPressed null → button is disabled', (tester) async {
      await tester.pumpWidget(
        _harness(const ButtonWidget(label: 'Salvar', onPressed: null)),
      );

      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );

      expect(button.onPressed, isNull);
    });

    testWidgets(
      'pending onPressed → shows loading indicator, hides label, '
      'disables button and ignores extra taps',
      (tester) async {
        final completer = Completer<void>();
        var calls = 0;

        await tester.pumpWidget(
          _harness(
            ButtonWidget(
              label: 'Salvar',
              onPressed: () {
                calls++;

                return completer.future;
              },
            ),
          ),
        );

        await tester.tap(find.text('Salvar'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Salvar'), findsNothing);

        final loadingButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(loadingButton.onPressed, isNull);

        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        expect(calls, 1);

        completer.complete();
        await tester.pumpAndSettle();

        expect(find.text('Salvar'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);

        final idleButton = tester.widget<ElevatedButton>(
          find.byType(ElevatedButton),
        );
        expect(idleButton.onPressed, isNotNull);
      },
    );
  });
}
