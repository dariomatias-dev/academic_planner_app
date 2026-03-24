import 'package:flutter/material.dart';

import 'package:academic_planner/src/screens/discipline_details/widgets/discipline_details_stat_card_widget.dart';

class DisciplineDetailsStatsGridWidget extends StatelessWidget {
  const DisciplineDetailsStatsGridWidget({
    super.key,
    required this.workload,
    required this.weeklyHours,
    required this.professorId,
  });

  final int workload;
  final int weeklyHours;
  final int professorId;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: DisciplineDetailsStatCardWidget(
            label: "Carga Horária",
            value: "${workload}h",
            icon: Icons.timer_outlined,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: DisciplineDetailsStatCardWidget(
            label: "Semanais",
            value: "${weeklyHours}h",
            icon: Icons.calendar_view_week_rounded,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: DisciplineDetailsStatCardWidget(
            label: "Docente",
            value: "Prof. ID $professorId",
            icon: Icons.person_outline_rounded,
          ),
        ),
      ],
    );
  }
}
