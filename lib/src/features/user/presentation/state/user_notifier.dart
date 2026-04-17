import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/user/di/user_providers.dart';
import 'package:academic_planner/src/features/user/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/user/presentation/state/user_view_model.dart';

class UserNotifier extends AsyncNotifier<UserEntity?> {
  late final UserViewModel viewModel;

  @override
  Future<UserEntity?> build() async {
    final repository = ref.read(userRepositoryProvider);
    final authRepository = ref.read(authRepositoryProvider);

    viewModel = UserViewModel(repository);

    final currentUser = authRepository.currentUser;

    if (currentUser != null) {
      await viewModel.loadUser(currentUser.uid);

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
    final currentUser = viewModel.user;
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
    final currentUser = ref.read(authRepositoryProvider).currentUser;
    if (currentUser == null) return;

    state = const AsyncLoading();

    try {
      await viewModel.loadUser(currentUser.uid);

      state = AsyncData(viewModel.user);
    } catch (err, stack) {
      state = AsyncError(err, stack);
    }
  }
}
