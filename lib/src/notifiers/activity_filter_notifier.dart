import 'package:flutter/material.dart';

import 'package:academic_planner/src/data/filters/activity_filter.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';

class ActivityFilterNotifier extends ChangeNotifier {
  ActivityFilter _filter = const ActivityFilter();

  ActivityFilter get filter => _filter;

  void setFilter(ActivityFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void update({
    String? search,
    int? disciplineId,
    DateTime? startDate,
    DateTime? endDate,
    ActivityStatus? status,
  }) {
    _filter = _filter.copyWith(
      search: search,
      disciplineId: disciplineId,
      startDate: startDate,
      endDate: endDate,
      status: status,
    );

    notifyListeners();
  }

  void clear() {
    _filter = const ActivityFilter();
    notifyListeners();
  }
}
