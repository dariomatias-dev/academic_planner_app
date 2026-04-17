import 'package:academic_planner/src/features/user/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/user/domain/repositories/user_repository.dart';

class UserViewModel {
  UserViewModel(this._repository);

  final UserRepository _repository;

  UserEntity? user;
  String? error;

  Future<void> loadUser(String uid) async {
    error = null;

    try {
      user = await _repository.getById(uid);
    } catch (err) {
      error = err.toString();

      rethrow;
    }
  }

  Future<void> updateUser(UserEntity updatedUser) async {
    error = null;

    try {
      await _repository.update(updatedUser);

      user = updatedUser;
    } catch (err) {
      error = err.toString();

      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    error = null;

    try {
      await _repository.delete(uid);

      user = null;
    } catch (err) {
      error = err.toString();

      rethrow;
    }
  }
}
