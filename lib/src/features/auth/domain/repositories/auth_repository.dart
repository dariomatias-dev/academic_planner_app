import 'package:firebase_auth/firebase_auth.dart';

import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';

abstract class AuthRepository {
  User? get currentUser;

  Future<UserCredential> signIn(LoginEntity entity);

  Future<UserCredential> signUp(RegisterEntity entity);

  Future<void> signOut();

  Future<void> deleteAccount();

  Stream<User?> authStateChanges();

  Future<void> sendEmailVerification();

  Future<void> reloadUser();
}
