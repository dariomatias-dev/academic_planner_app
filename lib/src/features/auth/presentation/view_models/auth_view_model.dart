import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:academic_planner/src/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:academic_planner/src/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:academic_planner/src/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';
import 'package:logging/logging.dart';

class AuthViewModel {
  AuthViewModel({required this.authRepository, required this.userRepository})
    : _restoreSessionUseCase = RestoreSessionUseCase(
        authRepository: authRepository,
        userRepository: userRepository,
      ),
      _signInUseCase = SignInUseCase(
        authRepository: authRepository,
        userRepository: userRepository,
      ),
      _signInWithGoogleUseCase = SignInWithGoogleUseCase(
        authRepository: authRepository,
        userRepository: userRepository,
      ),
      _signUpUseCase = SignUpUseCase(
        authRepository: authRepository,
        userRepository: userRepository,
      );

  static final _log = Logger('auth.AuthViewModel');

  final AuthRepository authRepository;
  final UserRepository userRepository;

  final RestoreSessionUseCase _restoreSessionUseCase;
  final SignInUseCase _signInUseCase;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignUpUseCase _signUpUseCase;

  UserEntity? user;
  bool isEmailVerified = false;

  Future<Result<UserEntity?>> restoreSession() async {
    final result = await _restoreSessionUseCase();

    return result.fold(
      onSuccess: (outcome) {
        if (outcome != null) {
          user = outcome.user;
          isEmailVerified = true;
        }

        return Success(outcome?.user);
      },
      onFailure: Failure.new,
    );
  }

  Future<Result<void>> signIn(LoginEntity entity) async {
    final result = await _signInUseCase(entity);

    return result.fold(
      onSuccess: (outcome) {
        if (outcome != null) {
          user = outcome.user;
          isEmailVerified = true;
        }

        return const Success(null);
      },
      onFailure: Failure.new,
    );
  }

  Future<Result<void>> signInWithGoogle() async {
    final result = await _signInWithGoogleUseCase();

    return result.fold(
      onSuccess: (outcome) {
        if (outcome != null) {
          user = outcome.user;
          isEmailVerified = true;
        }

        return const Success(null);
      },
      onFailure: Failure.new,
    );
  }

  Future<Result<void>> signUp(RegisterEntity entity) async {
    final result = await _signUpUseCase(entity);

    return result.fold(
      onSuccess: (_) {
        user = null;
        isEmailVerified = false;

        return const Success(null);
      },
      onFailure: Failure.new,
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
