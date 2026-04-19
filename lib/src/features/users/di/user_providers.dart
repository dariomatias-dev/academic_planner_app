import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/di/firebase_providers.dart';

import 'package:academic_planner/src/features/users/data/repositories/user_repository_impl.dart';
import 'package:academic_planner/src/features/users/data/services/user_firestore_service.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/domain/repositories/user_repository.dart';
import 'package:academic_planner/src/features/users/presentation/state/user_notifier.dart';

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
