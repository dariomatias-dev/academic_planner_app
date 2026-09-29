import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('FloatingActionButtonWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      FloatingActionButtonWidget(icon: Icons.add, onPressed: () {}),
      'floating_action_button_widget',
      size: const Size(200, 200),
    );
  });
}
