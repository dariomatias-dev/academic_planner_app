import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';

class AuthSessionOutcome {
  const AuthSessionOutcome(this.user);

  final UserEntity? user;
}
