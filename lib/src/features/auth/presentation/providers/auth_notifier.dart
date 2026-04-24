import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/auth/presentation/state/auth_view_model.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';

class AuthNotifier extends AsyncNotifier<UserEntity?> {
  late final AuthViewModel viewModel;

  @override
  Future<UserEntity?> build() async {
    viewModel = AuthViewModel(
      authRepository: ref.read(authRepositoryProvider),
      userRepository: ref.read(userRepositoryProvider),
    );

    await viewModel.loadUser();

    return viewModel.user;
  }

  Future<void> signIn(LoginEntity entity) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await viewModel.signIn(entity);
      return viewModel.user;
    });
  }

  Future<void> signUp(RegisterEntity entity) async {
    state = const AsyncLoading();

    await AsyncValue.guard(() async {
      await viewModel.signUp(entity);
    });

    state = const AsyncData(null);
  }

  Future<void> sendEmailVerification() async {
    await viewModel.sendEmailVerification();
  }

  Future<void> signOut() async {
    await viewModel.signOut();

    state = const AsyncData(null);
  }

  Future<void> deleteAccount() async {
    final current = state.value;

    if (current == null) {
      state = AsyncError('User not loaded', StackTrace.current);

      return;
    }

    state = const AsyncLoading();

    await AsyncValue.guard(() async {
      await viewModel.deleteAccount();
    });

    state = const AsyncData(null);
  }

  Future<void> reloadUser() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await viewModel.reloadUser();

      return viewModel.user;
    });
  }
}
