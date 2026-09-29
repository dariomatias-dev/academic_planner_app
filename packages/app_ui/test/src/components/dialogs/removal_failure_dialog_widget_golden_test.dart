import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('RemovalFailureDialogWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      RemovalFailureDialogWidget(
        title: 'Ops! Algo deu errado',
        message: 'Não foi possível excluir.',
        errorMessage: 'database is locked',
        retryLabel: 'Tentar Novamente',
        closeLabel: 'Fechar',
        onRetry: () {},
      ),
      'removal_failure_dialog_widget',
      size: const Size(400, 700),
    );
  });
}
