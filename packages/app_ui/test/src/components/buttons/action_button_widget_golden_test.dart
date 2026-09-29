import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('ActionButtonWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ActionButtonWidget(
              icon: Icons.calendar_today_rounded,
              label: 'Agenda',
              style: AppButtonStyle.secondary,
              onPressed: () {},
            ),
          ],
        ),
      ),
      'action_button_widget',
      size: const Size(400, 200),
    );
  });
}
