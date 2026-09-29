import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('IconButtonWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          for (final style in IconButtonStyle.values)
            IconButtonWidget(
              icon: Icons.favorite_border_rounded,
              style: style,
              onPressed: () {},
            ),
          const IconButtonWidget(
            icon: Icons.favorite_border_rounded,
            onPressed: null,
          ),
        ],
      ),
      'icon_button_widget',
      size: const Size(400, 150),
    );
  });
}
