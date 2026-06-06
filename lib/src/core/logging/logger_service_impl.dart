import 'package:logger/logger.dart';

import 'package:academic_planner/src/core/logging/logger_service.dart';

class LoggerServiceImpl implements LoggerService {
  final Logger _logger;

  LoggerServiceImpl(this._logger);

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  @override
  void info(String message) {
    _logger.i(message);
  }

  @override
  void debug(String message) {
    _logger.d(message);
  }
}
