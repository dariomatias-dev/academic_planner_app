import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/filter_modal_layout_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/date_range_filter_section_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/discipline_filter_section_widget.dart';

import 'package:academic_planner/src/shared/utils/modal_bottom_sheet.dart';

class ActivitiesFilterModalWidget extends ConsumerStatefulWidget {
  const ActivitiesFilterModalWidget({super.key});

  static Future<void> show(BuildContext context) {
    return ModalBottomSheet.show(
      context: context,
      child: const ActivitiesFilterModalWidget(),
    );
  }

  @override
  ConsumerState<ActivitiesFilterModalWidget> createState() =>
      _ActivitiesFilterModalWidgetState();
}

class _ActivitiesFilterModalWidgetState
    extends ConsumerState<ActivitiesFilterModalWidget> {
  late int? _selectedDisciplineId;
  late DateTime? _startDate;
  late DateTime? _endDate;

  void _clearFilters() {
    ref.read(activityFilterNotifierProvider.notifier).clear();

    Navigator.pop(context);
  }

  void _applyFilters() {
    ref
        .read(activityFilterNotifierProvider.notifier)
        .update(
          disciplineId: _selectedDisciplineId,
          startDate: _startDate,
          endDate: _endDate,
        );

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    final currentFilter = ref.read(activityFilterNotifierProvider);

    _selectedDisciplineId = currentFilter.disciplineId;
    _startDate = currentFilter.startDate;
    _endDate = currentFilter.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return FilterModalLayoutWidget(
      title: 'Filtros',
      onClear: _clearFilters,
      onApply: _applyFilters,
      children: <Widget>[
        DisciplineFilterSectionWidget(
          selectedId: _selectedDisciplineId,
          onSelected: (id) {
            setState(() => _selectedDisciplineId = id);
          },
        ),
        const SizedBox(height: 32.0),
        DateRangeFilterSectionWidget(
          startDate: _startDate,
          endDate: _endDate,
          onStartDateChanged: (date) {
            setState(() => _startDate = date);
          },
          onEndDateChanged: (date) {
            setState(() => _endDate = date);
          },
        ),
      ],
    );
  }
}
