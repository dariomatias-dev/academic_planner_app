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
    _logger.info('loadUser started: $uid');

    final result = await _repository.getById(uid);

    result.fold(
      onSuccess: (value) {
        user = value;

        if (user == null) {
          _logger.warning('User not found: $uid');
        } else {
          _logger.info('User loaded: ${user!.id}');
        }
      },
      onFailure: (failure) {
        error = failure.message;
        _logger.error(
          'loadUser error',
          error: failure.message,
          stackTrace: null,
        );
      },
    );
  }

  Future<List<UserEntity>> listUsers({String? query, UserRole? role}) async {
    error = null;

    _logger.info('listUsers started: role=$role, query=$query');

    final result = await _repository.getAll(role: role, query: query);

    return result.fold(
      onSuccess: (value) {
        _logger.info('listUsers success: ${value.length} users found');

        return value;
      },
      onFailure: (failure) {
        error = failure.message;

        _logger.error(
          'listUsers error',
          error: failure.message,
          stackTrace: null,
        );

        return <UserEntity>[];
      },
    );
  }

  Future<void> updateUser(UserEntity updatedUser) async {
    error = null;

    _logger.info('updateUser started: ${updatedUser.id}');

    final result = await _repository.update(updatedUser);

    result.fold(
      onSuccess: (_) {
        user = updatedUser;

        _logger.info('updateUser success: ${updatedUser.id}');
      },
      onFailure: (failure) {
        error = failure.message;

        _logger.error(
          'updateUser error',
          error: failure.message,
          stackTrace: null,
        );
      },
    );
  }

  Future<void> deleteUser(String uid) async {
    error = null;

    _logger.info('deleteUser started: $uid');

    final result = await _repository.delete(uid);

    result.fold(
      onSuccess: (_) {
        user = null;

        _logger.info('deleteUser success: $uid');
      },
      onFailure: (failure) {
        error = failure.message;

        _logger.error(
          'deleteUser error',
          error: failure.message,
          stackTrace: null,
        );
      },
    );
  }
}
