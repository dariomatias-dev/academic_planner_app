import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/features/disciplines/domain/entities/discipline.dart';
import 'package:academic_planner/src/features/disciplines/presentation/widgets/discipline_card/discipline_card_widget.dart';
import 'package:flutter/material.dart';

class DisciplineCardItemWidget extends StatelessWidget {
  const DisciplineCardItemWidget({
    required this.index,
    required this.discipline,
    super.key,
    this.initialTabIndex,
  });

  final int index;
  final Discipline discipline;
  final int? initialTabIndex;

  @override
  Widget build(BuildContext context) {
    return DisciplineCardWidget(
      index: index,
      discipline: discipline,
      onTap: () async {
        await AppRoutes.goToDisciplineDetails(
          context,
          disciplineId: discipline.id,
          tab: initialTabIndex,
        );
      },
    );
  }
}
