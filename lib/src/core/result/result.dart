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
    void Function(T value)? onSuccess,
    void Function(AppFailure failure)? onFailure,
  }) {
    switch (this) {
      case Success<T>(value: final v):
        onSuccess?.call(v);
      case Failure<T>(failure: final f):
        onFailure?.call(f);
    }
  }

  Future<R> foldAsync<R>({
    required Future<R> Function(T value) onSuccess,
    required Future<R> Function(AppFailure failure) onFailure,
  }) async {
    return switch (this) {
      Success<T>(value: final v) => onSuccess(v),
      Failure<T>(failure: final f) => onFailure(f),
    };
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
