import 'package:academic_planner/src/features/disciplines/presentation/widgets/disciplines_summary/disciplines_summary_item_widget.dart';
import 'package:flutter/material.dart';

class DisciplinesSummaryWidget extends StatelessWidget {
  const DisciplinesSummaryWidget({
    required this.count,
    required this.workload,
    super.key,
  });

  final int count;
  final int workload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: theme.colorScheme.onSurface.withAlpha(15),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: DisciplinesSummaryItemWidget(
              icon: Icons.grid_view_rounded,
              label: 'Disciplinas',
              value: count.toString(),
            ),
          ),
          Container(
            height: 32.0,
            width: 1.0,
            color: theme.colorScheme.onSurface.withAlpha(20),
          ),
          Expanded(
            child: DisciplinesSummaryItemWidget(
              icon: Icons.schedule_rounded,
              label: 'Horas Totais',
              value: '${workload}h',
            ),
          ),
        ],
      ),
    );
  }
}
