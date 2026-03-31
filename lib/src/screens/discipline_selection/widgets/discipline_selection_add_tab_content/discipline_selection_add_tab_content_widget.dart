import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/screens/discipline_selection/widgets/discipline_selection_add_tab_content/discipline_selection_check_icon_widget.dart';

import 'package:academic_planner/src/shared/widgets/discipline_card/discipline_card_widget.dart';

class DisciplineSelectionAddTabContentWidget extends StatelessWidget {
  final List<int> periods;
  final TabController periodController;
  final Set<int> selectedIds;
  final Function(int) onToggle;

  const DisciplineSelectionAddTabContentWidget({
    super.key,
    required this.periods,
    required this.periodController,
    required this.selectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: periodController,
      children: periods.builder((period, index) {
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
              onTap: () => onToggle(discipline.id),
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
