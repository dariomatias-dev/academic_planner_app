import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('EmptyStateWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      EmptyStateWidget(
        icon: Icons.inbox_outlined,
        title: 'Nada por aqui',
        description: 'Quando houver itens, eles aparecerão nesta lista.',
        actionLabel: 'Adicionar',
        onActionPressed: () {},
      ),
      'empty_state_widget',
      size: const Size(400, 700),
    );
  });
}
