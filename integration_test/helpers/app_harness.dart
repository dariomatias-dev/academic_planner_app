import 'dart:io';

import 'package:academic_planner/src/academic_planner_app.dart';
import 'package:academic_planner/src/core/database/app_database.dart';
import 'package:academic_planner/src/core/di/database_provider.dart';
import 'package:academic_planner/src/core/di/firebase_providers.dart';
import 'package:academic_planner/src/core/di/shared_preferences_provider.dart';
import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/auth/domain/entities/auth_user_entity.dart';
import 'package:academic_planner/src/features/users/data/repositories/user_repository_impl.dart';
import 'package:academic_planner/src/features/users/data/services/user_firestore_service.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'
    show databaseFactoryFfi, sqfliteFfiInit;

import 'fake_auth_repository.dart';

/// Boots the real app against a clean local state: an empty SQLite database
/// and empty preferences per harness, with Firebase Auth and Firestore
/// replaced by in-memory fakes. Create one per test with [create] and
/// release it with [dispose].
class AppHarness {
  AppHarness._(this._database, this._preferences, this._authRepository)
    : _firestore = FakeFirebaseFirestore();

  static const _databaseName = 'integration_test.db';

  static final testUser = UserEntity(
    id: 'integration-user',
    email: 'student@example.com',
    name: 'Integration Student',
    createdAt: DateTime(2026),
    updatedAt: DateTime(2026),
  );

  final Database _database;
  final SharedPreferences _preferences;
  final FakeAuthRepository _authRepository;
  final FakeFirebaseFirestore _firestore;

  static Future<AppHarness> create({bool signedIn = true}) async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    await initializeDateFormatting('pt_BR');

    final path = '${await getDatabasesPath()}/$_databaseName';
    await deleteDatabase(path);
    final database = await AppDatabase.open(path: path);

    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();

    final authRepository = FakeAuthRepository(
      signedInUser: signedIn
          ? AuthUserEntity(
              uid: testUser.id,
              email: testUser.email,
              displayName: testUser.name,
              emailVerified: true,
            )
          : null,
    );

    final harness = AppHarness._(database, preferences, authRepository);

    if (signedIn) {
      await UserRepositoryImpl(
        UserFirestoreService(harness._firestore),
      ).create(testUser);
    }

    return harness;
  }

  Future<void> launch(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(_database),
          sharedPreferencesProvider.overrideWithValue(_preferences),
          firestoreProvider.overrideWithValue(_firestore),
          authRepositoryProvider.overrideWithValue(_authRepository),
        ],
        child: const AcademicPlannerApp(),
      ),
    );

    await settle(tester);
  }

  /// Advances frames for a fixed span instead of `pumpAndSettle`, which can
  /// hang on screens with looping animations.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> dispose() => _database.close();
}
