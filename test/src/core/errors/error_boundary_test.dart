import 'package:academic_planner/src/core/errors/error_boundary.dart';
import 'package:academic_planner/src/core/errors/error_reporter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockErrorReporter extends Mock implements ErrorReporter {}

void main() {
  late MockErrorReporter reporter;
  late FlutterExceptionHandler? previousOnError;
  late ErrorWidgetBuilder previousErrorWidgetBuilder;
  late FlutterExceptionHandler previousPresentError;

  setUpAll(() {
    registerFallbackValue(StackTrace.empty);
  });

  setUp(() {
    reporter = MockErrorReporter();
    previousOnError = FlutterError.onError;
    previousErrorWidgetBuilder = ErrorWidget.builder;
    previousPresentError = FlutterError.presentError;
    FlutterError.presentError = (_) {};
  });

  tearDown(() {
    FlutterError.onError = previousOnError;
    ErrorWidget.builder = previousErrorWidgetBuilder;
    FlutterError.presentError = previousPresentError;
  });

  group('configureErrorBoundary', () {
    test('FlutterError.onError reports the exception and stack', () {
      configureErrorBoundary(reporter);

      final exception = FlutterErrorDetails(
        exception: Exception('widget build failed'),
        stack: StackTrace.current,
      );

      FlutterError.onError!(exception);

      verify(
        () => reporter.report(
          exception.exception,
          any(),
          reason: any(named: 'reason'),
        ),
      ).called(1);
    });

    test(
      'PlatformDispatcher.instance.onError reports the error and stack',
      () {
        configureErrorBoundary(reporter);

        final error = Exception('async failure');
        final stackTrace = StackTrace.current;

        final handled = PlatformDispatcher.instance.onError!(
          error,
          stackTrace,
        );

        expect(handled, isTrue);
        verify(() => reporter.report(error, stackTrace)).called(1);
      },
    );
  });
}
