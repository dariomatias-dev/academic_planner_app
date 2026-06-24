import 'dart:async';

import 'package:academic_planner/src/shared/widgets/dialogs/error_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget Function(BuildContext context) dialogBuilder) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () {
              unawaited(
                showDialog<void>(context: context, builder: dialogBuilder),
              );
            },
            child: const Text('open'),
          );
        },
      ),
    ),
  );
}

void main() {
  group('ErrorDialogWidget', () {
    testWidgets('renders default title, message and button label', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness((_) => const ErrorDialogWidget(message: 'Falha ao salvar')),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Ops! Algo deu errado'), findsOneWidget);
      expect(find.text('Falha ao salvar'), findsOneWidget);
      expect(find.text('Entendido'), findsOneWidget);
    });

    testWidgets('renders custom title and button label when provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          (_) => const ErrorDialogWidget(
            message: 'Falha ao salvar',
            title: 'Erro',
            buttonLabel: 'Fechar',
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Erro'), findsOneWidget);
      expect(find.text('Fechar'), findsOneWidget);
    });

    testWidgets('tap button → closes the dialog and calls onClose', (
      tester,
    ) async {
      var closeCalls = 0;

      await tester.pumpWidget(
        _harness(
          (_) => ErrorDialogWidget(
            message: 'Falha ao salvar',
            onClose: () => closeCalls++,
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Entendido'));
      await tester.pumpAndSettle();

      expect(closeCalls, 1);
      expect(find.text('Falha ao salvar'), findsNothing);
    });

    testWidgets('show() displays the dialog via showDialog', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    unawaited(
                      ErrorDialogWidget.show(context, message: 'Algo falhou'),
                    );
                  },
                  child: const Text('open'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Algo falhou'), findsOneWidget);
      expect(find.text('Ops! Algo deu errado'), findsOneWidget);
    });
  });
}
