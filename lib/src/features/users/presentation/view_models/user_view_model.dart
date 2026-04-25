import 'package:academic_planner/src/core/logging/logger_service.dart';

import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';

class UserViewModel {
  UserViewModel(this._repository, this._logger);

  final UserRepository _repository;
  final LoggerService _logger;

  UserEntity? user;
  String? error;

  Future<void> loadUser(String uid) async {
    error = null;

    try {
      _logger.info('loadUser started: $uid');

      user = await _repository.getById(uid);

      if (user == null) {
        _logger.warning('User not found: $uid');
      } else {
        _logger.info('User loaded: ${user!.id}');
      }
    } catch (err, stackTrace) {
      error = err.toString();

      _logger.error('loadUser error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<List<UserEntity>> listUsers({String? query, UserRole? role}) async {
    error = null;

    try {
      _logger.info('listUsers started: role=$role, query=$query');

      final result = await _repository.getAll(role: role, query: query);

      _logger.info('listUsers success: ${result.length} users found');

      return result;
    } catch (err, stackTrace) {
      error = err.toString();

      _logger.error('listUsers error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<void> updateUser(UserEntity updatedUser) async {
    error = null;

    try {
      _logger.info('updateUser started: ${updatedUser.id}');

      await _repository.update(updatedUser);

      user = updatedUser;

      _logger.info('updateUser success: ${updatedUser.id}');
    } catch (err, stackTrace) {
      error = err.toString();

      _logger.error('updateUser error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    error = null;

    try {
      _logger.info('deleteUser started: $uid');

      await _repository.delete(uid);

      user = null;

      _logger.info('deleteUser success: $uid');
    } catch (err, stackTrace) {
      error = err.toString();

      _logger.error('deleteUser error', error: err, stackTrace: stackTrace);

      rethrow;
    }
  }
}
