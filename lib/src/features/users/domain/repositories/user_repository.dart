import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Result<void>> create(UserEntity user);

  Future<Result<List<UserEntity>>> getAll({String? query, UserRole? role});

  Future<Result<UserEntity?>> getById(String uid);

  Future<Result<void>> update(UserEntity user);

  Future<Result<void>> delete(String uid);
}
