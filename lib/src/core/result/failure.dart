sealed class AppFailure {
  final String message;
  final Object? exception;

  const AppFailure(this.message, [this.exception]);
}

final class AuthFailure extends AppFailure {
  const AuthFailure(super.message, [super.exception]);
}

final class DatabaseFailure extends AppFailure {
  const DatabaseFailure(super.message, [super.exception]);
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message, [super.exception]);
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message, [super.exception]);
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure(super.message, [super.exception]);
}
