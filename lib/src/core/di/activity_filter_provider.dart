import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/data/filters/activity_filter.dart';

import 'package:academic_planner/src/notifiers/activity_filter_notifier.dart';

final activityFilterNotifierProvider =
    NotifierProvider<ActivityFilterNotifier, ActivityFilter>(
      ActivityFilterNotifier.new,
    );
