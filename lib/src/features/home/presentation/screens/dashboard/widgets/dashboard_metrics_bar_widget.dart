import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/disciplines/di/discipline_providers.dart';

class DashboardMetricsBarWidget extends ConsumerWidget {
  const DashboardMetricsBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statsAsync = ref.watch(activityStatsNotifierProvider);
    final userDisciplines = ref.watch(userDisciplinesNotifierProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: colorScheme.onSurface.withAlpha(15),
          width: 1.0,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 20.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: statsAsync.when(
        loading: () {
          return const SizedBox(
            height: 60.0,
            child: Center(
              child: SizedBox(
                height: 24.0,
                width: 24.0,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ),
          );
        },
        error: (_, _) {
          return const SizedBox(
            height: 60.0,
            child: Center(
              child: Icon(Icons.error_outline_rounded, color: Colors.red),
            ),
          );
        },
        data: (stats) {
          return IntrinsicHeight(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: DashboardMetricsBarItemWidget(
                    value: stats.active.toString().padLeft(2, '0'),
                    label: "Ativas",
                    icon: Icons.bolt_rounded,
                  ),
                ),
                Container(
                  height: 32.0,
                  width: 1.0,
                  color: colorScheme.onSurface.withAlpha(20),
                ),
                Expanded(
                  child: DashboardMetricsBarItemWidget(
                    value: userDisciplines.length.toString().padLeft(2, '0'),
                    label: "Disciplinas",
                    icon: Icons.grid_view_rounded,
                  ),
                ),
                Container(
                  height: 32.0,
                  width: 1.0,
                  color: colorScheme.onSurface.withAlpha(20),
                ),
                Expanded(
                  child: DashboardMetricsBarItemWidget(
                    value: "${(stats.progress * 100).toInt()}%",
                    label: "Concluído",
                    icon: Icons.check_circle_rounded,
                    highlightColor: Colors.teal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DashboardMetricsBarItemWidget extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color? highlightColor;

  const DashboardMetricsBarItemWidget({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  color: highlightColor ?? colorScheme.onSurface,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1.0,
                ),
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              label.toUpperCase(),
              style: GoogleFonts.plusJakartaSans(
                color:
                    highlightColor?.withAlpha(180) ??
                    colorScheme.onSurface.withAlpha(120),
                fontSize: 9.0,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
