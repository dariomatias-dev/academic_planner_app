import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('SelectableChipWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          SelectableChipWidget(
            label: 'Selecionado',
            isSelected: true,
            onTap: () {},
          ),
          SelectableChipWidget(label: 'Livre', isSelected: false, onTap: () {}),
        ],
      ),
      'selectable_chip_widget',
      size: const Size(400, 150),
    );
  });
}
