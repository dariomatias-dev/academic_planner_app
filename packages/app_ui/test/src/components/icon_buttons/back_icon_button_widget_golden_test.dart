import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('BackIconButtonWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      const BackIconButtonWidget(),
      'back_icon_button_widget',
      size: const Size(200, 150),
    );
  });
}
