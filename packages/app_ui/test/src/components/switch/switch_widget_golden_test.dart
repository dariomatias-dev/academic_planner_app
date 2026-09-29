import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('SwitchWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          SwitchWidget(value: true, onChanged: (_) {}),
          SwitchWidget(value: false, onChanged: (_) {}),
        ],
      ),
      'switch_widget',
      size: const Size(300, 150),
    );
  });
}
