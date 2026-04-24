import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/presentation/state/user_view_model.dart';

class UserNotifier extends AsyncNotifier<UserEntity?> {
  late final UserViewModel viewModel;

  @override
  Future<UserEntity?> build() async {
    final userRepository = ref.read(userRepositoryProvider);

    viewModel = UserViewModel(userRepository);

    ref.listen(authNotifierProvider, (prev, next) {
      next.whenData((firebaseUser) async {
        if (firebaseUser != null) {
          state = const AsyncLoading();

          await viewModel.loadUser(firebaseUser.id);

          state = AsyncData(viewModel.user);
        } else {
          state = const AsyncData(null);
        }
      });
    });

    final firebaseUser = ref.read(authNotifierProvider).value;

    if (firebaseUser != null) {
      await viewModel.loadUser(firebaseUser.id);

      return viewModel.user;
    }

    return null;
  }

  Future<void> updateProfile(UserEntity updatedUser) async {
    state = const AsyncLoading();

    try {
      await viewModel.updateUser(updatedUser);

      state = AsyncData(viewModel.user);
    } catch (err, stack) {
      state = AsyncError(err, stack);
    }
  }

  Future<void> deleteAccount() async {
    final currentUser = state.value;

    if (currentUser == null) return;

    state = const AsyncLoading();

    try {
      await viewModel.deleteUser(currentUser.id);

      state = const AsyncData(null);
    } catch (err, stack) {
      state = AsyncError(err, stack);
    }
  }

  Future<void> refresh() async {
    final firebaseUser = ref.read(authNotifierProvider).value;

    if (firebaseUser == null) return;

    state = const AsyncLoading();

    try {
      await viewModel.loadUser(firebaseUser.id);

      state = AsyncData(viewModel.user);
    } catch (err, stack) {
      state = AsyncError(err, stack);
    }
  }
}
