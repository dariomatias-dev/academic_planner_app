import 'package:academic_planner/src/core/startup_failure_app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StartupFailureApp', () {
    testWidgets('renders the failure message', (tester) async {
      await tester.pumpWidget(StartupFailureApp(onRetry: () {}));

      expect(find.text('Não foi possível iniciar o app'), findsOneWidget);
    });

    testWidgets('tapping retry calls onRetry', (tester) async {
      var retryCalls = 0;

      await tester.pumpWidget(
        StartupFailureApp(onRetry: () => retryCalls++),
      );

      await tester.tap(find.text('Tentar novamente'));

      expect(retryCalls, 1);
    });
  });
}
