import 'package:academic_planner/firebase_options.dart';
import 'package:academic_planner/src/app_widget.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/database/app_database.dart';
import 'package:academic_planner/src/core/di/database_provider.dart';
import 'package:academic_planner/src/core/di/shared_preferences_provider.dart';
import 'package:academic_planner/src/core/seeds/seed_initializer.dart';
import 'package:academic_planner/src/core/shared_preferences_keys.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_card/activity_card_widget.dart';
import 'package:academic_planner/src/features/disciplines/presentation/widgets/discipline_card/discipline_card_item_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/nav_bar/nav_bar_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Drives the app through its main screens, taking a screenshot of each,
/// so marketing assets (README, Play Store, website) can be generated
/// without manually navigating the app.
///
/// Run with:
///   flutter drive \
///     --driver=test_driver/integration_test.dart \
///     --target=integration_test/screenshot_test.dart \
///     --dart-define=SEED_ENABLED=true
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('capture marketing screenshots', (tester) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(
      SharedPreferencesKeys.themeModeKey,
      'light',
    );
    await sharedPreferences.setStringList(
      SharedPreferencesKeys.userDisciplinesKey,
      adsDisciplines
          .take(3)
          .map((discipline) => discipline.id.toString())
          .toList(),
    );

    final appDatabase = await AppDatabase.instance;
    await runDevSeeds(appDatabase);

    await binding.convertFlutterSurfaceToImage();

    /// `pumpAndSettle` can hang on screens with looping animations
    /// (e.g. the calendar view), so drive frames manually instead.
    Future<void> settle() async {
      for (var i = 0; i < 30; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          appDatabaseProvider.overrideWithValue(appDatabase),
        ],
        child: const AppWidget(),
      ),
    );

    await settle();

    Future<void> shoot(String name) async {
      await settle();
      await binding.takeScreenshot(name);
    }

    Future<void> goBack() async {
      final backButton = find.byType(BackIconButtonWidget);
      if (backButton.evaluate().isEmpty) return;

      await tester.tap(backButton.first);
      await settle();
    }

    Future<void> tapNavLabel(String label) async {
      await tester.tap(
        find.descendant(
          of: find.byType(NavBarWidget),
          matching: find.text(label),
        ),
      );
      await settle();
    }

    Future<void> tapVisibleText(String text) async {
      final finder = find.text(text).first;
      await tester.ensureVisible(finder);
      await settle();
      await tester.tap(finder);
      await settle();
    }

    await shoot('01_home');

    await tester.tap(find.text('Agenda'));
    await settle();
    await shoot('02_agenda');
    await goBack();

    await tapNavLabel('Atividades');
    await shoot('03_activities');

    final activityCard = find.byType(ActivityCardWidget);
    if (activityCard.evaluate().isNotEmpty) {
      await tester.tap(activityCard.first);
      await settle();
      await shoot('04_activity_details');
      await goBack();
    }

    await tapNavLabel('Grade');
    await shoot('05_my_disciplines');

    final disciplineCard = find.byType(DisciplineCardItemWidget);
    if (disciplineCard.evaluate().isNotEmpty) {
      await tester.tap(disciplineCard.first);
      await settle();
      await shoot('06_discipline_details');
      await goBack();
    }

    await tapNavLabel('Ajustes');
    await shoot('07_settings');

    await tapVisibleText('Categorias');
    await shoot('08_categories');
    await goBack();

    await tapVisibleText('Tags');
    await shoot('09_tags');
    await goBack();

    await tapVisibleText('Sobre o Academic Planner');
    await shoot('10_about');
  });
}
