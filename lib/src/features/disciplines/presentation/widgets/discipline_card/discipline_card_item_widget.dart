import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/disciplines/data/models/discipline_model.dart';
import 'package:academic_planner/src/features/disciplines/presentation/widgets/discipline_card/discipline_card_widget.dart';

class DisciplineCardItemWidget extends StatelessWidget {
  const DisciplineCardItemWidget({
    super.key,
    required this.index,
    required this.discipline,
    this.initialTabIndex,
  });

  final int index;
  final DisciplineModel discipline;
  final int? initialTabIndex;

  @override
  Widget build(BuildContext context) {
    return DisciplineCardWidget(
      index: index,
      discipline: discipline,
      onTap: () {
        AppRoutes.goToDisciplineDetails(
          context,
          disciplineId: discipline.id,
          tab: initialTabIndex,
        );
      },
    );
  }
}
