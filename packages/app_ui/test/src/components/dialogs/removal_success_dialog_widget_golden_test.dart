import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('RemovalSuccessDialogWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      const RemovalSuccessDialogWidget(
        title: 'Atividade excluída',
        message: 'A atividade foi removida com sucesso.',
        buttonLabel: 'Entendido',
      ),
      'removal_success_dialog_widget',
      size: const Size(400, 600),
    );
  });
}
