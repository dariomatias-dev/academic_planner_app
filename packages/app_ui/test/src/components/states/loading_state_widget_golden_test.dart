import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/expect_golden.dart';

void main() {
  testWidgets('LoadingStateWidget matches the goldens', (tester) async {
    await expectGolden(
      tester,
      const LoadingStateWidget(message: 'Obtendo informações...'),
      'loading_state_widget',
      settle: false,
    );
  });
}
