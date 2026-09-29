import 'dart:async';

import 'package:academic_planner/src/core/errors/result.dart';
import 'package:academic_planner/src/features/auth/domain/entities/auth_user_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';

/// In-memory [AuthRepository] that stands in for Firebase Auth, so the app
/// can run in an integration test without a Firebase project or network.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AuthUserEntity? signedInUser}) : _user = signedInUser;

  final _changes = StreamController<AuthUserEntity?>.broadcast();
  AuthUserEntity? _user;

  @override
  AuthUserEntity? get currentUser => _user;

  @override
  Stream<AuthUserEntity?> authStateChanges() => _changes.stream;

  @override
  Future<Result<void>> signIn(LoginEntity entity) async => const Success(null);

  @override
  Future<Result<AuthUserEntity?>> signUp(RegisterEntity entity) async {
    return const Success(null);
  }

  @override
  Future<Result<AuthUserEntity?>> signInWithGoogle() async {
    return Success(_user);
  }

  @override
  Future<Result<void>> signOut() async {
    _user = null;
    _changes.add(null);

    return const Success(null);
  }

  @override
  Future<Result<void>> deleteAccount() async => const Success(null);

  @override
  Future<Result<void>> sendEmailVerification() async => const Success(null);

  @override
  Future<Result<void>> reloadUser() async => const Success(null);
}
