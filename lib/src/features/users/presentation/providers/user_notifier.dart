import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/logging/logger_provider.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/presentation/view_models/user_view_model.dart';

class UserNotifier extends AsyncNotifier<UserEntity?> {
  late final UserViewModel viewModel;

  @override
  Future<UserEntity?> build() async {
    final userRepository = ref.read(userRepositoryProvider);

    viewModel = UserViewModel(userRepository, ref.read(loggerProvider));

    ref.listen(authNotifierProvider, (prev, next) {
      next.when(
        data: (firebaseUser) async {
          if (firebaseUser != null) {
            state = const AsyncLoading();

            final result = await userRepository.getById(firebaseUser.id);

            state = result.fold(
              onSuccess: (user) => AsyncData(user),
              onFailure: (f) => AsyncError(f, StackTrace.current),
            );
          } else {
            state = const AsyncData(null);
          }
        },
        error: (err, stack) => state = AsyncError(err, stack),
        loading: () => state = const AsyncLoading(),
      );
    });

    final authState = ref.read(authNotifierProvider);

    if (authState.hasValue && authState.value != null) {
      final result = await userRepository.getById(authState.value!.id);

      return result.fold(onSuccess: (user) => user, onFailure: (f) => throw f);
    }

    return null;
  }

  Future<Result<void>> updateProfile(UserEntity updatedUser) async {
    state = const AsyncLoading();

    final result = await ref.read(userRepositoryProvider).update(updatedUser);

    state = result.fold(
      onSuccess: (_) => AsyncData(updatedUser),
      onFailure: (f) => AsyncError(f, StackTrace.current),
    );

    return result;
  }

  Future<Result<void>> deleteAccount() async {
    final currentUser = state.value;

    if (currentUser == null) return const Success(null);

    state = const AsyncLoading();

    final result = await ref
        .read(userRepositoryProvider)
        .delete(currentUser.id);

    state = result.fold(
      onSuccess: (_) => const AsyncData(null),
      onFailure: (f) => AsyncError(f, StackTrace.current),
    );

    return result;
  }

  Future<Result<void>> refresh() async {
    final authState = ref.read(authNotifierProvider);

    if (!authState.hasValue || authState.value == null) return const Success(null);

    state = const AsyncLoading();

    final result = await ref
        .read(userRepositoryProvider)
        .getById(authState.value!.id);

    state = result.fold(
      onSuccess: (user) => AsyncData(user),
      onFailure: (f) => AsyncError(f, StackTrace.current),
    );

    return result;
  }
}
