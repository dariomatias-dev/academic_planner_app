import 'dart:async';

import 'package:academic_planner/src/shared/widgets/link_opening_failure_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

Widget _showHarness() {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              unawaited(LinkOpeningFailureDialogWidget.show(context));
            },
            child: const Text('open'),
          );
        },
      ),
    ),
  );
}

void main() {
  group('LinkOpeningFailureDialogWidget', () {
    testWidgets('renders the title, message and icon', (tester) async {
      await tester.pumpWidget(
        _harness(const LinkOpeningFailureDialogWidget()),
      );

      expect(find.text('Não foi possível abrir'), findsOneWidget);
      expect(
        find.text(
          'Ocorreu um problema ao tentar abrir o documento no seu '
          'navegador. Por favor, tente novamente em instantes.',
        ),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.link_off_rounded), findsOneWidget);
      expect(find.text('Fechar'), findsOneWidget);
    });

    testWidgets('uses colorScheme.error as the icon color', (tester) async {
      await tester.pumpWidget(
        _harness(const LinkOpeningFailureDialogWidget()),
      );

      final context = tester.element(
        find.byType(LinkOpeningFailureDialogWidget),
      );
      final colorScheme = Theme.of(context).colorScheme;

      final icon = tester.widget<Icon>(find.byIcon(Icons.link_off_rounded));

      expect(icon.color, colorScheme.error);
    });

    testWidgets('show() opens the dialog', (tester) async {
      await tester.pumpWidget(_showHarness());

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Não foi possível abrir'), findsOneWidget);
    });

    testWidgets('tap "Fechar" closes the dialog', (tester) async {
      await tester.pumpWidget(_showHarness());

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();

      expect(find.text('Não foi possível abrir'), findsNothing);
    });
  });
}
