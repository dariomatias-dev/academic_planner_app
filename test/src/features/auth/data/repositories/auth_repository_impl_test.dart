import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:academic_planner/src/features/auth/data/services/auth_service.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

LoginEntity _loginEntity() =>
    LoginEntity(email: 'a@b.com', password: '123456');

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
    test('success → returns Success<UserCredential>', () async {
      when(() => mockService.signIn(any(), any()))
          .thenAnswer((_) async => MockUserCredential());

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Success<UserCredential>>());
      verify(() => mockService.signIn('a@b.com', '123456')).called(1);
    });

    test('exception → returns Failure', () async {
      when(() => mockService.signIn(any(), any()))
          .thenThrow(Exception('auth error'));

      final result = await sut.signIn(_loginEntity());

      expect(result, isA<Failure<UserCredential>>());
    });
  });

  group('signUp', () {
    test('success → returns Success<UserCredential>', () async {
      when(() => mockService.signUp(any(), any()))
          .thenAnswer((_) async => MockUserCredential());

      final result = await sut.signUp(_registerEntity());

      expect(result, isA<Success<UserCredential>>());
      verify(() => mockService.signUp('a@b.com', '123456')).called(1);
    });

    test('exception → returns Failure', () async {
      when(() => mockService.signUp(any(), any()))
          .thenThrow(Exception('auth error'));

      final result = await sut.signUp(_registerEntity());

      expect(result, isA<Failure<UserCredential>>());
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
      when(() => mockService.deleteAccount())
          .thenThrow(Exception('auth error'));

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
      when(() => mockService.sendEmailVerification())
          .thenThrow(Exception('auth error'));

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
    test('delegates to service — user present', () {
      final user = MockUser();
      when(() => mockService.currentUser).thenReturn(user);

      expect(sut.currentUser, same(user));
      verify(() => mockService.currentUser).called(1);
    });

    test('delegates to service — no user', () {
      when(() => mockService.currentUser).thenReturn(null);

      expect(sut.currentUser, isNull);
    });
  });

  group('authStateChanges', () {
    test('delegates stream to service', () {
      final stream = Stream<User?>.value(null);
      when(() => mockService.authStateChanges()).thenAnswer((_) => stream);

      expect(sut.authStateChanges(), same(stream));
      verify(() => mockService.authStateChanges()).called(1);
    });
  });
}
