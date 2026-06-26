import 'package:academic_planner/src/shared/widgets/popup_menu/popup_menu_action_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('PopupMenuActionWidget', () {
    testWidgets('renders the icon and label', (tester) async {
      await tester.pumpWidget(
        _harness(
          const PopupMenuActionWidget(
            icon: Icons.edit_outlined,
            label: 'Editar',
          ),
        ),
      );

      expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      expect(find.text('Editar'), findsOneWidget);
    });

    testWidgets('color null → falls back to colorScheme.onSurface', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const PopupMenuActionWidget(
            icon: Icons.edit_outlined,
            label: 'Editar',
          ),
        ),
      );

      final context = tester.element(find.text('Editar'));
      final onSurface = Theme.of(context).colorScheme.onSurface;

      final icon = tester.widget<Icon>(find.byIcon(Icons.edit_outlined));
      expect(icon.color, onSurface);

      final text = tester.widget<Text>(find.text('Editar'));
      expect(text.style?.color, onSurface);
    });

    testWidgets('color provided → uses it for both icon and label', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const PopupMenuActionWidget(
            icon: Icons.delete_outline_rounded,
            label: 'Excluir',
            color: Colors.red,
          ),
        ),
      );

      final icon = tester.widget<Icon>(
        find.byIcon(Icons.delete_outline_rounded),
      );
      expect(icon.color, Colors.red);

      final text = tester.widget<Text>(find.text('Excluir'));
      expect(text.style?.color, Colors.red);
    });
  });
}
