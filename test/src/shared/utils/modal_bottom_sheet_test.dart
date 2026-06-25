import 'package:academic_planner/src/shared/utils/modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Future<void> Function(BuildContext context) onPressed) {
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
  group('ModalBottomSheet.show', () {
    testWidgets('renders the given child', (tester) async {
      await tester.pumpWidget(
        _harness((context) async {
          await ModalBottomSheet.show<void>(
            context: context,
            child: const Text('sheet content'),
          );
        }),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      expect(find.text('sheet content'), findsOneWidget);
    });

    testWidgets('wraps the content in a top-rounded surface', (tester) async {
      await tester.pumpWidget(
        _harness((context) async {
          await ModalBottomSheet.show<void>(
            context: context,
            child: const Text('sheet content'),
          );
        }),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Material &&
              widget.clipBehavior == Clip.antiAlias &&
              widget.borderRadius ==
                  const BorderRadius.vertical(top: Radius.circular(32.0)),
        ),
        findsOneWidget,
      );
    });

    testWidgets('caps the sheet height at 85% of the screen', (tester) async {
      await tester.pumpWidget(
        _harness((context) async {
          await ModalBottomSheet.show<void>(
            context: context,
            child: const Text('sheet content'),
          );
        }),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;

      final constrainedBox = tester.widget<ConstrainedBox>(
        find
            .ancestor(
              of: find.text('sheet content'),
              matching: find.byType(ConstrainedBox),
            )
            .first,
      );

      expect(constrainedBox.constraints.maxHeight, screenHeight * 0.85);
    });

    testWidgets('does not extend the content under the bottom system UI', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness((context) async {
          await ModalBottomSheet.show<void>(
            context: context,
            child: const Text('sheet content'),
          );
        }),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      final safeArea = tester.widget<SafeArea>(
        find.ancestor(
          of: find.text('sheet content'),
          matching: find.byType(SafeArea),
        ),
      );

      expect(safeArea.top, isFalse);
      expect(safeArea.bottom, isTrue);
    });

    testWidgets('resolves with the value passed to Navigator.pop', (
      tester,
    ) async {
      String? result;

      await tester.pumpWidget(
        _harness((context) async {
          result = await ModalBottomSheet.show<String>(
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
