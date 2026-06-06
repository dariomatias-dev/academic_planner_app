import 'package:firebase_auth/firebase_auth.dart';

import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/core/result/exception_mapper.dart';

import 'package:academic_planner/src/features/auth/data/models/login_model.dart';
import 'package:academic_planner/src/features/auth/data/models/register_model.dart';
import 'package:academic_planner/src/features/auth/data/services/auth_service.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._service);

  final AuthService _service;

  @override
  User? get currentUser => _service.currentUser;

  @override
  Future<Result<UserCredential>> signIn(LoginEntity entity) async {
    try {
      final model = LoginModel.fromEntity(entity);

      final credential = await _service.signIn(model.email, model.password);

      return Success(credential);
    } catch (err) {
      return Failure(ExceptionMapper.map(err));
    }
  }

  @override
  Future<Result<UserCredential>> signUp(RegisterEntity entity) async {
    try {
      final model = RegisterModel.fromEntity(entity);

      final credential = await _service.signUp(model.email, model.password);

      return Success(credential);
    } catch (err) {
      return Failure(ExceptionMapper.map(err));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _service.signOut();

      return const Success(null);
    } catch (err) {
      return Failure(ExceptionMapper.map(err));
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      await _service.deleteAccount();

      return const Success(null);
    } catch (err) {
      return Failure(ExceptionMapper.map(err));
    }
  }

  @override
  Future<Result<void>> sendEmailVerification() async {
    try {
      await _service.sendEmailVerification();

      return const Success(null);
    } catch (err) {
      return Failure(ExceptionMapper.map(err));
    }
  }

  @override
  Future<Result<void>> reloadUser() async {
    try {
      await _service.reloadUser();

      return const Success(null);
    } catch (err) {
      return Failure(ExceptionMapper.map(err));
    }
  }

  @override
  Stream<User?> authStateChanges() {
    return _service.authStateChanges();
  }
}
