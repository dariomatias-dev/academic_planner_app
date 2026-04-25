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

    final current = viewModel.authRepository.currentUser;

    if (current == null) {
      return null;
    }

    await current.reload();

    if (!current.emailVerified) {
      await viewModel.authRepository.signOut();

      return null;
    }

    final user = await viewModel.userRepository.getById(current.uid);

    viewModel.user = user;
    viewModel.isEmailVerified = true;

    return user;
  }

  Future<void> signIn(LoginEntity entity) async {
    state = const AsyncLoading();

    final result = await viewModel.signIn(entity);

    state = result.fold(
      onSuccess: (_) => AsyncData(viewModel.user),
      onFailure: (f) => AsyncError(f, StackTrace.current),
    );
  }

  Future<void> register(RegisterEntity entity) async {
    state = const AsyncLoading();

    final result = await viewModel.registerFlow(entity);

    state = result.fold(
      onSuccess: (_) => const AsyncData(null),
      onFailure: (f) => AsyncError(f, StackTrace.current),
    );
  }

  Future<void> signUp(RegisterEntity entity) async {
    state = const AsyncLoading();

    final result = await viewModel.signUp(entity);

    state = result.fold(
      onSuccess: (_) => const AsyncData(null),
      onFailure: (f) => AsyncError(f, StackTrace.current),
    );
  }

  Future<void> signOut() async {
    final result = await viewModel.signOut();

    state = result.fold(
      onSuccess: (_) => const AsyncData(null),
      onFailure: (f) => AsyncError(f, StackTrace.current),
    );
  }

  Future<void> deleteAccount() async {
    state = const AsyncLoading();

    final result = await viewModel.deleteAccount();

    state = result.fold(
      onSuccess: (_) => const AsyncData(null),
      onFailure: (f) => AsyncError(f, StackTrace.current),
    );
  }

  Future<void> sendEmailVerification() async {
    final result = await viewModel.sendEmailVerification();

    result.when(
      onFailure: (f) {
        state = AsyncError(f, StackTrace.current);
      },
    );
  }
}
