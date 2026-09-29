import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('ViewAllButtonWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      ViewAllButtonWidget(label: 'Ver Todas', onTap: () {}),
      'view_all_button_widget',
      size: const Size(300, 150),
    );
  });
}
