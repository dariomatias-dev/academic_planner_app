import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/filter_modal_layout_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/discipline_filter_section_widget.dart';

class AgendaFilterModalWidget extends ConsumerStatefulWidget {
  final VoidCallback onClear;
  final void Function(ActivityFilter filter) onApply;

  const AgendaFilterModalWidget({
    super.key,
    required this.onClear,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onClear,
    required void Function(ActivityFilter filter) onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return AgendaFilterModalWidget(onClear: onClear, onApply: onApply);
      },
    );
  }

  @override
  ConsumerState<AgendaFilterModalWidget> createState() =>
      _AgendaFilterModalState();
}

class _AgendaFilterModalState extends ConsumerState<AgendaFilterModalWidget> {
  late int? _selectedDisciplineId;

  void _clearFilters() {
    widget.onClear();

    Navigator.pop(context);
  }

  void _applyFilters() {
    widget.onApply(ActivityFilter(disciplineId: _selectedDisciplineId));

    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    final currentFilter = ref.read(activityFilterNotifierProvider);
    _selectedDisciplineId = currentFilter.disciplineId;
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
      ],
    );
  }
}
