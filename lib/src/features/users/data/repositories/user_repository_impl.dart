import 'package:academic_planner/src/core/result/exception_mapper.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/users/data/models/user_model.dart';
import 'package:academic_planner/src/features/users/data/services/user_firestore_service.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserFirestoreService _service;

  UserRepositoryImpl(this._service);

  @override
  Future<Result<void>> create(UserEntity user) async {
    try {
      final model = UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      );

      await _service.saveUser(model);

      return const Success(null);
    } catch (err) {
      return FailureResult(ExceptionMapper.map(err));
    }
  }

  @override
  Future<Result<List<UserEntity>>> getAll({
    String? query,
    UserRole? role,
  }) async {
    try {
      final users = await _service.getUsers(query: query, role: role);

      return Success(users);
    } catch (err) {
      return FailureResult(ExceptionMapper.map(err));
    }
  }

  @override
  Future<Result<UserEntity?>> getById(String uid) async {
    try {
      final doc = await _service.getUserDoc(uid);

      if (doc.exists) {
        final user = UserModel.fromMap(doc.data() as Map<String, dynamic>);

        return Success(user);
      }

      return const Success(null);
    } catch (err) {
      return FailureResult(ExceptionMapper.map(err));
    }
  }

  @override
  Future<Result<void>> update(UserEntity user) async {
    try {
      final model = UserModel(
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
      );

      await _service.updateUser(model);

      return const Success(null);
    } catch (err) {
      return FailureResult(ExceptionMapper.map(err));
    }
  }

  @override
  Future<Result<void>> delete(String uid) async {
    try {
      await _service.deleteUser(uid);

      return const Success(null);
    } catch (err) {
      return FailureResult(ExceptionMapper.map(err));
    }
  }
}
