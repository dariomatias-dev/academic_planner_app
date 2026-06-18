import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  group('signIn', () {
    test('success → sets user and isEmailVerified', () async {
      final mockUser = MockUser();
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => Success<UserCredential>(MockUserCredential()),
      );
      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      when(mockUser.reload).thenAnswer((_) async {});
      when(() => mockUser.emailVerified).thenReturn(true);
      when(() => mockUser.uid).thenReturn('uid-1');
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
        (_) async => const Failure<UserCredential>(
          AuthFailure('invalid credentials'),
        ),
      );

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Failure<void>>());
    });

    test('currentUser null → returns Success without reload', () async {
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => Success<UserCredential>(MockUserCredential()),
      );
      when(() => mockAuthRepository.currentUser).thenReturn(null);

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Success<void>>());
      verifyNever(() => mockUserRepository.getById(any()));
    });

    test('email not verified → forces signOut and returns Failure', () async {
      final mockUser = MockUser();
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => Success<UserCredential>(MockUserCredential()),
      );
      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      when(mockUser.reload).thenAnswer((_) async {});
      when(() => mockUser.emailVerified).thenReturn(false);
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

    test('getById failure → returns Failure', () async {
      final mockUser = MockUser();
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => Success<UserCredential>(MockUserCredential()),
      );
      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      when(mockUser.reload).thenAnswer((_) async {});
      when(() => mockUser.emailVerified).thenReturn(true);
      when(() => mockUser.uid).thenReturn('uid-1');
      when(() => mockUserRepository.getById('uid-1')).thenAnswer(
        (_) async => const Failure<UserEntity?>(DatabaseFailure('not found')),
      );

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Failure<void>>());
    });

    test('exception during processing → returns UnknownFailure', () async {
      final mockUser = MockUser();
      when(() => mockAuthRepository.signIn(any())).thenAnswer(
        (_) async => Success<UserCredential>(MockUserCredential()),
      );
      when(() => mockAuthRepository.currentUser).thenReturn(mockUser);
      when(mockUser.reload).thenThrow(Exception('reload failed'));

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Failure<void>>());
      result.when(
        onSuccess: (_) => fail('expected failure'),
        onFailure: (f) => expect(f, isA<UnknownFailure>()),
      );
    });
  });

  group('signUp', () {
    test(
      'success with firebaseUser → creates user and sends verification',
      () async {
        final mockUser = MockUser();
        final mockCredential = MockUserCredential();
        when(
          () => mockAuthRepository.signUp(any()),
        ).thenAnswer((_) async => Success<UserCredential>(mockCredential));
        when(() => mockCredential.user).thenReturn(mockUser);
        when(() => mockUser.uid).thenReturn('uid-1');
        when(
          () => mockUserRepository.create(any()),
        ).thenAnswer((_) async => const Success<void>(null));
        when(mockUser.sendEmailVerification).thenAnswer((_) async {});
        when(
          () => mockAuthRepository.signOut(),
        ).thenAnswer((_) async => const Success<void>(null));

        final result = await sut.signUp(_registerEntity());

        expect(result, isA<Success<void>>());
        expect(sut.user, isNull);
        expect(sut.isEmailVerified, isFalse);
        verify(() => mockUserRepository.create(any())).called(1);
        verify(mockUser.sendEmailVerification).called(1);
        verify(() => mockAuthRepository.signOut()).called(1);
      },
    );

    test(
      'firebaseUser null → skips create/sendEmailVerification but signs out',
      () async {
        final mockCredential = MockUserCredential();
        when(
          () => mockAuthRepository.signUp(any()),
        ).thenAnswer((_) async => Success<UserCredential>(mockCredential));
        when(() => mockCredential.user).thenReturn(null);
        when(
          () => mockAuthRepository.signOut(),
        ).thenAnswer((_) async => const Success<void>(null));

        final result = await sut.signUp(_registerEntity());

        expect(result, isA<Success<void>>());
        verifyNever(() => mockUserRepository.create(any()));
        verify(() => mockAuthRepository.signOut()).called(1);
      },
    );

    test('repository failure → returns Failure', () async {
      when(() => mockAuthRepository.signUp(any())).thenAnswer(
        (_) async => const Failure<UserCredential>(
          AuthFailure('email already in use'),
        ),
      );

      final result = await sut.signUp(_registerEntity());

      expect(result, isA<Failure<void>>());
    });

    test('exception during processing → returns UnknownFailure', () async {
      final mockUser = MockUser();
      final mockCredential = MockUserCredential();
      when(
        () => mockAuthRepository.signUp(any()),
      ).thenAnswer((_) async => Success<UserCredential>(mockCredential));
      when(() => mockCredential.user).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn('uid-1');
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
