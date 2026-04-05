sealed class Failure {
  const Failure();
}

final class DatabaseFailure extends Failure {
  final String message;

  const DatabaseFailure(this.message);
}
