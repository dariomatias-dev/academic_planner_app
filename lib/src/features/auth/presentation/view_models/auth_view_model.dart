import 'package:logging/logging.dart';

import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';

class AuthViewModel {
  static final _log = Logger('auth.AuthViewModel');

  final AuthRepository authRepository;
  final UserRepository userRepository;

  UserEntity? user;
  bool isEmailVerified = false;

  AuthViewModel({
    required this.authRepository,
    required this.userRepository,
  });

  Future<Result<void>> signIn(LoginEntity entity) async {
    _log.info('signIn started: ${entity.email}');

    final result = await authRepository.signIn(entity);

    return await result.fold<Future<Result<void>>>(
      onSuccess: (_) async {
        try {
          final current = authRepository.currentUser;

          if (current == null) {
            _log.warning('signIn: currentUser is null');

            return const Success(null);
          }

          await current.reload();

          if (!current.emailVerified) {
            await authRepository.signOut();

            _log.warning('Email not verified: ${entity.email}');

            return const Failure(AuthFailure('Email não verificado'));
          }

          isEmailVerified = true;

          final userResult = await userRepository.getById(current.uid);

          return userResult.fold(
            onSuccess: (userData) {
              user = userData;

              _log.info('signIn success: ${entity.email}');

              return const Success(null);
            },
            onFailure: (f) => Failure(f),
          );
        } catch (err, stack) {
          _log.severe('signIn processing error', err, stack);

          return Failure(UnknownFailure('Erro ao processar login'));
        }
      },
      onFailure: (f) async {
        _log.warning('signIn failed: ${f.message}');

        return Failure(f);
      },
    );
  }

  Future<Result<void>> signUp(RegisterEntity entity) async {
    _log.info('signUp started: ${entity.email}');

    final result = await authRepository.signUp(entity);

    return await result.fold<Future<Result<void>>>(
      onSuccess: (credential) async {
        try {
          final firebaseUser = credential.user;

          if (firebaseUser != null) {
            final newUser = UserEntity(
              id: firebaseUser.uid,
              email: entity.email,
              name: entity.name,
              role: UserRole.student,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            await userRepository.create(newUser);
            await firebaseUser.sendEmailVerification();

            _log.info('User created and verification sent: ${entity.email}');
          } else {
            _log.warning('signUp: firebaseUser is null');
          }

          await authRepository.signOut();

          user = null;
          isEmailVerified = false;

          _log.info('signUp completed: ${entity.email}');

          return const Success(null);
        } catch (err, stack) {
          _log.severe('signUp processing error', err, stack);

          return Failure(
            UnknownFailure('Erro ao processar cadastro'),
          );
        }
      },
      onFailure: (f) async {
        _log.warning('signUp failed: ${f.message}');

        return Failure(f);
      },
    );
  }

  Future<Result<void>> signOut() async {
    _log.info('signOut started');

    final result = await authRepository.signOut();

    return result.fold(
      onSuccess: (_) {
        user = null;
        isEmailVerified = false;

        _log.info('signOut success');

        return const Success(null);
      },
      onFailure: (f) {
        _log.warning('signOut failed: ${f.message}');
        return Failure(f);
      },
    );
  }

  Future<Result<void>> deleteAccount() async {
    _log.info('deleteAccount started');

    final result = await authRepository.deleteAccount();

    return result.fold(
      onSuccess: (_) {
        user = null;
        isEmailVerified = false;

        _log.info('deleteAccount success');

        return const Success(null);
      },
      onFailure: (f) {
        _log.warning('deleteAccount failed: ${f.message}');

        return Failure(f);
      },
    );
  }

  Future<Result<void>> sendEmailVerification() async {
    _log.info('sendEmailVerification started');

    final result = await authRepository.sendEmailVerification();

    result.when(
      onSuccess: (_) {
        _log.info('sendEmailVerification success');
      },
      onFailure: (f) {
        _log.warning('sendEmailVerification failed: ${f.message}');
      },
    );

    return result;
  }
}
