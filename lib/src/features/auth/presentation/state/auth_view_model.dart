import 'package:firebase_auth/firebase_auth.dart';

import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';

class AuthViewModel {
  final AuthRepository repository;

  User? user;
  String? error;
  bool isEmailVerified = false;

  AuthViewModel(this.repository);

  bool get isAuthenticated => user != null && isEmailVerified;

  Future<void> loadUser() async {
    final current = repository.currentUser;

    if (current != null) {
      await current.reload();
      isEmailVerified = current.emailVerified;
    }

    user = current;
  }

  Future<void> signIn(String email, String password) async {
    error = null;

    try {
      await repository.signIn(email, password);

      final current = repository.currentUser;

      if (current != null) {
        await current.reload();

        if (!current.emailVerified) {
          await repository.signOut();

          throw Exception('Email não verificado');
        }

        isEmailVerified = true;
        user = current;
      }
    } catch (err) {
      error = err.toString();
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    error = null;

    try {
      await repository.signUp(email, password);

      user = null;
    } catch (err) {
      error = err.toString();

      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    final current = repository.currentUser;

    if (current != null && !current.emailVerified) {
      await current.sendEmailVerification();
    }
  }

  Future<void> reloadUser() async {
    final current = repository.currentUser;

    if (current != null) {
      await current.reload();

      isEmailVerified = current.emailVerified;
      user = current;
    }
  }

  Future<void> signOut() async {
    await repository.signOut();

    user = null;
    isEmailVerified = false;
  }
}
