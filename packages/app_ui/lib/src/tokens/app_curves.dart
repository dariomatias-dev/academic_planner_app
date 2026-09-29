import 'package:flutter/animation.dart';

/// Easing curves paired with the AppDurations tokens.
abstract final class AppCurves {
  static const Curve standard = Curves.easeInOut;
  static const Curve enter = Curves.easeOut;
  static const Curve exit = Curves.easeIn;
  static const Curve emphasized = Curves.easeOutQuart;
  static const Curve bounce = Curves.elasticOut;
}
