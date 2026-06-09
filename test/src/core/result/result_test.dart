import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result.fold', () {
    group('Success', () {
      test('invokes onSuccess with the carried value', () {
        const expected = 42;
        const result = Success(expected);

        var successCalled = false;
        var failureCalled = false;

        result.fold(
          onSuccess: (value) {
            successCalled = true;
            expect(value, expected);
          },
          onFailure: (_) => failureCalled = true,
        );

        expect(successCalled, isTrue);
        expect(failureCalled, isFalse);
      });

      test('returns value produced by onSuccess', () {
        const sentinel = 'ok';
        const result = Success(sentinel);

        final returned = result.fold(
          onSuccess: (value) => value,
          onFailure: (_) => 'error',
        );

        expect(returned, sentinel);
      });
    });

    group('Failure', () {
      test('invokes onFailure with the carried failure, never onSuccess', () {
        const failure = DatabaseFailure('db error');
        const result = Failure<int>(failure);

        var successCalled = false;
        var failureCalled = false;

        result.fold(
          onSuccess: (_) => successCalled = true,
          onFailure: (f) {
            failureCalled = true;
            expect(f, failure);
          },
        );

        expect(successCalled, isFalse);
        expect(failureCalled, isTrue);
      });

      test('returns value produced by onFailure', () {
        const sentinel = 'failure-path';
        const result = Failure<int>(NetworkFailure('no network'));

        final returned = result.fold(
          onSuccess: (_) => 'success-path',
          onFailure: (_) => sentinel,
        );

        expect(returned, sentinel);
      });
    });
  });

  group('Result.when', () {
    group('Success', () {
      test('invokes onSuccess with the carried value, never onFailure', () {
        const expected = 'hello';
        const result = Success(expected);

        var successCalled = false;
        var failureCalled = false;

        result.when(
          onSuccess: (value) {
            successCalled = true;
            expect(value, expected);
          },
          onFailure: (_) => failureCalled = true,
        );

        expect(successCalled, isTrue);
        expect(failureCalled, isFalse);
      });
    });

    group('Failure', () {
      test('invokes onFailure with the carried failure, never onSuccess', () {
        const failure = AuthFailure('bad token');
        const result = Failure<String>(failure);

        var successCalled = false;
        var failureCalled = false;

        result.when(
          onSuccess: (_) => successCalled = true,
          onFailure: (f) {
            failureCalled = true;
            expect(f, failure);
          },
        );

        expect(successCalled, isFalse);
        expect(failureCalled, isTrue);
      });
    });
  });
}
