import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';
import 'package:logging/logging.dart';

class SignUpUseCase {
  SignUpUseCase({required this.authRepository, required this.userRepository});

  static final _log = Logger('auth.SignUpUseCase');

  final AuthRepository authRepository;
  final UserRepository userRepository;

  Future<Result<void>> call(RegisterEntity entity) async {
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
}
