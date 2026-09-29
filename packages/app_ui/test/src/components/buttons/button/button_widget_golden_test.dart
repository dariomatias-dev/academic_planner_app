import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/expect_golden.dart';

void main() {
  testWidgets('ButtonWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            for (final style in AppButtonStyle.values)
              ButtonWidget(
                label: style.name,
                icon: Icons.add,
                style: style,
                isFullWidth: true,
                height: 48,
                onPressed: () {},
              ),
            const ButtonWidget(
              label: 'disabled',
              isFullWidth: true,
              height: 48,
              onPressed: null,
            ),
          ],
        ),
      ),
      'button_widget',
      size: const Size(400, 600),
    );
  });
}
