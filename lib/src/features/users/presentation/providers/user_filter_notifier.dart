import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/value_objects/user_filter.dart';

class UserFilterNotifier extends Notifier<UserFilter> {
  @override
  UserFilter build() => UserFilter();

  void setQuery(String query) => state = state.copyWith(query: query);

  void setRole(UserRole? role) {
    if (role == null) {
      state = state.copyWith(clearRole: true);
    } else {
      state = state.copyWith(role: role);
    }
  }
}
