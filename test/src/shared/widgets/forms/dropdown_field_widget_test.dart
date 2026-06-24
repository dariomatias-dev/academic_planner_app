import 'package:academic_planner/src/shared/widgets/forms/dropdown_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const List<DropdownMenuItem<String>> _items = [
  DropdownMenuItem(value: 'item1', child: Text('Item 1')),
  DropdownMenuItem(value: 'item2', child: Text('Item 2')),
  DropdownMenuItem(value: 'item3', child: Text('Item 3')),
];

Widget _harness(Widget child, {GlobalKey<FormState>? formKey}) {
  return MaterialApp(
    home: Scaffold(
      body: formKey != null ? Form(key: formKey, child: child) : child,
    ),
  );
}

void main() {
  group('DropdownFieldWidget', () {
    testWidgets('no value → shows the hint', (tester) async {
      await tester.pumpWidget(
        _harness(
          DropdownFieldWidget<String>(
            items: _items,
            hint: 'Selecione um item',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Selecione um item'), findsOneWidget);
    });

    testWidgets('value set → shows the matching item label', (tester) async {
      await tester.pumpWidget(
        _harness(
          DropdownFieldWidget<String>(
            items: _items,
            value: 'item2',
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('renders the prefix icon when provided', (tester) async {
      await tester.pumpWidget(
        _harness(
          DropdownFieldWidget<String>(
            items: _items,
            onChanged: (_) {},
            prefixIcon: const Icon(Icons.list),
          ),
        ),
      );

      expect(find.byIcon(Icons.list), findsOneWidget);
    });

    testWidgets('selecting an item calls onChanged with its value', (
      tester,
    ) async {
      String? selected;

      await tester.pumpWidget(
        _harness(
          DropdownFieldWidget<String>(
            items: _items,
            hint: 'Selecione um item',
            onChanged: (value) => selected = value,
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Item 2').last);
      await tester.pumpAndSettle();

      expect(selected, 'item2');
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('enabled false → does not open the menu on tap', (
      tester,
    ) async {
      var calls = 0;

      await tester.pumpWidget(
        _harness(
          DropdownFieldWidget<String>(
            items: _items,
            hint: 'Selecione um item',
            onChanged: (_) => calls++,
            enabled: false,
          ),
        ),
      );

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsNothing);
      expect(calls, 0);
    });

    testWidgets('onChanged null → field is disabled', (tester) async {
      await tester.pumpWidget(
        _harness(const DropdownFieldWidget<String>(items: _items)),
      );

      final field = tester.widget<DropdownButtonFormField<String>>(
        find.byType(DropdownButtonFormField<String>),
      );

      expect(field.onChanged, isNull);
    });

    testWidgets('validator runs on form validation and shows the error', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        _harness(
          formKey: formKey,
          DropdownFieldWidget<String>(
            items: _items,
            onChanged: (_) {},
            validator: (value) => value == null ? 'Campo obrigatório' : null,
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(find.text('Campo obrigatório'), findsOneWidget);
    });
  });
}
