import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:academic_planner/src/core/logging/logger_service.dart';
import 'package:academic_planner/src/core/logging/logger_service_impl.dart';

final loggerProvider = Provider<LoggerService>((ref) {
  return LoggerServiceImpl(
    Logger(level: kReleaseMode ? Level.warning : Level.debug),
  );
});
