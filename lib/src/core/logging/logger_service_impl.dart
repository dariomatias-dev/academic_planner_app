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
  void warning(String message) {
    _logger.w(message);
  }

  @override
  void info(String message) {
    _logger.i(message);
  }
}
