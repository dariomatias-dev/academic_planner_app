import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/settings_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SettingsSectionWidget renders the upper-cased title and '
      'the children', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SettingsSectionWidget(
            title: 'minha conta',
            children: [Text('item 1'), Text('item 2')],
          ),
        ),
      ),
    );

    expect(find.text('MINHA CONTA'), findsOneWidget);
    expect(find.text('item 1'), findsOneWidget);
    expect(find.text('item 2'), findsOneWidget);
  });
}
