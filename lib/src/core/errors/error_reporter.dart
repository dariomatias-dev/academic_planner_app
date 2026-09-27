/// Contract for reporting uncaught errors somewhere other than the console.
///
/// `LoggingErrorReporter` is the only implementation today (it just logs),
/// but the contract exists so a real crash-reporting backend (Crashlytics,
/// Sentry, ...) can be swapped in later without touching call sites.
// ignore: one_member_abstracts
abstract class ErrorReporter {
  void report(Object error, StackTrace stackTrace, {String? reason});
}
