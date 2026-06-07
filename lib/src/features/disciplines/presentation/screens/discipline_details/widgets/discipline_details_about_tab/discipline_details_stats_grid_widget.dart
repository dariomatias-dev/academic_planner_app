import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_stat_card_widget.dart';
import 'package:flutter/material.dart';

class DisciplineDetailsStatsGridWidget extends StatelessWidget {
  const DisciplineDetailsStatsGridWidget({
    required this.workload,
    required this.weeklyHours,
    super.key,
  });

  final int workload;
  final int weeklyHours;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: DisciplineDetailsStatCardWidget(
            label: 'Carga Horária',
            value: '${workload}h',
            icon: Icons.timer_outlined,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: DisciplineDetailsStatCardWidget(
            label: 'Semanais',
            value: '${weeklyHours}h',
            icon: Icons.calendar_view_week_rounded,
          ),
        ),
      ],
    );
  }
}
