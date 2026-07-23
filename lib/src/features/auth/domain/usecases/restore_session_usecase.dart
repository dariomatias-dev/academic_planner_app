import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/auth/domain/usecases/auth_session_outcome.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';
import 'package:logging/logging.dart';

class RestoreSessionUseCase {
  RestoreSessionUseCase({
    required this.authRepository,
    required this.userRepository,
  });

  static final _log = Logger('auth.RestoreSessionUseCase');

  final AuthRepository authRepository;
  final UserRepository userRepository;

  Future<Result<AuthSessionOutcome?>> call() async {
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
        _log.info('restoreSession success');

        return Success(AuthSessionOutcome(userData));
      },
      onFailure: (f) {
        _log.warning('restoreSession: getById failed: ${f.message}');

        return Failure(f);
      },
    );
  }
}
