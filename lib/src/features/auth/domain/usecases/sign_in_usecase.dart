import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/auth/domain/usecases/auth_session_outcome.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';
import 'package:logging/logging.dart';

class SignInUseCase {
  SignInUseCase({required this.authRepository, required this.userRepository});

  static final _log = Logger('auth.SignInUseCase');

  final AuthRepository authRepository;
  final UserRepository userRepository;

  Future<Result<AuthSessionOutcome?>> call(LoginEntity entity) async {
    _log.info('signIn started: ${entity.email}');

    final result = await authRepository.signIn(entity);

    return result.fold<Future<Result<AuthSessionOutcome?>>>(
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

          final userResult = await userRepository.getById(refreshed.uid);

          return userResult.fold(
            onSuccess: (userData) {
              _log.info('signIn success: ${entity.email}');

              return Success(AuthSessionOutcome(userData));
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
}
