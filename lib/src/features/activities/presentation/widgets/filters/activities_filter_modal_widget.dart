import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_field.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_sort_order.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/filter_modal_layout_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/category_filter_section_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/date_range_filter_section_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/discipline_filter_section_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/sort_filter_section_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/tags_filter_section_widget.dart';

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
  late String? _category;
  late List<String> _tags;
  late ActivitySortField? _sortField;
  late ActivitySortOrder? _sortOrder;

  void _applyFilters() {
    final filter = ActivityFilter(
      disciplineId: _selectedDisciplineId,
      startDate: _startDate,
      endDate: _endDate,
      category: _category,
      tags: _tags.isEmpty ? null : _tags,
      sortField: _sortField,
      sortOrder: _sortOrder,
    );

    ref.read(activityFilterNotifierProvider.notifier).setFilter(filter);

    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedDisciplineId = null;
      _startDate = null;
      _endDate = null;
      _category = null;
      _tags = [];
      _sortField = null;
      _sortOrder = null;
    });
  }

  @override
  void initState() {
    super.initState();

    final currentFilter = ref.read(activityFilterNotifierProvider);

    _selectedDisciplineId = currentFilter.disciplineId;
    _startDate = currentFilter.startDate;
    _endDate = currentFilter.endDate;
    _category = currentFilter.category;
    _tags = List.from(currentFilter.tags ?? []);
    _sortField = currentFilter.sortField;
    _sortOrder = currentFilter.sortOrder;
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
        const SizedBox(height: 32.0),
        CategoryFilterSectionWidget(
          value: _category,
          onChanged: (value) => setState(() => _category = value),
        ),
        const SizedBox(height: 32.0),
        TagsFilterSectionWidget(
          tags: _tags,
          onChanged: (tags) => setState(() => _tags = tags),
        ),
        const SizedBox(height: 32.0),
        SortFilterSectionWidget(
          sortField: _sortField,
          sortOrder: _sortOrder,
          onFieldChanged: (field) {
            setState(() {
              _sortField = field;
              _sortOrder = field?.defaultOrder;
            });
          },
          onOrderChanged: (order) {
            setState(() => _sortOrder = order);
          },
        ),
      ],
    );
  }
}
