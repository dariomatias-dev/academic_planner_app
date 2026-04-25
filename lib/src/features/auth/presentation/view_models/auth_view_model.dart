import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/core/result/failure.dart';

import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';

import 'package:academic_planner/src/shared/utils/app_logger.dart';

class AuthViewModel {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  UserEntity? user;
  bool isEmailVerified = false;

  AuthViewModel({required this.authRepository, required this.userRepository});

  Future<Result<void>> signIn(LoginEntity entity) async {
    AppLogger.info('signIn started: ${entity.email}');

    final result = await authRepository.signIn(entity);

    return result.fold(
      onSuccess: (_) async {
        try {
          final current = authRepository.currentUser;

          if (current != null) {
            await current.reload();

            if (!current.emailVerified) {
              await authRepository.signOut();

              AppLogger.warning('Email not verified: ${entity.email}');

              return FailureResult(AuthFailure('Email não verificado'));
            }

            isEmailVerified = true;

            user = await userRepository.getById(current.uid);

            AppLogger.info('signIn success: ${entity.email}');
          } else {
            AppLogger.warning('signIn: currentUser is null');
          }

          return const Success(null);
        } catch (err, stack) {
          AppLogger.error('signIn processing error', err, stack);

          return FailureResult(UnknownFailure('Erro ao processar login', err));
        }
      },
      onFailure: (f) {
        AppLogger.warning('signIn failed: ${f.message}');
        return FailureResult(f);
      },
    );
  }

  Future<Result<void>> signUp(RegisterEntity entity) async {
    AppLogger.info('signUp started: ${entity.email}');

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

            AppLogger.info(
              'User created and verification sent: ${entity.email}',
            );
          } else {
            AppLogger.warning('signUp: firebaseUser is null');
          }

          await authRepository.signOut();

          user = null;
          isEmailVerified = false;

          AppLogger.info('signUp completed: ${entity.email}');

          return const Success(null);
        } catch (err, stack) {
          AppLogger.error('signUp processing error', err, stack);

          return FailureResult(
            UnknownFailure('Erro ao processar cadastro', err),
          );
        }
      },
      onFailure: (f) {
        AppLogger.warning('signUp failed: ${f.message}');
        return FailureResult(f);
      },
    );
  }

  Future<Result<void>> signOut() async {
    AppLogger.info('signOut started');

    final result = await authRepository.signOut();

    return result.fold(
      onSuccess: (_) {
        user = null;
        isEmailVerified = false;

        AppLogger.info('signOut success');

        return const Success(null);
      },
      onFailure: (f) {
        AppLogger.warning('signOut failed: ${f.message}');
        return FailureResult(f);
      },
    );
  }

  Future<Result<void>> deleteAccount() async {
    AppLogger.info('deleteAccount started');

    final result = await authRepository.deleteAccount();

    return result.fold(
      onSuccess: (_) {
        user = null;
        isEmailVerified = false;

        AppLogger.info('deleteAccount success');

        return const Success(null);
      },
      onFailure: (f) {
        AppLogger.warning('deleteAccount failed: ${f.message}');
        return FailureResult(f);
      },
    );
  }

  Future<Result<void>> sendEmailVerification() async {
    AppLogger.info('sendEmailVerification started');

    final result = await authRepository.sendEmailVerification();

    result.when(
      onSuccess: (_) {
        AppLogger.info('sendEmailVerification success');
      },
      onFailure: (f) {
        AppLogger.warning('sendEmailVerification failed: ${f.message}');
      },
    );

    return result;
  }

  Future<Result<void>> registerFlow(RegisterEntity entity) async {
    AppLogger.info('registerFlow started: ${entity.email}');

    final signUpResult = await signUp(entity);

    return signUpResult.fold(
      onSuccess: (_) async {
        final verifyResult = await sendEmailVerification();

        return verifyResult.fold(
          onSuccess: (_) async {
            final signOutResult = await signOut();

            return signOutResult.fold(
              onSuccess: (_) {
                AppLogger.info('registerFlow success: ${entity.email}');

                return const Success(null);
              },
              onFailure: (f) {
                AppLogger.warning('registerFlow signOut failed: ${f.message}');

                return FailureResult(f);
              },
            );
          },
          onFailure: (f) {
            AppLogger.warning('registerFlow verification failed: ${f.message}');

            return FailureResult(f);
          },
        );
      },
      onFailure: (f) {
        AppLogger.warning('registerFlow signUp failed: ${f.message}');

        return FailureResult(f);
      },
    );
  }
}
