import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/domain/entities/auth_user_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';

abstract class AuthRepository {
  AuthUserEntity? get currentUser;

  Future<Result<void>> signIn(LoginEntity entity);

  Future<Result<AuthUserEntity?>> signUp(RegisterEntity entity);

  Future<Result<void>> signOut();

  Future<Result<void>> deleteAccount();

  Future<Result<void>> sendEmailVerification();

  Future<Result<void>> reloadUser();

  Stream<AuthUserEntity?> authStateChanges();
}
