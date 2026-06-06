// Logging uses two packages intentionally:
//   package:logging  → API (Logger instances, hierarchy, level control)
//   package:logger   → output only (pretty-printer for the debug console)
//
// Consumers import only package:logging. package:logger is an implementation
// detail of this file and must not be imported anywhere else.

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart' as output;
import 'package:logging/logging.dart';

final _printer = output.Logger(level: output.Level.all);

void configureLogging() {
  Logger.root.level = kReleaseMode ? Level.WARNING : Level.ALL;
  Logger.root.onRecord.listen(_handleRecord);
}

void _handleRecord(LogRecord record) {
  final msg = '[${record.loggerName}] ${record.message}';

  if (record.level >= Level.SEVERE) {
    _printer.e(msg, error: record.error, stackTrace: record.stackTrace);
  } else if (record.level >= Level.WARNING) {
    _printer.w(msg, error: record.error, stackTrace: record.stackTrace);
  } else if (record.level >= Level.INFO) {
    _printer.i(msg);
  } else {
    _printer.d(msg);
  }
}
