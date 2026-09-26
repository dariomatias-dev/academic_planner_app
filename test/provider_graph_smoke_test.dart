import 'package:academic_planner/src/core/database/migrations/migration_v1.dart';
import 'package:academic_planner/src/core/database/migrations/migration_v2.dart';
import 'package:academic_planner/src/core/di/app_version_provider.dart';
import 'package:academic_planner/src/core/di/database_provider.dart';
import 'package:academic_planner/src/core/di/firebase_providers.dart';
import 'package:academic_planner/src/core/di/shared_preferences_provider.dart';
import 'package:academic_planner/src/core/di/theme_provider.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/calendar/di/calendar_providers.dart';
import 'package:academic_planner/src/features/categories/di/category_providers.dart';
import 'package:academic_planner/src/features/disciplines/di/discipline_providers.dart';
import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'helpers/shared_preferences_test_helper.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Wires every top-level provider in the app with the minimal set of
// overrides needed to replace external dependencies (database, prefs,
// Firebase), then reads each one to catch wiring mistakes (a missing
// override, a provider that can't build, a typo in a dependency chain)
// that individual unit tests, each scoped to one provider, would miss.
void main() {
  late Database db;
  late ProviderContainer container;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    PackageInfo.setMockInitialValues(
      appName: 'Academic Planner',
      packageName: 'com.academicplanner.app',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  setUp(() async {
    db = await databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (db, _) async {
          for (final migration in [MigrationV1(), MigrationV2()]) {
            await migration.up(db);
          }
        },
      ),
    );

    final prefs = await fakeSharedPreferences();

    final firebaseAuth = MockFirebaseAuth();
    when(() => firebaseAuth.currentUser).thenReturn(null);

    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
        firebaseAuthProvider.overrideWithValue(firebaseAuth),
        firestoreProvider.overrideWithValue(FakeFirebaseFirestore()),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  test('resolves every provider in the graph without throwing', () async {
    // Core
    container.read(themeNotifierProvider);
    await container.read(appVersionProvider.future);

    // Auth
    await container.read(authNotifierProvider.future);

    // Activities
    container
      ..read(activityRepositoryProvider)
      ..read(activityFilterNotifierProvider);
    await container.read(activityNotifierProvider.future);
    await container.read(activityStatsNotifierProvider.future);
    await container.read(activityCountProvider(null).future);

    // Calendar
    await container.read(agendaNotifierProvider.future);

    // Categories
    await container.read(categoryNotifierProvider.future);

    // Disciplines
    container.read(userDisciplinesNotifierProvider);

    // Notes
    await container.read(noteNotifierProvider.future);

    // Tags
    await container.read(tagNotifierProvider.future);

    // Users
    container
      ..read(userViewModelProvider)
      ..read(userFilterProvider);
    await container.read(userNotifierProvider.future);
    await container.read(usersProvider.future);
  });
}
