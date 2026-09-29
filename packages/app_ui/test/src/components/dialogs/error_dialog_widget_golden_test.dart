import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('ErrorDialogWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      const ErrorDialogWidget(
        title: 'Ops! Algo deu errado',
        message: 'Não foi possível salvar.',
        buttonLabel: 'Entendido',
      ),
      'error_dialog_widget',
      size: const Size(400, 600),
    );
  });
}
