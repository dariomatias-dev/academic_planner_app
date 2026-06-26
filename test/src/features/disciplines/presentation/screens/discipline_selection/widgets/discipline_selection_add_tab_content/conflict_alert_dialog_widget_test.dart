import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_selection/widgets/discipline_selection_add_tab_content/conflict_alert_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness() {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              await ConflictAlertDialogWidget.show(
                context,
                targetDisciplineName: 'Padrões de Projeto',
                conflictDetails: '• Sexta-feira às 13:20: Algoritmos',
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
  group('ConflictAlertDialogWidget', () {
    testWidgets('shows the title and the interpolated message', (
      tester,
    ) async {
      await tester.pumpWidget(_harness());

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Conflito de Horário'), findsOneWidget);
      expect(
        find.text(
          "Não foi possível adicionar 'Padrões de Projeto' devido aos "
          'seguintes conflitos:\n\n• Sexta-feira às 13:20: Algoritmos',
        ),
        findsOneWidget,
      );
    });

    testWidgets('tapping "Entendi" closes the dialog', (tester) async {
      await tester.pumpWidget(_harness());

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Entendi'));
      await tester.pumpAndSettle();

      expect(find.text('Conflito de Horário'), findsNothing);
    });
  });
}
