import 'package:firebase_auth/firebase_auth.dart';

class AuthState {
  final User? user;
  final bool isLoading;
  final bool isEmailVerified;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isEmailVerified = false,
  });

  bool get isAuthenticated => user != null && isEmailVerified;

  AuthState copyWith({User? user, bool? isLoading, bool? isEmailVerified}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  factory AuthState.initial() => const AuthState();
}
