// Single point of logging for the whole app: every file that needs to log
// creates its own `AppLogger('feature.ClassName')` and calls it. No other
// file imports package:logger directly.

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as pkg;

void configureLogging() {
  pkg.Logger.level = kReleaseMode ? pkg.Level.warning : pkg.Level.all;
}

class AppLogger {
  AppLogger(this.name);

  final String name;

  static final _output = pkg.Logger(filter: pkg.ProductionFilter());

  void info(String message) => _output.i('[$name] $message');

  void warning(String message) => _output.w('[$name] $message');

  void severe(String message, [Object? error, StackTrace? stackTrace]) =>
      _output.e('[$name] $message', error: error, stackTrace: stackTrace);
}
