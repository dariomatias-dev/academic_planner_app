import 'package:flutter/material.dart';

import 'package:academic_planner/src/features/disciplines/widgets/disciplines_period_summary/disciplines_summary_item_widget.dart';

class DisciplinesPeriodSummaryWidget extends StatelessWidget {
  const DisciplinesPeriodSummaryWidget({
    super.key,
    required this.count,
    required this.workload,
  });

  final int count;
  final int workload;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, top: 8.0),
      child: Row(
        children: <Widget>[
          DisciplinesSummaryItemWidget(
            icon: Icons.layers_outlined,
            label: "$count Disciplinas",
          ),
          const SizedBox(width: 12.0),
          DisciplinesSummaryItemWidget(
            icon: Icons.history_toggle_off_rounded,
            label: "${workload}h Totais",
          ),
        ],
      ),
    );
  }
}
