import 'dart:async';

import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/auth/presentation/providers/auth_notifier.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier(this._initialUser);

  final UserEntity? _initialUser;

  @override
  Future<UserEntity?> build() async => _initialUser;

  AsyncValue<UserEntity?> get emittedState => state;

  set emittedState(AsyncValue<UserEntity?> value) {
    state = value;
  }
}

UserEntity _user({String id = '1'}) => UserEntity(
  id: id,
  email: 'user@test.com',
  name: 'User',
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

void main() {
  late MockUserRepository mockRepository;
  late _FakeAuthNotifier fakeAuthNotifier;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_user());
  });

  setUp(() {
    mockRepository = MockUserRepository();
  });

  void buildContainer(UserEntity? initialAuthUser) {
    fakeAuthNotifier = _FakeAuthNotifier(initialAuthUser);
    container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        userRepositoryProvider.overrideWithValue(mockRepository),
        authNotifierProvider.overrideWith(() => fakeAuthNotifier),
      ],
    );
    addTearDown(container.dispose);
  }

  // authNotifierProvider must be fully settled before userNotifierProvider
  // is read: UserNotifier.build() reads auth state synchronously right
  // after subscribing to it, so an in-flight auth build races with its own
  // listener and makes the test non-deterministic.
  Future<UserEntity?> readyUserNotifier() async {
    container.read(authNotifierProvider.notifier);
    await container.read(authNotifierProvider.future);

    container.read(userNotifierProvider.notifier);
    return container.read(userNotifierProvider.future);
  }

  group('build', () {
    test('auth has a user → loads and returns it', () async {
      final user = _user();
      buildContainer(user);
      when(
        () => mockRepository.getById(user.id),
      ).thenAnswer((_) async => Success(user));

      final result = await readyUserNotifier();

      expect(result, same(user));
    });

    test('auth has no user → resolves to null', () async {
      buildContainer(null);

      final result = await readyUserNotifier();

      expect(result, isNull);
      verifyNever(() => mockRepository.getById(any()));
    });

    test('repository failure → notifier throws', () async {
      final user = _user();
      buildContainer(user);
      when(() => mockRepository.getById(user.id)).thenAnswer(
        (_) async => const Failure(DatabaseFailure('boom')),
      );

      await expectLater(readyUserNotifier(), throwsA(isA<Exception>()));
    });
  });

  group('auth state changes', () {
    test('auth emits a new user → loads and exposes it', () async {
      buildContainer(null);
      await readyUserNotifier();

      final newUser = _user(id: '2');
      final completer = Completer<Result<UserEntity?>>();
      when(
        () => mockRepository.getById(newUser.id),
      ).thenAnswer((_) => completer.future);

      fakeAuthNotifier.emittedState = AsyncData(newUser);
      expect(container.read(userNotifierProvider).isLoading, isTrue);

      completer.complete(Success(newUser));
      await Future<void>.delayed(Duration.zero);

      expect(container.read(userNotifierProvider).value, same(newUser));
    });

    test('auth emits null → clears the user', () async {
      final user = _user();
      buildContainer(user);
      when(
        () => mockRepository.getById(user.id),
      ).thenAnswer((_) async => Success(user));
      await readyUserNotifier();

      fakeAuthNotifier.emittedState = const AsyncData(null);
      await Future<void>.delayed(Duration.zero);

      expect(container.read(userNotifierProvider).value, isNull);
    });

    test('auth emits an error → mirrors it', () async {
      buildContainer(null);
      await readyUserNotifier();

      fakeAuthNotifier.emittedState = const AsyncError(
        'auth boom',
        StackTrace.empty,
      );
      await Future<void>.delayed(Duration.zero);

      expect(container.read(userNotifierProvider).hasError, isTrue);
    });
  });

  group('updateProfile', () {
    test('success → updates state to the new user', () async {
      final user = _user();
      buildContainer(user);
      when(
        () => mockRepository.getById(user.id),
      ).thenAnswer((_) async => Success(user));
      await readyUserNotifier();

      final updated = _user();
      when(
        () => mockRepository.update(any()),
      ).thenAnswer((_) async => const Success(null));

      final result = await container
          .read(userNotifierProvider.notifier)
          .updateProfile(updated);

      expect(result, isA<Success<void>>());
      expect(container.read(userNotifierProvider).value, same(updated));
    });

    test('failure → AsyncError', () async {
      final user = _user();
      buildContainer(user);
      when(
        () => mockRepository.getById(user.id),
      ).thenAnswer((_) async => Success(user));
      await readyUserNotifier();

      when(() => mockRepository.update(any())).thenAnswer(
        (_) async => const Failure(ValidationFailure('invalid')),
      );

      final result = await container
          .read(userNotifierProvider.notifier)
          .updateProfile(user);

      expect(result, isA<Failure<void>>());
      expect(container.read(userNotifierProvider).hasError, isTrue);
    });
  });

  group('deleteAccount', () {
    test('no current user → Success without calling repository', () async {
      buildContainer(null);
      await readyUserNotifier();

      final result = await container
          .read(userNotifierProvider.notifier)
          .deleteAccount();

      expect(result, isA<Success<void>>());
      verifyNever(() => mockRepository.delete(any()));
    });

    test('success → clears the user', () async {
      final user = _user();
      buildContainer(user);
      when(
        () => mockRepository.getById(user.id),
      ).thenAnswer((_) async => Success(user));
      await readyUserNotifier();
      when(
        () => mockRepository.delete(user.id),
      ).thenAnswer((_) async => const Success(null));

      final result = await container
          .read(userNotifierProvider.notifier)
          .deleteAccount();

      expect(result, isA<Success<void>>());
      expect(container.read(userNotifierProvider).value, isNull);
    });
  });

  group('refresh', () {
    test('no auth user → Success without calling repository', () async {
      buildContainer(null);
      await readyUserNotifier();

      final result = await container
          .read(userNotifierProvider.notifier)
          .refresh();

      expect(result, isA<Success<void>>());
      verifyNever(() => mockRepository.getById(any()));
    });

    test('auth user present → reloads and updates state', () async {
      final user = _user();
      buildContainer(user);
      when(
        () => mockRepository.getById(user.id),
      ).thenAnswer((_) async => Success(user));
      await readyUserNotifier();

      final refreshed = _user();
      when(
        () => mockRepository.getById(user.id),
      ).thenAnswer((_) async => Success(refreshed));

      final result = await container
          .read(userNotifierProvider.notifier)
          .refresh();

      expect(result, isA<Success<void>>());
      expect(container.read(userNotifierProvider).value, same(refreshed));
    });
  });
}
