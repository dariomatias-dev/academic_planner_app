import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<void> create(UserEntity user);

  Future<UserEntity?> getById(String uid);

  Future<void> update(UserEntity user);

  Future<void> delete(String uid);
}
