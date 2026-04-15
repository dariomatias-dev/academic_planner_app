import 'package:academic_planner/src/features/auth/providers/auth_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/auth/domain/auth_repository.dart';

class AuthNotifier extends AsyncNotifier<User?> {
  late final AuthRepository _repository;

  bool _isEmailVerified = false;

  bool get isEmailVerified => _isEmailVerified;

  bool get isAuthenticated => state.value != null && _isEmailVerified;

  @override
  Future<User?> build() async {
    _repository = ref.read(authRepositoryProvider);

    final user = _repository.currentUser;

    if (user != null) {
      await user.reload();
      _isEmailVerified = user.emailVerified;
    }

    _repository.authStateChanges().listen((user) async {
      if (user != null) {
        await user.reload();
        _isEmailVerified = user.emailVerified;
      } else {
        _isEmailVerified = false;
      }

      state = AsyncData(user);
    });

    return user;
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();

    try {
      await _repository.signIn(email, password);

      final user = _repository.currentUser;

      if (user != null) {
        await user.reload();

        if (!user.emailVerified) {
          await _repository.signOut();
          throw Exception('Email não verificado');
        }

        _isEmailVerified = true;
        state = AsyncData(user);
      }
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();

    try {
      await _repository.signUp(email, password);

      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    final user = _repository.currentUser;

    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> reloadUser() async {
    final user = _repository.currentUser;

    if (user != null) {
      await user.reload();

      _isEmailVerified = user.emailVerified;
      state = AsyncData(user);
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();

    _isEmailVerified = false;
    state = const AsyncData(null);
  }
}
