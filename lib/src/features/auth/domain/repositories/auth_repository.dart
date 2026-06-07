import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  User? get currentUser;

  Future<Result<UserCredential>> signIn(LoginEntity entity);

  Future<Result<UserCredential>> signUp(RegisterEntity entity);

  Future<Result<void>> signOut();

  Future<Result<void>> deleteAccount();

  Future<Result<void>> sendEmailVerification();

  Future<Result<void>> reloadUser();

  Stream<User?> authStateChanges();
}
