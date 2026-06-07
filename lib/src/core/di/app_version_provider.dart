import 'package:academic_planner/src/core/notifiers/app_version_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appVersionProvider = AsyncNotifierProvider<AppVersionNotifier, String>(
  AppVersionNotifier.new,
);
