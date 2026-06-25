import 'package:academic_planner/src/shared/widgets/modal_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

Widget _showHarness(Future<void> Function(BuildContext context) onPressed) {
  return MaterialApp(
    home: Scaffold(
      body: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () => onPressed(context),
            child: const Text('trigger'),
          );
        },
      ),
    ),
  );
}

void main() {
  group('ModalBottomSheetWidget', () {
    testWidgets('renders the title and the child', (tester) async {
      await tester.pumpWidget(
        _harness(
          const ModalBottomSheetWidget(
            title: 'Filtros',
            child: Text('conteúdo'),
          ),
        ),
      );

      expect(find.text('Filtros'), findsOneWidget);
      expect(find.text('conteúdo'), findsOneWidget);
    });

    testWidgets('title omitted → renders only the child', (tester) async {
      await tester.pumpWidget(
        _harness(const ModalBottomSheetWidget(child: Text('conteúdo'))),
      );

      expect(find.text('conteúdo'), findsOneWidget);
    });

    testWidgets('show() opens a bottom sheet with the title and child', (
      tester,
    ) async {
      await tester.pumpWidget(
        _showHarness((context) {
          return ModalBottomSheetWidget.show<void>(
            context: context,
            title: 'Filtros',
            child: const Text('conteúdo'),
          );
        }),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Filtros'), findsOneWidget);
      expect(find.text('conteúdo'), findsOneWidget);
    });

    testWidgets('resolves with the value passed to Navigator.pop', (
      tester,
    ) async {
      String? result;

      await tester.pumpWidget(
        _showHarness((context) async {
          result = await ModalBottomSheetWidget.show<String>(
            context: context,
            child: Builder(
              builder: (sheetContext) {
                return ElevatedButton(
                  onPressed: () => Navigator.pop(sheetContext, 'picked'),
                  child: const Text('pick'),
                );
              },
            ),
          );
        }),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('pick'));
      await tester.pumpAndSettle();

      expect(result, 'picked');
    });
  });
}
