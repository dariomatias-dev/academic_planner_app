import 'failure.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    return switch (this) {
      Success<T>(value: final v) => onSuccess(v),
      FailureResult<T>(failure: final f) => onFailure(f),
    };
  }

  void when({
    void Function(T value)? onSuccess,
    void Function(Failure failure)? onFailure,
  }) {
    switch (this) {
      case Success<T>(value: final v):
        onSuccess?.call(v);
      case FailureResult<T>(failure: final f):
        onFailure?.call(f);
    }
  }

  Future<R> foldAsync<R>({
    required Future<R> Function(T value) onSuccess,
    required Future<R> Function(Failure failure) onFailure,
  }) async {
    return switch (this) {
      Success<T>(value: final v) => onSuccess(v),
      FailureResult<T>(failure: final f) => onFailure(f),
    };
  }

  Future<void> whenAsync({
    Future<void> Function(T value)? onSuccess,
    Future<void> Function(Failure failure)? onFailure,
  }) async {
    switch (this) {
      case Success<T>(value: final v):
        if (onSuccess != null) await onSuccess(v);
      case FailureResult<T>(failure: final f):
        if (onFailure != null) await onFailure(f);
    }
  }
}

final class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);
}

final class FailureResult<T> extends Result<T> {
  final Failure failure;

  const FailureResult(this.failure);
}
