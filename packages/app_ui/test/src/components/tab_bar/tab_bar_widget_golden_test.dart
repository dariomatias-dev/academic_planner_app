import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('TabBarWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      DefaultTabController(
        length: 3,
        child: Builder(
          builder: (context) {
            return SizedBox(
              width: 400,
              child: TabBarWidget(
                controller: DefaultTabController.of(context),
                tabs: const [
                  Tab(text: 'Resumo'),
                  Tab(text: 'Tarefas'),
                  Tab(text: 'Notas'),
                ],
              ),
            );
          },
        ),
      ),
      'tab_bar_widget',
      size: const Size(400, 150),
    );
  });
}
