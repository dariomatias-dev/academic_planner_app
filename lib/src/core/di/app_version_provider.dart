import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/notifiers/app_version_notifier.dart';

final appVersionProvider = AsyncNotifierProvider<AppVersionNotifier, String>(
  AppVersionNotifier.new,
);
