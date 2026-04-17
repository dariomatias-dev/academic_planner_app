import 'package:firebase_auth/firebase_auth.dart';

import 'package:academic_planner/src/features/auth/data/services/auth_service.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._service);

  final AuthService _service;

  @override
  User? get currentUser => _service.currentUser;

  @override
  Future<UserCredential> signIn(String email, String password) {
    return _service.signIn(email, password);
  }

  @override
  Future<UserCredential> signUp(String email, String password) {
    return _service.signUp(email, password);
  }

  @override
  Future<void> signOut() {
    return _service.signOut();
  }

  @override
  Future<void> deleteAccount() {
    return _service.deleteAccount();
  }

  @override
  Stream<User?> authStateChanges() {
    return _service.authStateChanges();
  }

  @override
  Future<void> sendEmailVerification() {
    return _service.sendEmailVerification();
  }

  @override
  Future<void> reloadUser() {
    return _service.reloadUser();
  }
}
