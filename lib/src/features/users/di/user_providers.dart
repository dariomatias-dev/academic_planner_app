import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/di/firebase_providers.dart';

import 'package:academic_planner/src/features/users/data/repositories/user_repository_impl.dart';
import 'package:academic_planner/src/features/users/data/services/user_firestore_service.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';
import 'package:academic_planner/src/features/users/domain/value_objects/user_filter.dart';
import 'package:academic_planner/src/features/users/presentation/providers/user_filter_notifier.dart';
import 'package:academic_planner/src/features/users/presentation/providers/user_notifier.dart';
import 'package:academic_planner/src/features/users/presentation/state/user_view_model.dart';

final userFirestoreServiceProvider = Provider<UserFirestoreService>((ref) {
  final firestore = ref.watch(firestoreProvider);

  return UserFirestoreService(firestore);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final service = ref.watch(userFirestoreServiceProvider);

  return UserRepositoryImpl(service);
});

final userNotifierProvider = AsyncNotifierProvider<UserNotifier, UserEntity?>(
  () {
    return UserNotifier();
  },
);

final userFilterProvider = NotifierProvider<UserFilterNotifier, UserFilter>(
  UserFilterNotifier.new,
);

final usersProvider = FutureProvider<List<UserEntity>>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  final filter = ref.watch(userFilterProvider);
  final viewModel = UserViewModel(repository);

  return await viewModel.listUsers(role: filter.role, query: filter.query);
});
