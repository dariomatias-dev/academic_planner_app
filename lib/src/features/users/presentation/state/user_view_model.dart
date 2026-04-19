import 'package:logger/logger.dart';

import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';

class UserViewModel {
  UserViewModel(this._repository);

  final UserRepository _repository;
  final Logger _logger = Logger();

  UserEntity? user;
  String? error;

  Future<void> loadUser(String uid) async {
    error = null;

    try {
      _logger.i('loadUser started: $uid');

      user = await _repository.getById(uid);

      if (user == null) {
        _logger.w('User not found: $uid');
      } else {
        _logger.i('User loaded: ${user!.id}');
      }
    } catch (err, stackTrace) {
      error = err.toString();

      _logger.e('loadUser error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<void> updateUser(UserEntity updatedUser) async {
    error = null;

    try {
      _logger.i('updateUser started: ${updatedUser.id}');

      await _repository.update(updatedUser);

      user = updatedUser;

      _logger.i('updateUser success: ${updatedUser.id}');
    } catch (err, stackTrace) {
      error = err.toString();

      _logger.e('updateUser error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    error = null;

    try {
      _logger.i('deleteUser started: $uid');

      await _repository.delete(uid);

      user = null;

      _logger.i('deleteUser success: $uid');
    } catch (err, stackTrace) {
      error = err.toString();

      _logger.e('deleteUser error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }
}
