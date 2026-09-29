import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('DialogWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      DialogWidget(
        icon: Icons.info_outline_rounded,
        title: 'Título',
        message: 'Uma mensagem de exemplo para o diálogo.',
        actions: ButtonWidget(
          label: 'Entendido',
          isFullWidth: true,
          onPressed: () {},
        ),
      ),
      'dialog_widget',
      size: const Size(400, 600),
    );
  });
}
