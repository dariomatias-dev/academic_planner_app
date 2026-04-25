import 'package:academic_planner/src/core/logging/logger_service.dart';
import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';

class AuthViewModel {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final LoggerService _logger;

  UserEntity? user;
  bool isEmailVerified = false;

  AuthViewModel({
    required this.authRepository,
    required this.userRepository,
    required LoggerService logger,
  }) : _logger = logger;

  Future<Result<void>> signIn(LoginEntity entity) async {
    _logger.info('signIn started: ${entity.email}');

    final result = await authRepository.signIn(entity);

    return result.fold(
      onSuccess: (_) async {
        try {
          final current = authRepository.currentUser;

          if (current != null) {
            await current.reload();

            if (!current.emailVerified) {
              await authRepository.signOut();

              _logger.warning('Email not verified: ${entity.email}');

              return FailureResult(AuthFailure('Email não verificado'));
            }

            isEmailVerified = true;

            user = await userRepository.getById(current.uid);

            _logger.info('signIn success: ${entity.email}');
          } else {
            _logger.warning('signIn: currentUser is null');
          }

          return const Success(null);
        } catch (err, stack) {
          _logger.error(
            'signIn processing error',
            error: err,
            stackTrace: stack,
          );

          return FailureResult(UnknownFailure('Erro ao processar login', err));
        }
      },
      onFailure: (f) {
        _logger.warning('signIn failed: ${f.message}');

        return FailureResult(f);
      },
    );
  }

  Future<Result<void>> signUp(RegisterEntity entity) async {
    _logger.info('signUp started: ${entity.email}');

    final result = await authRepository.signUp(entity);

    return result.fold(
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

            _logger.info('User created and verification sent: ${entity.email}');
          } else {
            _logger.warning('signUp: firebaseUser is null');
          }

          await authRepository.signOut();

          user = null;
          isEmailVerified = false;

          _logger.info('signUp completed: ${entity.email}');

          return const Success(null);
        } catch (err, stack) {
          _logger.error(
            'signUp processing error',
            error: err,
            stackTrace: stack,
          );

          return FailureResult(
            UnknownFailure('Erro ao processar cadastro', err),
          );
        }
      },
      onFailure: (f) {
        _logger.warning('signUp failed: ${f.message}');

        return FailureResult(f);
      },
    );
  }

  Future<Result<void>> signOut() async {
    _logger.info('signOut started');

    final result = await authRepository.signOut();

    return result.fold(
      onSuccess: (_) {
        user = null;
        isEmailVerified = false;

        _logger.info('signOut success');

        return const Success(null);
      },
      onFailure: (f) {
        _logger.warning('signOut failed: ${f.message}');
        return FailureResult(f);
      },
    );
  }

  Future<Result<void>> deleteAccount() async {
    _logger.info('deleteAccount started');

    final result = await authRepository.deleteAccount();

    return result.fold(
      onSuccess: (_) {
        user = null;
        isEmailVerified = false;

        _logger.info('deleteAccount success');

        return const Success(null);
      },
      onFailure: (f) {
        _logger.warning('deleteAccount failed: ${f.message}');

        return FailureResult(f);
      },
    );
  }

  Future<Result<void>> sendEmailVerification() async {
    _logger.info('sendEmailVerification started');

    final result = await authRepository.sendEmailVerification();

    result.when(
      onSuccess: (_) {
        _logger.info('sendEmailVerification success');
      },
      onFailure: (f) {
        _logger.warning('sendEmailVerification failed: ${f.message}');
      },
    );

    return result;
  }

  Future<Result<void>> registerFlow(RegisterEntity entity) async {
    _logger.info('registerFlow started: ${entity.email}');

    final signUpResult = await signUp(entity);

    return signUpResult.fold(
      onSuccess: (_) async {
        final verifyResult = await sendEmailVerification();

        return verifyResult.fold(
          onSuccess: (_) async {
            final signOutResult = await signOut();

            return signOutResult.fold(
              onSuccess: (_) {
                _logger.info('registerFlow success: ${entity.email}');

                return const Success(null);
              },
              onFailure: (f) {
                _logger.warning('registerFlow signOut failed: ${f.message}');

                return FailureResult(f);
              },
            );
          },
          onFailure: (f) {
            _logger.warning('registerFlow verification failed: ${f.message}');

            return FailureResult(f);
          },
        );
      },
      onFailure: (f) {
        _logger.warning('registerFlow signUp failed: ${f.message}');

        return FailureResult(f);
      },
    );
  }
}
