import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/di/user_disciplines_provider.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/features/discipline_selection/widgets/discipline_selection_add_tab_content/discipline_selection_check_icon_widget.dart';

import 'package:academic_planner/src/shared/widgets/discipline_card/discipline_card_widget.dart';

class DisciplineSelectionAddTabContentWidget extends ConsumerWidget {
  final List<int> periods;
  final TabController periodController;

  const DisciplineSelectionAddTabContentWidget({
    super.key,
    required this.periods,
    required this.periodController,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(userDisciplinesNotifierProvider);

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
            final isSelected = notifier.contains(discipline.id);

            return DisciplineCardWidget(
              index: index + 1,
              discipline: discipline,
              opacity: isSelected ? 1.0 : 0.4,
              onTap: () {
                ref
                    .read(userDisciplinesNotifierProvider.notifier)
                    .toggleDiscipline(discipline.id);
              },
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
