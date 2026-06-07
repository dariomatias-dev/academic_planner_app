import 'package:academic_planner/src/core/di/firebase_providers.dart';
import 'package:academic_planner/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:academic_planner/src/features/auth/data/services/auth_service.dart';
import 'package:academic_planner/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:academic_planner/src/features/auth/presentation/providers/auth_notifier.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);

  return AuthService(firebaseAuth);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final service = ref.watch(authServiceProvider);

  return AuthRepositoryImpl(service);
});

final authNotifierProvider = AsyncNotifierProvider<AuthNotifier, UserEntity?>(
  () {
    return AuthNotifier();
  },
);
