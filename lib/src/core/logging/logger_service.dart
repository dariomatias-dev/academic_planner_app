abstract class LoggerService {
  void error(String message, {Object? error, StackTrace? stackTrace});

  void warning(String message, {Object? error, StackTrace? stackTrace});

  void info(String message);

  void debug(String message);
}
