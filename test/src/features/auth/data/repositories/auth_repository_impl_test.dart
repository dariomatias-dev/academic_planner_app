import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:academic_planner/src/features/auth/data/services/auth_service.dart';
import 'package:academic_planner/src/features/auth/domain/entities/auth_user_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

LoginEntity _loginEntity() => LoginEntity(email: 'a@b.com', password: '123456');

RegisterEntity _registerEntity() =>
    RegisterEntity(name: 'Alice', email: 'a@b.com', password: '123456');

void main() {
  late MockAuthService mockService;
  late AuthRepositoryImpl sut;

  setUp(() {
    mockService = MockAuthService();
    sut = AuthRepositoryImpl(mockService);
  });

  group('signIn', () {
    test('success → returns Success<void>', () async {
      when(
        () => mockService.signIn(any(), any()),
      ).thenAnswer((_) async => MockUserCredential());

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Success<void>>());
      verify(() => mockService.signIn('a@b.com', '123456')).called(1);
    });

    test('exception → returns Failure', () async {
      when(
        () => mockService.signIn(any(), any()),
      ).thenThrow(Exception('auth error'));

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Failure<void>>());
    });
  });

  group('signUp', () {
    test('success with user → returns Success<AuthUserEntity>', () async {
      final mockUser = MockUser();
      final mockCredential = MockUserCredential();
      when(() => mockUser.uid).thenReturn('uid-1');
      when(() => mockUser.emailVerified).thenReturn(false);
      when(() => mockCredential.user).thenReturn(mockUser);
      when(
        () => mockService.signUp(any(), any()),
      ).thenAnswer((_) async => mockCredential);

      final result = await sut.signUp(_registerEntity());

      expect(result, isA<Success<AuthUserEntity?>>());
      result.when(
        onSuccess: (user) {
          expect(user!.uid, 'uid-1');
          expect(user.emailVerified, isFalse);
        },
        onFailure: (_) => fail('expected success'),
      );
      verify(() => mockService.signUp('a@b.com', '123456')).called(1);
    });

    test('success with no user → returns Success<null>', () async {
      final mockCredential = MockUserCredential();
      when(() => mockCredential.user).thenReturn(null);
      when(
        () => mockService.signUp(any(), any()),
      ).thenAnswer((_) async => mockCredential);

      final result = await sut.signUp(_registerEntity());

      expect(result, isA<Success<AuthUserEntity?>>());
      result.when(
        onSuccess: (user) => expect(user, isNull),
        onFailure: (_) => fail('expected success'),
      );
    });

    test('exception → returns Failure', () async {
      when(
        () => mockService.signUp(any(), any()),
      ).thenThrow(Exception('auth error'));

      final result = await sut.signUp(_registerEntity());

      expect(result, isA<Failure<AuthUserEntity?>>());
    });
  });

  group('signInWithGoogle', () {
    test('success with user → returns Success<AuthUserEntity>', () async {
      final mockUser = MockUser();
      final mockCredential = MockUserCredential();
      when(() => mockUser.uid).thenReturn('uid-1');
      when(() => mockUser.emailVerified).thenReturn(true);
      when(() => mockUser.email).thenReturn('a@b.com');
      when(() => mockUser.displayName).thenReturn('Alice');
      when(() => mockCredential.user).thenReturn(mockUser);
      when(
        () => mockService.signInWithGoogle(),
      ).thenAnswer((_) async => mockCredential);

      final result = await sut.signInWithGoogle();

      expect(result, isA<Success<AuthUserEntity?>>());
      result.when(
        onSuccess: (user) {
          expect(user!.uid, 'uid-1');
          expect(user.email, 'a@b.com');
          expect(user.displayName, 'Alice');
        },
        onFailure: (_) => fail('expected success'),
      );
    });

    test('user cancels picker → returns Success<null>', () async {
      when(
        () => mockService.signInWithGoogle(),
      ).thenAnswer((_) async => null);

      final result = await sut.signInWithGoogle();

      expect(result, isA<Success<AuthUserEntity?>>());
      result.when(
        onSuccess: (user) => expect(user, isNull),
        onFailure: (_) => fail('expected success'),
      );
    });

    test('exception → returns Failure', () async {
      when(
        () => mockService.signInWithGoogle(),
      ).thenThrow(Exception('auth error'));

      final result = await sut.signInWithGoogle();

      expect(result, isA<Failure<AuthUserEntity?>>());
    });
  });

  group('signOut', () {
    test('success → returns Success<void>', () async {
      when(() => mockService.signOut()).thenAnswer((_) async {});

      final result = await sut.signOut();

      expect(result, isA<Success<void>>());
      verify(() => mockService.signOut()).called(1);
    });

    test('exception → returns Failure', () async {
      when(() => mockService.signOut()).thenThrow(Exception('auth error'));

      final result = await sut.signOut();

      expect(result, isA<Failure<void>>());
    });
  });

  group('deleteAccount', () {
    test('success → returns Success<void>', () async {
      when(() => mockService.deleteAccount()).thenAnswer((_) async {});

      final result = await sut.deleteAccount();

      expect(result, isA<Success<void>>());
      verify(() => mockService.deleteAccount()).called(1);
    });

    test('exception → returns Failure', () async {
      when(
        () => mockService.deleteAccount(),
      ).thenThrow(Exception('auth error'));

      final result = await sut.deleteAccount();

      expect(result, isA<Failure<void>>());
    });
  });

  group('sendEmailVerification', () {
    test('success → returns Success<void>', () async {
      when(() => mockService.sendEmailVerification()).thenAnswer((_) async {});

      final result = await sut.sendEmailVerification();

      expect(result, isA<Success<void>>());
      verify(() => mockService.sendEmailVerification()).called(1);
    });

    test('exception → returns Failure', () async {
      when(
        () => mockService.sendEmailVerification(),
      ).thenThrow(Exception('auth error'));

      final result = await sut.sendEmailVerification();

      expect(result, isA<Failure<void>>());
    });
  });

  group('reloadUser', () {
    test('success → returns Success<void>', () async {
      when(() => mockService.reloadUser()).thenAnswer((_) async {});

      final result = await sut.reloadUser();

      expect(result, isA<Success<void>>());
      verify(() => mockService.reloadUser()).called(1);
    });

    test('exception → returns Failure', () async {
      when(() => mockService.reloadUser()).thenThrow(Exception('auth error'));

      final result = await sut.reloadUser();

      expect(result, isA<Failure<void>>());
    });
  });

  group('currentUser', () {
    test('user present → maps to AuthUserEntity', () {
      final user = MockUser();
      when(() => user.uid).thenReturn('uid-1');
      when(() => user.emailVerified).thenReturn(true);
      when(() => mockService.currentUser).thenReturn(user);

      final result = sut.currentUser;

      expect(result, isNotNull);
      expect(result!.uid, 'uid-1');
      expect(result.emailVerified, isTrue);
    });

    test('no user → returns null', () {
      when(() => mockService.currentUser).thenReturn(null);

      expect(sut.currentUser, isNull);
    });
  });

  group('authStateChanges', () {
    test('maps stream of User? to AuthUserEntity?', () async {
      final user = MockUser();
      when(() => user.uid).thenReturn('uid-1');
      when(() => user.emailVerified).thenReturn(true);
      final stream = Stream<User?>.fromIterable([user, null]);
      when(() => mockService.authStateChanges()).thenAnswer((_) => stream);

      final emitted = await sut.authStateChanges().toList();

      expect(emitted, hasLength(2));
      expect(emitted[0]!.uid, 'uid-1');
      expect(emitted[1], isNull);
      verify(() => mockService.authStateChanges()).called(1);
    });
  });
}
