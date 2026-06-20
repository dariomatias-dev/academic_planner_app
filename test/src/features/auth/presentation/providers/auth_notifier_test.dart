import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

LoginEntity _loginEntity() => LoginEntity(email: 'a@b.com', password: '123456');

RegisterEntity _registerEntity() =>
    RegisterEntity(name: 'Alice', email: 'a@b.com', password: '123456');

UserEntity _userEntity({String id = 'uid-1'}) => UserEntity(
  id: id,
  email: 'a@b.com',
  name: 'Alice',
  createdAt: DateTime.parse('2024-01-01T00:00:00.000'),
  updatedAt: DateTime.parse('2024-01-01T00:00:00.000'),
);

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockUserRepository mockUserRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_loginEntity());
    registerFallbackValue(_registerEntity());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUserRepository = MockUserRepository();
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        userRepositoryProvider.overrideWithValue(mockUserRepository),
      ],
    );
    addTearDown(container.dispose);
  });

  group('build', () {
    test('no current user → resolves to null', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);

      final state = await container.read(authNotifierProvider.future);

      expect(state, isNull);
    });

    test('verified user → resolves to user from repository', () async {
      final mockUser = MockUser();
      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      when(mockUser.reload).thenAnswer((_) async {});
      when(() => mockUser.emailVerified).thenReturn(true);
      when(() => mockUser.uid).thenReturn('uid-1');
      when(
        () => mockUserRepository.getById('uid-1'),
      ).thenAnswer((_) async => Success<UserEntity?>(_userEntity()));

      final state = await container.read(authNotifierProvider.future);

      expect(state, isNotNull);
      expect(state!.id, 'uid-1');
    });

    test('unverified user → signs out and resolves to null', () async {
      final mockUser = MockUser();
      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      when(mockUser.reload).thenAnswer((_) async {});
      when(() => mockUser.emailVerified).thenReturn(false);
      when(
        () => mockAuthRepository.signOut(),
      ).thenAnswer((_) async => const Success<void>(null));

      final state = await container.read(authNotifierProvider.future);

      expect(state, isNull);
      verify(() => mockAuthRepository.signOut()).called(1);
    });

    test('getById failure → throws', () async {
      final mockUser = MockUser();
      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      when(mockUser.reload).thenAnswer((_) async {});
      when(() => mockUser.emailVerified).thenReturn(true);
      when(() => mockUser.uid).thenReturn('uid-1');
      when(() => mockUserRepository.getById('uid-1')).thenAnswer(
        (_) async => const Failure<UserEntity?>(DatabaseFailure('not found')),
      );

      final retryContainer = ProviderContainer(
        retry: (_, _) => null,
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          userRepositoryProvider.overrideWithValue(mockUserRepository),
        ],
      );
      addTearDown(retryContainer.dispose);

      await expectLater(
        retryContainer.read(authNotifierProvider.future),
        throwsException,
      );
    });
  });

  group('signIn', () {
    test('success → state becomes AsyncData with user', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      await container.read(authNotifierProvider.future);

      final mockUser = MockUser();
      final mockCredential = MockUserCredential();
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => Success<UserCredential>(mockCredential),
      );
      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      when(mockUser.reload).thenAnswer((_) async {});
      when(() => mockUser.emailVerified).thenReturn(true);
      when(() => mockUser.uid).thenReturn('uid-1');
      when(
        () => mockUserRepository.getById('uid-1'),
      ).thenAnswer((_) async => Success<UserEntity?>(_userEntity()));

      final result = await container
          .read(authNotifierProvider.notifier)
          .signIn(_loginEntity());

      expect(result, isA<Success<void>>());
      final state = container.read(authNotifierProvider);
      expect(state.value, isNotNull);
      expect(state.value!.id, 'uid-1');
    });

    test('failure → state becomes AsyncError', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      await container.read(authNotifierProvider.future);

      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => const Failure<UserCredential>(
          AuthFailure('invalid credentials'),
        ),
      );

      final result = await container
          .read(authNotifierProvider.notifier)
          .signIn(_loginEntity());

      expect(result, isA<Failure<void>>());
      final state = container.read(authNotifierProvider);
      expect(state.hasError, isTrue);
    });
  });

  group('register', () {
    test('success → state becomes AsyncData(null)', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      await container.read(authNotifierProvider.future);

      final mockCredential = MockUserCredential();
      when(() => mockAuthRepository.signUp(any())).thenAnswer(
        (_) async => Success<UserCredential>(mockCredential),
      );
      when(() => mockCredential.user).thenReturn(null);
      when(
        () => mockAuthRepository.signOut(),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await container
          .read(authNotifierProvider.notifier)
          .register(_registerEntity());

      expect(result, isA<Success<void>>());
      final state = container.read(authNotifierProvider);
      expect(state.value, isNull);
      expect(state.hasError, isFalse);
    });

    test('failure → state becomes AsyncError', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      await container.read(authNotifierProvider.future);

      when(() => mockAuthRepository.signUp(any())).thenAnswer(
        (_) async => const Failure<UserCredential>(
          AuthFailure('email already in use'),
        ),
      );

      final result = await container
          .read(authNotifierProvider.notifier)
          .register(_registerEntity());

      expect(result, isA<Failure<void>>());
      final state = container.read(authNotifierProvider);
      expect(state.hasError, isTrue);
    });
  });

  group('signOut', () {
    test('success → state becomes AsyncData(null)', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      await container.read(authNotifierProvider.future);

      when(
        () => mockAuthRepository.signOut(),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await container
          .read(authNotifierProvider.notifier)
          .signOut();

      expect(result, isA<Success<void>>());
      expect(container.read(authNotifierProvider).value, isNull);
    });

    test('failure → state becomes AsyncError', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      await container.read(authNotifierProvider.future);

      when(() => mockAuthRepository.signOut()).thenAnswer(
        (_) async => const Failure<void>(UnknownFailure('signOut error')),
      );

      final result = await container
          .read(authNotifierProvider.notifier)
          .signOut();

      expect(result, isA<Failure<void>>());
      expect(container.read(authNotifierProvider).hasError, isTrue);
    });
  });

  group('deleteAccount', () {
    test('success → state becomes AsyncData(null)', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      await container.read(authNotifierProvider.future);

      when(
        () => mockAuthRepository.deleteAccount(),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await container
          .read(authNotifierProvider.notifier)
          .deleteAccount();

      expect(result, isA<Success<void>>());
      expect(container.read(authNotifierProvider).value, isNull);
    });

    test('failure → state becomes AsyncError', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      await container.read(authNotifierProvider.future);

      when(() => mockAuthRepository.deleteAccount()).thenAnswer(
        (_) async => const Failure<void>(UnknownFailure('delete error')),
      );

      final result = await container
          .read(authNotifierProvider.notifier)
          .deleteAccount();

      expect(result, isA<Failure<void>>());
      expect(container.read(authNotifierProvider).hasError, isTrue);
    });
  });

  group('sendEmailVerification', () {
    test('success → state becomes AsyncData with current user', () async {
      final mockUser = MockUser();
      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      when(mockUser.reload).thenAnswer((_) async {});
      when(() => mockUser.emailVerified).thenReturn(true);
      when(() => mockUser.uid).thenReturn('uid-1');
      when(
        () => mockUserRepository.getById('uid-1'),
      ).thenAnswer((_) async => Success<UserEntity?>(_userEntity()));
      await container.read(authNotifierProvider.future);

      when(
        () => mockAuthRepository.sendEmailVerification(),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await container
          .read(authNotifierProvider.notifier)
          .sendEmailVerification();

      expect(result, isA<Success<void>>());
      expect(container.read(authNotifierProvider).value, isNotNull);
    });

    test('failure → state becomes AsyncError', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);
      await container.read(authNotifierProvider.future);

      when(() => mockAuthRepository.sendEmailVerification()).thenAnswer(
        (_) async => const Failure<void>(UnknownFailure('send error')),
      );

      final result = await container
          .read(authNotifierProvider.notifier)
          .sendEmailVerification();

      expect(result, isA<Failure<void>>());
      expect(container.read(authNotifierProvider).hasError, isTrue);
    });
  });
}
