import 'package:academic_planner/src/core/database/migrations/migration_v1.dart';
import 'package:academic_planner/src/core/database/migrations/migration_v2.dart';
import 'package:academic_planner/src/core/di/database_provider.dart';
import 'package:academic_planner/src/core/di/shared_preferences_provider.dart';
import 'package:academic_planner/src/core/routes/app_router.dart';
import 'package:academic_planner/src/core/routes/route_paths.dart';
import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../../../helpers/fakes.dart';
import '../../../helpers/pump_router_app.dart';
import '../../../helpers/shared_preferences_test_helper.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  group('resolveAuthRedirect', () {
    test('never redirects away from splash', () {
      for (final isLoggedIn in [true, false]) {
        expect(
          resolveAuthRedirect(
            isLoggedIn: isLoggedIn,
            isLoading: false,
            matchedLocation: RoutePaths.splash,
          ),
          isNull,
        );
      }
    });

    test('makes no decision while the session is still loading', () {
      expect(
        resolveAuthRedirect(
          isLoggedIn: false,
          isLoading: true,
          matchedLocation: RoutePaths.activities,
        ),
        isNull,
      );
    });

    test('sends a signed-out user on a protected route to login', () {
      expect(
        resolveAuthRedirect(
          isLoggedIn: false,
          isLoading: false,
          matchedLocation: RoutePaths.activities,
        ),
        RoutePaths.login,
      );
    });

    test('leaves a signed-out user on a public route alone', () {
      for (final path in [RoutePaths.login, RoutePaths.register]) {
        expect(
          resolveAuthRedirect(
            isLoggedIn: false,
            isLoading: false,
            matchedLocation: path,
          ),
          isNull,
        );
      }
    });

    test('sends a signed-in user on an auth-only route to home', () {
      expect(
        resolveAuthRedirect(
          isLoggedIn: true,
          isLoading: false,
          matchedLocation: RoutePaths.login,
        ),
        RoutePaths.home,
      );
    });

    test('leaves a signed-in user on a protected route alone', () {
      expect(
        resolveAuthRedirect(
          isLoggedIn: true,
          isLoading: false,
          matchedLocation: RoutePaths.activities,
        ),
        isNull,
      );
    });
  });

  group('routerProvider wiring', () {
    late Database db;
    late ProviderContainer container;
    late MockAuthRepository authRepository;

    setUpAll(() async {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
      await initializeDateFormatting('pt_BR');
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
      authRepository = MockAuthRepository();

      container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          sharedPreferencesProvider.overrideWithValue(prefs),
          authRepositoryProvider.overrideWithValue(authRepository),
          // AuthNotifier.build() always resolves this, even when
          // currentUser is null and it's never actually called.
          userRepositoryProvider.overrideWithValue(MockUserRepository()),
        ],
      );
      addTearDown(container.dispose);
    });

    tearDown(() => db.close());

    testWidgets(
      'a real navigation to a protected route redirects to login when '
      'signed out',
      (tester) async {
        when(() => authRepository.currentUser).thenReturn(null);
        await container.read(authNotifierProvider.future);

        final router = container.read(routerProvider)
          ..go(RoutePaths.activities);

        await pumpRouterApp(tester, router, container);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(
          router.routerDelegate.currentConfiguration.uri.toString(),
          RoutePaths.login,
        );
      },
    );

    testWidgets(
      'a real navigation to an auth-only route is left alone when '
      'signed out',
      (tester) async {
        when(() => authRepository.currentUser).thenReturn(null);
        await container.read(authNotifierProvider.future);

        final router = container.read(routerProvider)..go(RoutePaths.register);

        await pumpRouterApp(tester, router, container);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 500));

        expect(
          router.routerDelegate.currentConfiguration.uri.toString(),
          RoutePaths.register,
        );
      },
    );
  });
}
