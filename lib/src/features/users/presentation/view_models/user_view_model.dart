import 'package:logging/logging.dart';

import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';

class UserViewModel {
  static final _log = Logger('users.UserViewModel');

  UserViewModel(this._repository);

  final UserRepository _repository;

  UserEntity? user;
  String? error;

  Future<void> loadUser(String uid) async {
    error = null;
    _log.info('loadUser started: $uid');

    final result = await _repository.getById(uid);

    result.fold(
      onSuccess: (value) {
        user = value;

        if (user == null) {
          _log.warning('User not found: $uid');
        } else {
          _log.info('User loaded: ${user!.id}');
        }
      },
      onFailure: (failure) {
        error = failure.message;
        _log.severe('loadUser error', failure);
      },
    );
  }

  Future<List<UserEntity>> listUsers({String? query, UserRole? role}) async {
    error = null;

    _log.info('listUsers started: role=$role, query=$query');

    final result = await _repository.getAll(role: role, query: query);

    return result.fold(
      onSuccess: (value) {
        _log.info('listUsers success: ${value.length} users found');

        return value;
      },
      onFailure: (failure) {
        error = failure.message;

        _log.severe('listUsers error', failure);

        return <UserEntity>[];
      },
    );
  }

  Future<void> updateUser(UserEntity updatedUser) async {
    error = null;

    _log.info('updateUser started: ${updatedUser.id}');

    final result = await _repository.update(updatedUser);

    result.fold(
      onSuccess: (_) {
        user = updatedUser;

        _log.info('updateUser success: ${updatedUser.id}');
      },
      onFailure: (failure) {
        error = failure.message;

        _log.severe('updateUser error', failure);
      },
    );
  }

  Future<void> deleteUser(String uid) async {
    error = null;

    _log.info('deleteUser started: $uid');

    final result = await _repository.delete(uid);

    result.fold(
      onSuccess: (_) {
        user = null;

        _log.info('deleteUser success: $uid');
      },
      onFailure: (failure) {
        error = failure.message;

        _log.severe('deleteUser error', failure);
      },
    );
  }
}
