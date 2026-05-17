import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/filter_modal_layout_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/category_filter_section_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/discipline_filter_section_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/tags_filter_section_widget.dart';
import 'package:academic_planner/src/features/calendar/di/calendar_provider.dart';

import 'package:academic_planner/src/shared/utils/modal_bottom_sheet.dart';

class AgendaFilterModalWidget extends ConsumerStatefulWidget {
  final ActivityFilter? initialFilter;

  const AgendaFilterModalWidget({super.key, this.initialFilter});

  static Future<void> show(
    BuildContext context, {
    ActivityFilter? initialFilter,
  }) {
    return ModalBottomSheet.show(
      context: context,
      child: AgendaFilterModalWidget(initialFilter: initialFilter),
    );
  }

  @override
  ConsumerState<AgendaFilterModalWidget> createState() =>
      _AgendaFilterModalState();
}

class _AgendaFilterModalState extends ConsumerState<AgendaFilterModalWidget> {
  late int? _selectedDisciplineId = widget.initialFilter?.disciplineId;
  late String? _category = widget.initialFilter?.category;
  late List<String> _tags = List.from(widget.initialFilter?.tags ?? []);

  void _applyFilters() {
    final filter = ActivityFilter(
      disciplineId: _selectedDisciplineId,
      category: _category,
      tags: _tags.isEmpty ? null : _tags,
    );

    ref.read(agendaNotifierProvider.notifier).fetchData(filter: filter);

    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _selectedDisciplineId = null;
      _category = null;
      _tags = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FilterModalLayoutWidget(
      title: 'Filtros da Agenda',
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
        CategoryFilterSectionWidget(
          value: _category,
          onChanged: (value) => setState(() => _category = value),
        ),
        const SizedBox(height: 32.0),
        TagsFilterSectionWidget(
          tags: _tags,
          onChanged: (tags) => setState(() => _tags = tags),
        ),
      ],
    );
  }
}
