sealed class AppFailure {
  final String message;

  const AppFailure(this.message);
}

final class AuthFailure extends AppFailure {
  const AuthFailure(super.message);
}

final class DatabaseFailure extends AppFailure {
  const DatabaseFailure(super.message);
}

final class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message);
}

final class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

final class UnknownFailure extends AppFailure {
  const UnknownFailure(super.message);
}
