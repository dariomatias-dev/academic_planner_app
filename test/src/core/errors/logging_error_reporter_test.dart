import 'package:academic_planner/src/core/errors/logging_error_reporter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_app_logger.dart';

void main() {
  group('LoggingErrorReporter', () {
    test('report logs the error and stack trace with the given reason', () {
      final logger = FakeAppLogger();
      final sut = LoggingErrorReporter(logger: logger);
      final error = Exception('boom');
      final stackTrace = StackTrace.current;

      sut.report(error, stackTrace, reason: 'something failed');

      expect(logger.severeMessages, ['something failed']);
    });

    test('report defaults the reason when none is given', () {
      final logger = FakeAppLogger();

      LoggingErrorReporter(
        logger: logger,
      ).report(Exception('boom'), StackTrace.current);

      expect(logger.severeMessages, ['Unhandled error']);
    });
  });
}
