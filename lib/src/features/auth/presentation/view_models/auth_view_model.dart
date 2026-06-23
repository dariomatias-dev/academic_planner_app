import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';
import 'package:logging/logging.dart';

class AuthViewModel {
  AuthViewModel({
    required this.authRepository,
    required this.userRepository,
  });

  static final _log = Logger('auth.AuthViewModel');

  final AuthRepository authRepository;
  final UserRepository userRepository;

  UserEntity? user;
  bool isEmailVerified = false;

  Future<Result<UserEntity?>> restoreSession() async {
    _log.info('restoreSession started');

    final current = authRepository.currentUser;

    if (current == null) return const Success(null);

    final reloadResult = await authRepository.reloadUser();

    if (reloadResult case Failure(failure: final f)) {
      _log.warning('restoreSession: reloadUser failed: ${f.message}');

      return Failure(f);
    }

    final refreshed = authRepository.currentUser ?? current;

    if (!refreshed.emailVerified) {
      await authRepository.signOut();

      _log.info('restoreSession: email not verified, signed out');

      return const Success(null);
    }

    final result = await userRepository.getById(refreshed.uid);

    return result.fold(
      onSuccess: (userData) {
        user = userData;
        isEmailVerified = true;

        _log.info('restoreSession success');

        return Success(userData);
      },
      onFailure: (f) {
        _log.warning('restoreSession: getById failed: ${f.message}');

        return Failure(f);
      },
    );
  }

  Future<Result<void>> signIn(LoginEntity entity) async {
    _log.info('signIn started: ${entity.email}');

    final result = await authRepository.signIn(entity);

    return result.fold<Future<Result<void>>>(
      onSuccess: (_) async {
        try {
          final current = authRepository.currentUser;

          if (current == null) {
            _log.warning('signIn: currentUser is null');

            return const Success(null);
          }

          final reloadResult = await authRepository.reloadUser();

          if (reloadResult case Failure(failure: final f)) {
            _log.warning('signIn: reloadUser failed: ${f.message}');

            return Failure(f);
          }

          final refreshed = authRepository.currentUser ?? current;

          if (!refreshed.emailVerified) {
            await authRepository.signOut();

            _log.warning('Email not verified: ${entity.email}');

            return const Failure(AuthFailure('Email não verificado'));
          }

          isEmailVerified = true;

          final userResult = await userRepository.getById(refreshed.uid);

          return userResult.fold(
            onSuccess: (userData) {
              user = userData;

              _log.info('signIn success: ${entity.email}');

              return const Success(null);
            },
            onFailure: Failure.new,
          );
        } on Exception catch (err, stack) {
          _log.severe('signIn processing error', err, stack);

          return const Failure(UnknownFailure('Erro ao processar login'));
        }
      },
      onFailure: (f) async {
        _log.warning('signIn failed: ${f.message}');

        return Failure(f);
      },
    );
  }

  Future<Result<void>> signInWithGoogle() async {
    _log.info('signInWithGoogle started');

    final result = await authRepository.signInWithGoogle();

    return result.fold<Future<Result<void>>>(
      onSuccess: (authUser) async {
        try {
          if (authUser == null) {
            _log.info('signInWithGoogle: cancelled by user');

            return const Success(null);
          }

          isEmailVerified = true;

          final existingResult = await userRepository.getById(authUser.uid);

          return await existingResult.fold<Future<Result<void>>>(
            onSuccess: (existingUser) async {
              if (existingUser != null) {
                user = existingUser;

                _log.info('signInWithGoogle success: existing user');

                return const Success(null);
              }

              final newUser = UserEntity(
                id: authUser.uid,
                email: authUser.email ?? '',
                name: authUser.displayName ?? '',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );

              final createResult = await userRepository.create(newUser);

              return createResult.fold(
                onSuccess: (_) {
                  user = newUser;

                  _log.info('signInWithGoogle success: new user created');

                  return const Success(null);
                },
                onFailure: Failure.new,
              );
            },
            onFailure: (f) async {
              _log.warning('signInWithGoogle: getById failed: ${f.message}');

              return Failure(f);
            },
          );
        } on Exception catch (err, stack) {
          _log.severe('signInWithGoogle processing error', err, stack);

          return const Failure(
            UnknownFailure('Erro ao processar login com Google'),
          );
        }
      },
      onFailure: (f) async {
        _log.warning('signInWithGoogle failed: ${f.message}');

        return Failure(f);
      },
    );
  }

  Future<Result<void>> signUp(RegisterEntity entity) async {
    _log.info('signUp started: ${entity.email}');

    final result = await authRepository.signUp(entity);

    return result.fold<Future<Result<void>>>(
      onSuccess: (authUser) async {
        try {
          if (authUser != null) {
            final newUser = UserEntity(
              id: authUser.uid,
              email: entity.email,
              name: entity.name,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );

            await userRepository.create(newUser);
            await authRepository.sendEmailVerification();

            _log.info('User created and verification sent: ${entity.email}');
          } else {
            _log.warning('signUp: authUser is null');
          }

          await authRepository.signOut();

          user = null;
          isEmailVerified = false;

          _log.info('signUp completed: ${entity.email}');

          return const Success(null);
        } on Exception catch (err, stack) {
          _log.severe('signUp processing error', err, stack);

          return const Failure(
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
