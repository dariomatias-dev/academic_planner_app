sealed class Failure {
  final String message;
  final Object? exception;

  const Failure(this.message, [this.exception]);
}

final class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.exception]);
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, [super.exception]);
}

final class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [super.exception]);
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message, [super.exception]);
}

final class UnknownFailure extends Failure {
  const UnknownFailure(super.message, [super.exception]);
}
