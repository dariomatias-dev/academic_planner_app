import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/auth/presentation/state/auth_view_model.dart';
import 'package:academic_planner/src/features/user/di/user_providers.dart';

class AuthNotifier extends AsyncNotifier<User?> {
  late final AuthViewModel viewModel;

  @override
  Future<User?> build() async {
    final authRepository = ref.read(authRepositoryProvider);
    final userRepository = ref.read(userRepositoryProvider);

    viewModel = AuthViewModel(
      authRepository: authRepository,
      userRepository: userRepository,
    );

    await viewModel.loadUser();

    return viewModel.user;
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();

    try {
      await viewModel.signIn(email, password);

      state = AsyncData(viewModel.user);
    } catch (err, stackTrace) {
      state = AsyncError(err, stackTrace);

      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    state = const AsyncLoading();

    try {
      await viewModel.signUp(email, password, name);

      state = const AsyncData(null);
    } catch (err, stackTrace) {
      state = AsyncError(err, stackTrace);

      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    await viewModel.sendEmailVerification();
  }

  Future<void> signOut() async {
    await viewModel.signOut();

    state = const AsyncData(null);
  }

  Future<void> reloadUser() async {
    await viewModel.reloadUser();

    state = AsyncData(viewModel.user);
  }
}
