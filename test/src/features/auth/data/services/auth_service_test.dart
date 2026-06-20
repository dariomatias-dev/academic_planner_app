import 'package:academic_planner/src/features/auth/data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late AuthService sut;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    sut = AuthService(mockFirebaseAuth);
  });

  group('signIn', () {
    test('delegates to FirebaseAuth.signInWithEmailAndPassword', () async {
      final credential = MockUserCredential();
      when(
        () => mockFirebaseAuth.signInWithEmailAndPassword(
          email: 'a@b.com',
          password: '123456',
        ),
      ).thenAnswer((_) async => credential);

      final result = await sut.signIn('a@b.com', '123456');

      expect(result, credential);
    });
  });

  group('signUp', () {
    test('delegates to FirebaseAuth.createUserWithEmailAndPassword', () async {
      final credential = MockUserCredential();
      when(
        () => mockFirebaseAuth.createUserWithEmailAndPassword(
          email: 'a@b.com',
          password: '123456',
        ),
      ).thenAnswer((_) async => credential);

      final result = await sut.signUp('a@b.com', '123456');

      expect(result, credential);
    });
  });

  group('sendEmailVerification', () {
    test('user present and unverified → sends verification', () async {
      final mockUser = MockUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.emailVerified).thenReturn(false);
      when(mockUser.sendEmailVerification).thenAnswer((_) async {});

      await sut.sendEmailVerification();

      verify(mockUser.sendEmailVerification).called(1);
    });

    test('user already verified → does not send verification', () async {
      final mockUser = MockUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.emailVerified).thenReturn(true);

      await sut.sendEmailVerification();

      verifyNever(mockUser.sendEmailVerification);
    });

    test('no current user → does nothing', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      await sut.sendEmailVerification();
    });
  });

  group('reloadUser', () {
    test('current user present → reloads', () async {
      final mockUser = MockUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.reload).thenAnswer((_) async {});

      await sut.reloadUser();

      verify(mockUser.reload).called(1);
    });

    test('no current user → does nothing', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      await sut.reloadUser();
    });
  });

  group('currentUser', () {
    test('returns FirebaseAuth.currentUser', () {
      final mockUser = MockUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

      expect(sut.currentUser, mockUser);
    });
  });

  group('isEmailVerified', () {
    test('true when current user is verified', () {
      final mockUser = MockUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.emailVerified).thenReturn(true);

      expect(sut.isEmailVerified, isTrue);
    });

    test('false when there is no current user', () {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      expect(sut.isEmailVerified, isFalse);
    });
  });

  group('signOut', () {
    test('delegates to FirebaseAuth.signOut', () async {
      when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      await sut.signOut();

      verify(() => mockFirebaseAuth.signOut()).called(1);
    });
  });

  group('deleteAccount', () {
    test('current user present → deletes account', () async {
      final mockUser = MockUser();
      when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.delete).thenAnswer((_) async {});

      await sut.deleteAccount();

      verify(mockUser.delete).called(1);
    });

    test('no current user → does nothing', () async {
      when(() => mockFirebaseAuth.currentUser).thenReturn(null);

      await sut.deleteAccount();
    });
  });

  group('authStateChanges', () {
    test('delegates to FirebaseAuth.authStateChanges', () {
      final mockUser = MockUser();
      final stream = Stream<User?>.value(mockUser);
      when(() => mockFirebaseAuth.authStateChanges()).thenAnswer((_) => stream);

      expect(sut.authStateChanges(), emits(mockUser));
    });
  });
}
