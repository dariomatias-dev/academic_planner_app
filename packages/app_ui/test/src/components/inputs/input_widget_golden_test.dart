import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('InputWidget matches the goldens', (tester) async {
    final empty = TextEditingController();
    final filled = TextEditingController(text: 'Texto digitado');
    final locked = TextEditingController(text: 'Somente leitura');
    addTearDown(() {
      empty.dispose();
      filled.dispose();
      locked.dispose();
    });

    await expectGolden(
      tester,
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            InputWidget(
              controller: empty,
              hint: 'Digite algo',
              prefixIcon: const Icon(Icons.search_rounded),
            ),
            InputWidget(controller: filled, hint: 'Digite algo'),
            InputWidget(
              controller: locked,
              hint: 'Digite algo',
              style: InputStyle.secondary,
              readOnly: true,
            ),
          ],
        ),
      ),
      'input_widget',
    );
  });
}
