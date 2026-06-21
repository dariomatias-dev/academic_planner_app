import 'package:academic_planner/src/core/result/exception_mapper.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/data/models/login_model.dart';
import 'package:academic_planner/src/features/auth/data/models/register_model.dart';
import 'package:academic_planner/src/features/auth/data/services/auth_service.dart';
import 'package:academic_planner/src/features/auth/domain/entities/auth_user_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._service);

  final AuthService _service;

  @override
  AuthUserEntity? get currentUser => _toEntity(_service.currentUser);

  @override
  Future<Result<void>> signIn(LoginEntity entity) async {
    try {
      final model = LoginModel.fromEntity(entity);

      await _service.signIn(model.email, model.password);

      return const Success(null);
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapAuth(err));
    }
  }

  @override
  Future<Result<AuthUserEntity?>> signUp(RegisterEntity entity) async {
    try {
      final model = RegisterModel.fromEntity(entity);

      final credential = await _service.signUp(model.email, model.password);

      return Success(_toEntity(credential.user));
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapAuth(err));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _service.signOut();

      return const Success(null);
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapAuth(err));
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      await _service.deleteAccount();

      return const Success(null);
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapAuth(err));
    }
  }

  @override
  Future<Result<void>> sendEmailVerification() async {
    try {
      await _service.sendEmailVerification();

      return const Success(null);
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapAuth(err));
    }
  }

  @override
  Future<Result<void>> reloadUser() async {
    try {
      await _service.reloadUser();

      return const Success(null);
    } on Exception catch (err) {
      return Failure(ExceptionMapper.mapAuth(err));
    }
  }

  @override
  Stream<AuthUserEntity?> authStateChanges() {
    return _service.authStateChanges().map(_toEntity);
  }

  AuthUserEntity? _toEntity(User? user) {
    if (user == null) return null;

    return AuthUserEntity(uid: user.uid, emailVerified: user.emailVerified);
  }
}
