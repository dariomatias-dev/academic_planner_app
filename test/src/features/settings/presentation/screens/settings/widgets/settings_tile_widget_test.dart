import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/settings_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(home: Scaffold(body: child));
}

void main() {
  group('SettingsTileWidget', () {
    testWidgets('renders the icon, the title and the default chevron', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          SettingsTileWidget(
            icon: Icons.person_outline_rounded,
            title: 'Editar Perfil',
            onTap: () {},
          ),
        ),
      );

      expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
      expect(find.text('Editar Perfil'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
    });

    testWidgets('trailing provided → replaces the default chevron', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          SettingsTileWidget(
            icon: Icons.palette_rounded,
            title: 'Tema do Aplicativo',
            onTap: () {},
            trailing: const Text('Claro'),
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_right_rounded), findsNothing);
      expect(find.text('Claro'), findsOneWidget);
    });

    testWidgets('tapping the tile calls onTap', (tester) async {
      var tapCalls = 0;

      await tester.pumpWidget(
        _harness(
          SettingsTileWidget(
            icon: Icons.person_outline_rounded,
            title: 'Editar Perfil',
            onTap: () => tapCalls++,
          ),
        ),
      );

      await tester.tap(find.text('Editar Perfil'));

      expect(tapCalls, 1);
    });
  });
}
