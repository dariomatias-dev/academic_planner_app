abstract class LoggerService {
  void error(String message, {Object? error, StackTrace? stackTrace});

  void warning(String message);

  void info(String message);
}
