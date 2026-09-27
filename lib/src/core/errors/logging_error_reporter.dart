import 'package:academic_planner/src/core/errors/error_reporter.dart';
import 'package:academic_planner/src/core/logging/app_logger.dart';

class LoggingErrorReporter implements ErrorReporter {
  LoggingErrorReporter({AppLogger? logger})
    : _log = logger ?? AppLogger('core.ErrorReporter');

  final AppLogger _log;

  @override
  void report(Object error, StackTrace stackTrace, {String? reason}) {
    _log.severe(reason ?? 'Unhandled error', error, stackTrace);
  }
}
