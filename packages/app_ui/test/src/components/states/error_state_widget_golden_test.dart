import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('ErrorStateWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      ErrorStateWidget(
        title: 'Ops! Algo deu errado',
        description: 'Não foi possível carregar os dados.',
        actionLabel: 'Tentar novamente',
        onActionPressed: () {},
      ),
      'error_state_widget',
      size: const Size(400, 700),
    );
  });
}
