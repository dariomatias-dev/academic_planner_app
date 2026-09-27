import 'package:academic_planner/src/core/logging/app_logger.dart';

/// Records calls instead of printing, for tests exercising code that takes
/// an injected [AppLogger] and want to assert on what was logged.
class FakeAppLogger implements AppLogger {
  FakeAppLogger([this.name = 'fake']);

  @override
  final String name;

  final infoMessages = <String>[];
  final warningMessages = <String>[];
  final severeMessages = <String>[];

  @override
  void info(String message) => infoMessages.add(message);

  @override
  void warning(String message) => warningMessages.add(message);

  @override
  void severe(String message, [Object? error, StackTrace? stackTrace]) =>
      severeMessages.add(message);
}
