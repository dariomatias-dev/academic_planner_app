sealed class Failure {
  const Failure();
}

final class DatabaseFailure extends Failure {
  final String message;

  const DatabaseFailure(this.message);
}

final class ValidationFailure extends Failure {
  final String message;

  const ValidationFailure(this.message);
}
