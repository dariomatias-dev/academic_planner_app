import 'package:logger/logger.dart';

class AppLogger {
  static final _logger = Logger();

  static void error(String message, Object error, StackTrace stackTrace) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void warning(String message) {
    _logger.w(message);
  }

  static void info(String message) {
    _logger.i(message);
  }
}
