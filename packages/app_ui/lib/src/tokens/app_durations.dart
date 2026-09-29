/// Animation durations, from micro-interactions to ambient motion.
abstract final class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 800);
  static const Duration slower = Duration(milliseconds: 1000);
  static const Duration ambient = Duration(milliseconds: 2000);
}
