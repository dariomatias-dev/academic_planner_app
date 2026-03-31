import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/notifiers/user_disciplines_notifier.dart';

import 'package:academic_planner/src/screens/disciplines/widgets/disciplines_period_summary/disciplines_period_summary_widget.dart';

import 'package:academic_planner/src/shared/widgets/discipline_card/discipline_card_widget.dart';

class DisciplineSelectionMyGradeTabWidget extends StatelessWidget {
  const DisciplineSelectionMyGradeTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final notifier = context.watch<UserDisciplinesNotifier>();

    final selected = adsDisciplines.filter(
      (d) => notifier.selectedIds.contains(d.id),
    );

    if (selected.isEmpty) {
      return Center(
        child: Text(
          "Nenhuma disciplina selecionada",
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.onSurface.withAlpha(160),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final totalWorkload = selected.fold(0, (sum, item) => sum + item.workload);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 40.0),
      itemCount: selected.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: DisciplinesPeriodSummaryWidget(
              count: selected.length,
              workload: totalWorkload,
            ),
          );
        }

        final discipline = selected[index - 1];
        return DisciplineCardWidget(
          index: index,
          discipline: discipline,
          onTap: () => notifier.toggleDiscipline(discipline.id),
          trailing: Icon(
            Icons.remove_circle_outline_rounded,
            color: colorScheme.primary,
            size: 24.0,
          ),
        );
      },
    );
  }
}
