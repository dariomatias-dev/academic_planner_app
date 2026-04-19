import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';

class AuthViewModel {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  final Logger _logger = Logger();

  User? user;
  String? error;
  bool isEmailVerified = false;

  AuthViewModel({required this.authRepository, required this.userRepository});

  Future<void> loadUser() async {
    try {
      _logger.i('loadUser started');

      final current = authRepository.currentUser;

      if (current != null) {
        await current.reload();

        isEmailVerified = current.emailVerified;
      }

      user = current;

      _logger.i('loadUser finished');
    } catch (err, stackTrace) {
      _logger.e('loadUser error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    error = null;

    try {
      _logger.i('signIn started: $email');

      await authRepository.signIn(email, password);

      final current = authRepository.currentUser;

      if (current != null) {
        await current.reload();

        if (!current.emailVerified) {
          await authRepository.signOut();

          _logger.w('Email not verified: $email');

          throw Exception('Email não verificado');
        }

        isEmailVerified = true;
        user = current;
      }

      _logger.i('signIn success: $email');
    } catch (err, stackTrace) {
      error = err.toString();

      _logger.e('signIn error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    error = null;

    try {
      _logger.i('signUp started: $email');

      final credential = await authRepository.signUp(email, password);

      _logger.i('Firebase signUp success: $email');

      final firebaseUser = credential.user;

      if (firebaseUser != null) {
        _logger.i('Creating Firestore user: ${firebaseUser.uid}');

        final newUser = UserEntity(
          id: firebaseUser.uid,
          email: email,
          name: name,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await userRepository.create(newUser);

        _logger.i('Firestore user created: ${firebaseUser.uid}');

        await firebaseUser.sendEmailVerification();

        _logger.i('Email verification sent: $email');
      }

      await authRepository.signOut();

      user = null;
      isEmailVerified = false;

      _logger.i('signUp completed and user signed out: $email');
    } catch (err, stackTrace) {
      error = err.toString();

      _logger.e('signUp error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      _logger.i('signOut');

      await authRepository.signOut();

      user = null;
      isEmailVerified = false;

      _logger.i('signOut success');
    } catch (err, stackTrace) {
      _logger.e('signOut error', error: err, stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    try {
      _logger.i('deleteAccount');

      await authRepository.deleteAccount();

      user = null;
      isEmailVerified = false;

      _logger.i('deleteAccount success');
    } catch (err, stackTrace) {
      _logger.e('deleteAccount error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<void> reloadUser() async {
    try {
      _logger.i('reloadUser');

      final current = authRepository.currentUser;

      if (current != null) {
        await current.reload();

        isEmailVerified = current.emailVerified;
        user = current;
      }

      _logger.i('reloadUser success');
    } catch (err, stackTrace) {
      _logger.e('reloadUser error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      _logger.i('sendEmailVerification');

      await authRepository.sendEmailVerification();

      _logger.i('sendEmailVerification success');
    } catch (err, stackTrace) {
      _logger.e(
        'sendEmailVerification error',
        error: err,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}
