import 'package:academic_planner/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:academic_planner/src/shared/widgets/nav_bar/nav_bar_widget.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'helpers/app_harness.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('first run', () {
    late AppHarness harness;

    tearDown(() => harness.dispose());

    testWidgets('a signed-in user lands on the home tab', (tester) async {
      harness = await AppHarness.create();

      await harness.launch(tester);

      expect(find.byType(NavBarWidget), findsOneWidget);
      for (final label in ['Início', 'Grade', 'Atividades', 'Ajustes']) {
        expect(
          find.descendant(
            of: find.byType(NavBarWidget),
            matching: find.text(label),
          ),
          findsOneWidget,
        );
      }
    });

    testWidgets('the schedule tab starts empty', (tester) async {
      harness = await AppHarness.create();
      await harness.launch(tester);

      await tester.tap(
        find.descendant(
          of: find.byType(NavBarWidget),
          matching: find.text('Grade'),
        ),
      );
      await harness.settle(tester);

      expect(find.byType(EmptyStateWidget), findsOneWidget);
    });

    testWidgets('a signed-out user is sent to the login screen', (
      tester,
    ) async {
      harness = await AppHarness.create(signedIn: false);

      await harness.launch(tester);

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(NavBarWidget), findsNothing);
    });
  });
}
