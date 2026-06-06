import 'failure.dart';

sealed class Result<T> {
  const Result();

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(AppFailure failure) onFailure,
  }) {
    return switch (this) {
      Success<T>(value: final v) => onSuccess(v),
      Failure<T>(failure: final f) => onFailure(f),
    };
  }

  void when({
    required void Function(T value) onSuccess,
    required void Function(AppFailure failure) onFailure,
  }) {
    switch (this) {
      case Success<T>(value: final v):
        onSuccess(v);
      case Failure<T>(failure: final f):
        onFailure(f);
    }
  }

}

final class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);
}

final class Failure<T> extends Result<T> {
  final AppFailure failure;

  const Failure(this.failure);
}
