import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('PasswordInputWidget matches the goldens', (tester) async {
    final controller = TextEditingController(text: 'segredo123');
    addTearDown(controller.dispose);

    await expectGolden(
      tester,
      Padding(
        padding: const EdgeInsets.all(16),
        child: PasswordInputWidget(controller: controller),
      ),
      'password_input_widget',
      size: const Size(400, 200),
    );
  });
}
