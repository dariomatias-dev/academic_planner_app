import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/domain/entities/auth_user_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockUserRepository extends Mock implements UserRepository {}

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

AuthUserEntity _authUser({String uid = 'uid-1', bool emailVerified = true}) =>
    AuthUserEntity(uid: uid, emailVerified: emailVerified);

AuthUserEntity _googleAuthUser({String uid = 'uid-1'}) => AuthUserEntity(
  uid: uid,
  emailVerified: true,
  email: 'a@b.com',
  displayName: 'Alice',
);

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockUserRepository mockUserRepository;
  late AuthViewModel sut;

  setUpAll(() {
    registerFallbackValue(_loginEntity());
    registerFallbackValue(_registerEntity());
    registerFallbackValue(_userEntity());
  });

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockUserRepository = MockUserRepository();
    sut = AuthViewModel(
      authRepository: mockAuthRepository,
      userRepository: mockUserRepository,
    );
  });

  group('restoreSession', () {
    test('no current user → returns Success(null) without reload', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(null);

      final result = await sut.restoreSession();

      expect(result, isA<Success<UserEntity?>>());
      result.when(
        onSuccess: (user) => expect(user, isNull),
        onFailure: (_) => fail('expected success'),
      );
      verifyNever(() => mockAuthRepository.reloadUser());
    });

    test('verified user → sets user and isEmailVerified', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(_authUser());
      when(
        () => mockAuthRepository.reloadUser(),
      ).thenAnswer((_) async => const Success<void>(null));
      when(
        () => mockUserRepository.getById('uid-1'),
      ).thenAnswer((_) async => Success<UserEntity?>(_userEntity()));

      final result = await sut.restoreSession();

      expect(result, isA<Success<UserEntity?>>());
      expect(sut.isEmailVerified, isTrue);
      expect(sut.user, isNotNull);
    });

    test('unverified user → signs out and returns Success(null)', () async {
      when(
        () => mockAuthRepository.currentUser,
      ).thenReturn(_authUser(emailVerified: false));
      when(
        () => mockAuthRepository.reloadUser(),
      ).thenAnswer((_) async => const Success<void>(null));
      when(
        () => mockAuthRepository.signOut(),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.restoreSession();

      expect(result, isA<Success<UserEntity?>>());
      result.when(
        onSuccess: (user) => expect(user, isNull),
        onFailure: (_) => fail('expected success'),
      );
      verify(() => mockAuthRepository.signOut()).called(1);
    });

    test('reloadUser failure → returns Failure', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(_authUser());
      when(() => mockAuthRepository.reloadUser()).thenAnswer(
        (_) async => const Failure<void>(UnknownFailure('reload failed')),
      );

      final result = await sut.restoreSession();

      expect(result, isA<Failure<UserEntity?>>());
    });

    test('getById failure → returns Failure', () async {
      when(() => mockAuthRepository.currentUser).thenReturn(_authUser());
      when(
        () => mockAuthRepository.reloadUser(),
      ).thenAnswer((_) async => const Success<void>(null));
      when(() => mockUserRepository.getById('uid-1')).thenAnswer(
        (_) async => const Failure<UserEntity?>(DatabaseFailure('not found')),
      );

      final result = await sut.restoreSession();

      expect(result, isA<Failure<UserEntity?>>());
    });

    test(
      'reload clears currentUser → falls back to pre-reload user',
      () async {
        when(
          () => mockAuthRepository.currentUser,
        ).thenReturn(_authUser());
        when(
          () => mockAuthRepository.reloadUser(),
        ).thenAnswer((_) async {
          when(() => mockAuthRepository.currentUser).thenReturn(null);
          return const Success<void>(null);
        });
        when(
          () => mockUserRepository.getById('uid-1'),
        ).thenAnswer((_) async => Success<UserEntity?>(_userEntity()));

        final result = await sut.restoreSession();

        expect(result, isA<Success<UserEntity?>>());
        expect(sut.isEmailVerified, isTrue);
        verify(() => mockUserRepository.getById('uid-1')).called(1);
      },
    );
  });

  group('signIn', () {
    test('success → sets user and isEmailVerified', () async {
      when(
        () => mockAuthRepository.signIn(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      when(() => mockAuthRepository.currentUser).thenReturn(_authUser());
      when(
        () => mockAuthRepository.reloadUser(),
      ).thenAnswer((_) async => const Success<void>(null));
      when(
        () => mockUserRepository.getById('uid-1'),
      ).thenAnswer((_) async => Success<UserEntity?>(_userEntity()));

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Success<void>>());
      expect(sut.isEmailVerified, isTrue);
      expect(sut.user, isNotNull);
    });

    test('repository failure → returns Failure', () async {
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => const Failure<void>(AuthFailure('invalid credentials')),
      );

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Failure<void>>());
    });

    test('currentUser null → returns Success without reload', () async {
      when(
        () => mockAuthRepository.signIn(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      when(() => mockAuthRepository.currentUser).thenReturn(null);

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Success<void>>());
      verifyNever(() => mockAuthRepository.reloadUser());
      verifyNever(() => mockUserRepository.getById(any()));
    });

    test('email not verified → forces signOut and returns Failure', () async {
      when(
        () => mockAuthRepository.signIn(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      when(
        () => mockAuthRepository.currentUser,
      ).thenReturn(_authUser(emailVerified: false));
      when(
        () => mockAuthRepository.reloadUser(),
      ).thenAnswer((_) async => const Success<void>(null));
      when(
        () => mockAuthRepository.signOut(),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Failure<void>>());
      result.when(
        onSuccess: (_) => fail('expected failure'),
        onFailure: (f) => expect(f, isA<AuthFailure>()),
      );
      verify(() => mockAuthRepository.signOut()).called(1);
      expect(sut.isEmailVerified, isFalse);
    });

    test('reloadUser failure → returns Failure', () async {
      when(
        () => mockAuthRepository.signIn(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      when(
        () => mockAuthRepository.currentUser,
      ).thenReturn(_authUser());
      when(() => mockAuthRepository.reloadUser()).thenAnswer(
        (_) async => const Failure<void>(UnknownFailure('reload failed')),
      );

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Failure<void>>());
      result.when(
        onSuccess: (_) => fail('expected failure'),
        onFailure: (f) => expect(f, isA<UnknownFailure>()),
      );
    });

    test('getById failure → returns Failure', () async {
      when(
        () => mockAuthRepository.signIn(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      when(() => mockAuthRepository.currentUser).thenReturn(_authUser());
      when(
        () => mockAuthRepository.reloadUser(),
      ).thenAnswer((_) async => const Success<void>(null));
      when(() => mockUserRepository.getById('uid-1')).thenAnswer(
        (_) async => const Failure<UserEntity?>(DatabaseFailure('not found')),
      );

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Failure<void>>());
    });

    test('exception during processing → returns UnknownFailure', () async {
      when(
        () => mockAuthRepository.signIn(any()),
      ).thenAnswer((_) async => const Success<void>(null));
      when(() => mockAuthRepository.currentUser).thenReturn(_authUser());
      when(
        () => mockAuthRepository.reloadUser(),
      ).thenAnswer((_) async => const Success<void>(null));
      when(
        () => mockUserRepository.getById('uid-1'),
      ).thenThrow(Exception('lookup failed'));

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Failure<void>>());
      result.when(
        onSuccess: (_) => fail('expected failure'),
        onFailure: (f) => expect(f, isA<UnknownFailure>()),
      );
    });
  });

  group('signInWithGoogle', () {
    test(
      'cancelled by user → returns Success(null) without side effects',
      () async {
        when(
          () => mockAuthRepository.signInWithGoogle(),
        ).thenAnswer((_) async => const Success<AuthUserEntity?>(null));

        final result = await sut.signInWithGoogle();

        expect(result, isA<Success<void>>());
        verifyNever(() => mockUserRepository.getById(any()));
        expect(sut.user, isNull);
      },
    );

    test('existing user → sets user without creating a new one', () async {
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenAnswer((_) async => Success<AuthUserEntity?>(_googleAuthUser()));
      when(
        () => mockUserRepository.getById('uid-1'),
      ).thenAnswer((_) async => Success<UserEntity?>(_userEntity()));

      final result = await sut.signInWithGoogle();

      expect(result, isA<Success<void>>());
      expect(sut.isEmailVerified, isTrue);
      expect(sut.user, isNotNull);
      verifyNever(() => mockUserRepository.create(any()));
    });

    test('new user → creates user from Google profile', () async {
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenAnswer((_) async => Success<AuthUserEntity?>(_googleAuthUser()));
      when(
        () => mockUserRepository.getById('uid-1'),
      ).thenAnswer((_) async => const Success<UserEntity?>(null));
      when(
        () => mockUserRepository.create(any()),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.signInWithGoogle();

      expect(result, isA<Success<void>>());
      expect(sut.user?.email, 'a@b.com');
      expect(sut.user?.name, 'Alice');
      verify(() => mockUserRepository.create(any())).called(1);
    });

    test('repository failure → returns Failure', () async {
      when(() => mockAuthRepository.signInWithGoogle()).thenAnswer(
        (_) async => const Failure<AuthUserEntity?>(
          AuthFailure('google sign-in failed'),
        ),
      );

      final result = await sut.signInWithGoogle();

      expect(result, isA<Failure<void>>());
    });

    test('getById failure → returns Failure', () async {
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenAnswer((_) async => Success<AuthUserEntity?>(_googleAuthUser()));
      when(() => mockUserRepository.getById('uid-1')).thenAnswer(
        (_) async => const Failure<UserEntity?>(DatabaseFailure('not found')),
      );

      final result = await sut.signInWithGoogle();

      expect(result, isA<Failure<void>>());
    });

    test('create failure for new user → returns Failure', () async {
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenAnswer((_) async => Success<AuthUserEntity?>(_googleAuthUser()));
      when(
        () => mockUserRepository.getById('uid-1'),
      ).thenAnswer((_) async => const Success<UserEntity?>(null));
      when(() => mockUserRepository.create(any())).thenAnswer(
        (_) async => const Failure<void>(DatabaseFailure('create failed')),
      );

      final result = await sut.signInWithGoogle();

      expect(result, isA<Failure<void>>());
    });

    test('exception during processing → returns UnknownFailure', () async {
      when(
        () => mockAuthRepository.signInWithGoogle(),
      ).thenAnswer((_) async => Success<AuthUserEntity?>(_googleAuthUser()));
      when(
        () => mockUserRepository.getById('uid-1'),
      ).thenThrow(Exception('lookup failed'));

      final result = await sut.signInWithGoogle();

      expect(result, isA<Failure<void>>());
      result.when(
        onSuccess: (_) => fail('expected failure'),
        onFailure: (f) => expect(f, isA<UnknownFailure>()),
      );
    });
  });

  group('signUp', () {
    test(
      'success with authUser → creates user and sends verification',
      () async {
        when(
          () => mockAuthRepository.signUp(any()),
        ).thenAnswer((_) async => Success<AuthUserEntity?>(_authUser()));
        when(
          () => mockUserRepository.create(any()),
        ).thenAnswer((_) async => const Success<void>(null));
        when(
          () => mockAuthRepository.sendEmailVerification(),
        ).thenAnswer((_) async => const Success<void>(null));
        when(
          () => mockAuthRepository.signOut(),
        ).thenAnswer((_) async => const Success<void>(null));

        final result = await sut.signUp(_registerEntity());

        expect(result, isA<Success<void>>());
        expect(sut.user, isNull);
        expect(sut.isEmailVerified, isFalse);
        verify(() => mockUserRepository.create(any())).called(1);
        verify(() => mockAuthRepository.sendEmailVerification()).called(1);
        verify(() => mockAuthRepository.signOut()).called(1);
      },
    );

    test(
      'authUser null → skips create/sendEmailVerification but signs out',
      () async {
        when(
          () => mockAuthRepository.signUp(any()),
        ).thenAnswer((_) async => const Success<AuthUserEntity?>(null));
        when(
          () => mockAuthRepository.signOut(),
        ).thenAnswer((_) async => const Success<void>(null));

        final result = await sut.signUp(_registerEntity());

        expect(result, isA<Success<void>>());
        verifyNever(() => mockUserRepository.create(any()));
        verifyNever(() => mockAuthRepository.sendEmailVerification());
        verify(() => mockAuthRepository.signOut()).called(1);
      },
    );

    test('repository failure → returns Failure', () async {
      when(() => mockAuthRepository.signUp(any())).thenAnswer(
        (_) async => const Failure<AuthUserEntity?>(
          AuthFailure('email already in use'),
        ),
      );

      final result = await sut.signUp(_registerEntity());

      expect(result, isA<Failure<void>>());
    });

    test('exception during processing → returns UnknownFailure', () async {
      when(
        () => mockAuthRepository.signUp(any()),
      ).thenAnswer((_) async => Success<AuthUserEntity?>(_authUser()));
      when(
        () => mockUserRepository.create(any()),
      ).thenThrow(Exception('create failed'));

      final result = await sut.signUp(_registerEntity());

      expect(result, isA<Failure<void>>());
      result.when(
        onSuccess: (_) => fail('expected failure'),
        onFailure: (f) => expect(f, isA<UnknownFailure>()),
      );
    });
  });

  group('signOut', () {
    test('success → clears user state', () async {
      when(
        () => mockAuthRepository.signOut(),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.signOut();

      expect(result, isA<Success<void>>());
      expect(sut.user, isNull);
      expect(sut.isEmailVerified, isFalse);
    });

    test('failure → returns Failure', () async {
      when(() => mockAuthRepository.signOut()).thenAnswer(
        (_) async => const Failure<void>(UnknownFailure('signOut error')),
      );

      final result = await sut.signOut();

      expect(result, isA<Failure<void>>());
    });
  });

  group('deleteAccount', () {
    test('success → clears user state', () async {
      when(
        () => mockAuthRepository.deleteAccount(),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.deleteAccount();

      expect(result, isA<Success<void>>());
      expect(sut.user, isNull);
      expect(sut.isEmailVerified, isFalse);
    });

    test('failure → returns Failure', () async {
      when(() => mockAuthRepository.deleteAccount()).thenAnswer(
        (_) async => const Failure<void>(UnknownFailure('delete error')),
      );

      final result = await sut.deleteAccount();

      expect(result, isA<Failure<void>>());
    });
  });

  group('sendEmailVerification', () {
    test('success → returns Success', () async {
      when(
        () => mockAuthRepository.sendEmailVerification(),
      ).thenAnswer((_) async => const Success<void>(null));

      final result = await sut.sendEmailVerification();

      expect(result, isA<Success<void>>());
    });

    test('failure → returns Failure', () async {
      when(() => mockAuthRepository.sendEmailVerification()).thenAnswer(
        (_) async => const Failure<void>(UnknownFailure('send error')),
      );

      final result = await sut.sendEmailVerification();

      expect(result, isA<Failure<void>>());
    });
  });
}
