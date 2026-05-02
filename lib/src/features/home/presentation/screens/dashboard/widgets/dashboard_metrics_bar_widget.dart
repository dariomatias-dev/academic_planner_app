import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/disciplines/di/discipline_providers.dart';

class DashboardMetricsBarWidget extends ConsumerWidget {
  const DashboardMetricsBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final statsAsync = ref.watch(activityStatsNotifierProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 30.0,
            offset: const Offset(0.0, 15.0),
          ),
        ],
        border: Border.all(
          color: theme.dividerTheme.color ?? AppColors.transparent,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          statsAsync.when(
            loading: () {
              return const _HeaderMetricLoading(label: "Ativas");
            },
            error: (_, _) {
              return const _HeaderMetricError(label: "Ativas");
            },
            data: (stats) {
              return _HeaderMetric(
                value: stats.active.toString().padLeft(2, '0'),
                label: "Ativas",
                icon: Icons.bolt_rounded,
              );
            },
          ),
          const _DisciplinesMetric(),
          statsAsync.when(
            loading: () {
              return const _HeaderMetricLoading(label: "Progresso");
            },
            error: (_, _) {
              return const _HeaderMetricError(label: "Progresso");
            },
            data: (stats) {
              final progressPercent = (stats.progress * 100).toInt();

              return _HeaderMetric(
                value: "$progressPercent%",
                label: "Progresso",
                icon: Icons.donut_large_rounded,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DisciplinesMetric extends ConsumerWidget {
  const _DisciplinesMetric();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(userDisciplinesNotifierProvider).length;

    return _HeaderMetric(
      value: count.toString().padLeft(2, '0'),
      label: "Disciplinas",
      icon: Icons.grid_view_rounded,
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _HeaderMetric({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 14.0, color: colorScheme.primary),
            const SizedBox(width: 6.0),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface,
                fontSize: 20.0,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.onSurface.withAlpha(100),
            fontSize: 10.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _HeaderMetricLoading extends StatelessWidget {
  final String label;

  const _HeaderMetricLoading({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 20.0,
          width: 20.0,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(height: 4.0),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.onSurface.withAlpha(100),
            fontSize: 10.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _HeaderMetricError extends StatelessWidget {
  final String label;

  const _HeaderMetricError({required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(Icons.error_outline_rounded, size: 18.0, color: colorScheme.error),
        const SizedBox(height: 4.0),
        Text(
          label.toUpperCase(),
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.error.withAlpha(180),
            fontSize: 10.0,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
