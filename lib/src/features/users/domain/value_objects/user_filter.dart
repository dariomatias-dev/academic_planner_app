import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';

class UserFilter {
  final String query;
  final UserRole? role;

  UserFilter({this.query = '', this.role});

  UserFilter copyWith({
    String? query,
    UserRole? role,
    bool clearRole = false,
  }) {
    return UserFilter(
      query: query ?? this.query,
      role: clearRole ? null : (role ?? this.role),
    );
  }
}
