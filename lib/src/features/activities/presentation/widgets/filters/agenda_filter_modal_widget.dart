import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/filter_modal_layout_widget.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/discipline_filter_section_widget.dart';

class AgendaFilterModalWidget extends ConsumerStatefulWidget {
  const AgendaFilterModalWidget({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return const AgendaFilterModalWidget();
      },
    );
  }

  @override
  ConsumerState<AgendaFilterModalWidget> createState() => _AgendaFilterModalState();
}

class _AgendaFilterModalState extends ConsumerState<AgendaFilterModalWidget> {
  late int? _selectedDisciplineId;

  void _clearFilters() {
    Navigator.pop(context);
  }

  void _applyFilters() {
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
