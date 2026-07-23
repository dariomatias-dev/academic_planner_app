import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/auth/domain/usecases/auth_session_outcome.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';
import 'package:logging/logging.dart';

class SignInWithGoogleUseCase {
  SignInWithGoogleUseCase({
    required this.authRepository,
    required this.userRepository,
  });

  static final _log = Logger('auth.SignInWithGoogleUseCase');

  final AuthRepository authRepository;
  final UserRepository userRepository;

  Future<Result<AuthSessionOutcome?>> call() async {
    _log.info('signInWithGoogle started');

    final result = await authRepository.signInWithGoogle();

    return result.fold<Future<Result<AuthSessionOutcome?>>>(
      onSuccess: (authUser) async {
        try {
          if (authUser == null) {
            _log.info('signInWithGoogle: cancelled by user');

            return const Success(null);
          }

          final existingResult = await userRepository.getById(authUser.uid);

          return await existingResult.fold<Future<Result<AuthSessionOutcome?>>>(
            onSuccess: (existingUser) async {
              if (existingUser != null) {
                _log.info('signInWithGoogle success: existing user');

                return Success(AuthSessionOutcome(existingUser));
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
                  _log.info('signInWithGoogle success: new user created');

                  return Success(AuthSessionOutcome(newUser));
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
}
