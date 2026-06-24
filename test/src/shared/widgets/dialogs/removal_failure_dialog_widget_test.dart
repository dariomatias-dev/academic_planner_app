import 'dart:async';

import 'package:academic_planner/src/shared/widgets/dialogs/removal_failure_dialog_widget.dart';
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
  group('RemovalFailureDialogWidget', () {
    testWidgets(
      'renders title and message, hides retry and error box by default',
      (tester) async {
        await tester.pumpWidget(
          _harness(
            (_) =>
                const RemovalFailureDialogWidget(message: 'Falha ao excluir'),
          ),
        );

        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        expect(find.text('Ops! Algo deu errado'), findsOneWidget);
        expect(find.text('Falha ao excluir'), findsOneWidget);
        expect(find.text('Tentar Novamente'), findsNothing);
        expect(find.text('Fechar'), findsOneWidget);
      },
    );

    testWidgets('errorMessage provided → renders the error box', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          (_) => const RemovalFailureDialogWidget(
            message: 'Falha ao excluir',
            errorMessage: 'Erro 500',
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Erro 500'), findsOneWidget);
    });

    testWidgets('onRetry provided → shows retry button and calls it on tap', (
      tester,
    ) async {
      var retryCalls = 0;

      await tester.pumpWidget(
        _harness(
          (_) => RemovalFailureDialogWidget(
            message: 'Falha ao excluir',
            onRetry: () => retryCalls++,
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tentar Novamente'));
      await tester.pumpAndSettle();

      expect(retryCalls, 1);
      expect(find.text('Falha ao excluir'), findsNothing);
    });

    testWidgets('tap "Fechar" closes the dialog', (tester) async {
      await tester.pumpWidget(
        _harness(
          (_) =>
              const RemovalFailureDialogWidget(message: 'Falha ao excluir'),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();

      expect(find.text('Falha ao excluir'), findsNothing);
    });
  });
}
