import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:academic_planner/src/features/auth/domain/auth_repository.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier(this._repository) {
    _listenAuthState();
  }

  final AuthRepository _repository;

  User? _user;
  bool _isLoading = false;
  bool _isEmailVerified = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null && _isEmailVerified;
  bool get isEmailVerified => _isEmailVerified;

  void _listenAuthState() {
    _repository.authStateChanges().listen((user) async {
      _user = user;

      if (user != null) {
        await user.reload();
        _isEmailVerified = user.emailVerified;
      } else {
        _isEmailVerified = false;
      }

      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    _setLoading(true);

    try {
      await _repository.signIn(email, password);

      final user = _repository.currentUser;

      if (user != null) {
        await user.reload();

        if (!user.emailVerified) {
          await _repository.signOut();
          throw Exception('Email não verificado');
        }

        _user = user;
        _isEmailVerified = true;
      }
    } finally {
      _setLoading(false);
    }

    notifyListeners();
  }

  Future<void> signUp(String email, String password) async {
    _setLoading(true);

    try {
      await _repository.signUp(email, password);
    } finally {
      _setLoading(false);
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

      _user = user;
      _isEmailVerified = user.emailVerified;

      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();

    _user = null;
    _isEmailVerified = false;

    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
