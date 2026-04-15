import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/notifiers/navigation_notifier.dart';

final navigationNotifierProvider = NotifierProvider<NavigationNotifier, int>(
  NavigationNotifier.new,
);
