import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/theme_selector_modal/theme_selector_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('ThemeSelectorModalWidget', () {
    testWidgets('renders the three mode options', (tester) async {
      await tester.pumpWidget(
        _harness(
          ThemeSelectorModalWidget(
            currentMode: ThemeMode.system,
            onModeSelected: (_) {},
          ),
        ),
      );

      expect(find.text('Escolha o tema'), findsOneWidget);
      expect(find.text('Modo Claro'), findsOneWidget);
      expect(find.text('Modo Escuro'), findsOneWidget);
      expect(find.text('Padrão do Sistema'), findsOneWidget);
    });

    testWidgets('marks the current mode as selected', (tester) async {
      await tester.pumpWidget(
        _harness(
          ThemeSelectorModalWidget(
            currentMode: ThemeMode.dark,
            onModeSelected: (_) {},
          ),
        ),
      );

      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    });

    testWidgets('tapping an option calls onModeSelected with that mode', (
      tester,
    ) async {
      ThemeMode? selected;

      await tester.pumpWidget(
        _harness(
          ThemeSelectorModalWidget(
            currentMode: ThemeMode.system,
            onModeSelected: (mode) => selected = mode,
          ),
        ),
      );

      await tester.tap(find.text('Modo Escuro'));

      expect(selected, ThemeMode.dark);
    });
  });
}
