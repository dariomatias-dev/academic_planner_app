import 'package:academic_planner/src/core/constants/day_names.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/constants/schedules.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/features/disciplines/data/models/discipline_model.dart';
import 'package:academic_planner/src/features/disciplines/di/discipline_providers.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_selection/widgets/discipline_selection_add_tab_content/conflict_alert_dialog_widget.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_selection/widgets/discipline_selection_add_tab_content/discipline_selection_check_icon_widget.dart';
import 'package:academic_planner/src/features/disciplines/presentation/widgets/discipline_card/discipline_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisciplineSelectionAddTabContentWidget extends ConsumerStatefulWidget {
  const DisciplineSelectionAddTabContentWidget({
    required this.periods,
    required this.periodController,
    super.key,
  });

  final List<int> periods;
  final TabController periodController;

  @override
  ConsumerState<DisciplineSelectionAddTabContentWidget> createState() =>
      _DisciplineSelectionAddTabContentWidgetState();
}

class _DisciplineSelectionAddTabContentWidgetState
    extends ConsumerState<DisciplineSelectionAddTabContentWidget> {
  Future<void> _onSelect(bool isSelected, DisciplineModel discipline) async {
    if (isSelected) {
      await ref
          .read(userDisciplinesNotifierProvider.notifier)
          .toggleDiscipline(discipline.id);

      return;
    }

    final conflictDetails = _getConflictDetails(discipline.id);

    if (conflictDetails != null) {
      await ConflictAlertDialogWidget.show(
        context,
        targetDisciplineName: discipline.name,
        conflictDetails: conflictDetails,
      );

      return;
    }

    await ref
        .read(userDisciplinesNotifierProvider.notifier)
        .toggleDiscipline(discipline.id);
  }

  String? _getConflictDetails(int disciplineId) {
    final selectedIds = ref.read(userDisciplinesNotifierProvider).toList();

    final newSchedules = schedules.filter(
      (s) => s.disciplineId == disciplineId,
    );
    final currentSchedules = schedules.filter(
      (s) => selectedIds.contains(s.disciplineId),
    );

    final conflicts = <String>[];

    for (final newSlot in newSchedules) {
      for (final existingSlot in currentSchedules) {
        if (newSlot.day == existingSlot.day &&
            newSlot.time == existingSlot.time) {
          final conflictingDiscipline = adsDisciplines.firstWhere(
            (d) => d.id == existingSlot.disciplineId,
          );

          final dayLabel = dayNames[newSlot.day - 1];

          conflicts.add(
            '• $dayLabel às ${newSlot.time}: ${conflictingDiscipline.name}',
          );
        }
      }
    }

    if (conflicts.isEmpty) return null;

    return conflicts.toSet().join('\n');
  }

  @override
  Widget build(BuildContext context) {
    final selectedIds = ref.watch(userDisciplinesNotifierProvider);

    return TabBarView(
      controller: widget.periodController,
      children: widget.periods.builder((period, index) {
        final periodDisciplines = adsDisciplines.filter(
          (d) => d.period == period,
        );

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 40.0),
          itemCount: periodDisciplines.length,
          itemBuilder: (context, index) {
            final discipline = periodDisciplines[index];
            final isSelected = selectedIds.contains(discipline.id);

            return DisciplineCardWidget(
              index: index + 1,
              discipline: discipline,
              opacity: isSelected ? 1.0 : 0.4,
              onTap: () => _onSelect(isSelected, discipline),
              trailing: DisciplineSelectionCheckIconWidget(
                isSelected: isSelected,
              ),
            );
          },
        );
      }),
    );
  }
}
