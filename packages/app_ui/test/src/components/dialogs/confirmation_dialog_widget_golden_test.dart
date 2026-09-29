import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('ConfirmationDialogWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      ConfirmationDialogWidget(
        icon: Icons.logout_rounded,
        title: 'Sair da conta',
        message: 'Você precisará entrar novamente.',
        confirmLabel: 'Sair',
        cancelLabel: 'Cancelar',
        confirmStyle: AppButtonStyle.destructiveSolid,
        onConfirm: () {},
      ),
      'confirmation_dialog_widget',
      size: const Size(400, 600),
    );
  });
}
