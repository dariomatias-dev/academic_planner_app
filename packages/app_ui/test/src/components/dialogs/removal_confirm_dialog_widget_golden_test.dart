import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('RemovalConfirmDialogWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      RemovalConfirmDialogWidget(
        title: 'Excluir atividade?',
        message: 'Essa ação não pode ser desfeita.',
        cancelLabel: 'Cancelar',
        confirmLabel: 'Excluir',
        onConfirm: () async {},
      ),
      'removal_confirm_dialog_widget',
      size: const Size(400, 600),
    );
  });
}
