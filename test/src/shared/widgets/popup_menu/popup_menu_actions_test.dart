import 'package:academic_planner/src/shared/widgets/popup_menu/popup_menu_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(List<PopupMenuEntry<void>> Function() itemBuilder) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: PopupMenuButton<void>(itemBuilder: (_) => itemBuilder()),
      ),
    ),
  );
}

void main() {
  group('PopupMenuActions', () {
    testWidgets('edit → renders icon, label and calls onTap on selection', (
      tester,
    ) async {
      var calls = 0;

      await tester.pumpWidget(
        _harness(() => [PopupMenuActions.edit(onTap: () => calls++)]),
      );

      await tester.tap(find.byType(PopupMenuButton<void>));
      await tester.pumpAndSettle();

      expect(find.text('Editar'), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);

      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();

      expect(calls, 1);
    });

    testWidgets(
      'delete → renders icon, label with the given color and calls onTap',
      (tester) async {
        var calls = 0;

        await tester.pumpWidget(
          _harness(
            () => [
              PopupMenuActions.delete(
                onTap: () => calls++,
                color: Colors.red,
              ),
            ],
          ),
        );

        await tester.tap(find.byType(PopupMenuButton<void>));
        await tester.pumpAndSettle();

        expect(find.text('Excluir'), findsOneWidget);
        expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);

        final icon = tester.widget<Icon>(
          find.byIcon(Icons.delete_outline_rounded),
        );
        expect(icon.color, Colors.red);

        await tester.tap(find.text('Excluir'));
        await tester.pumpAndSettle();

        expect(calls, 1);
      },
    );
  });
}
