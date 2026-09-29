import 'dart:async';

import 'package:academic_planner/src/core/logging/app_logger.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  silenceLogging();

  await testMain();
}
