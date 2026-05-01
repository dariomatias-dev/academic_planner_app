import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_card/activity_card_widget.dart';

import 'package:academic_planner/src/shared/widgets/metric_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';

class ActivitiesSummaryTabWidget extends ConsumerWidget {
  final List<Activity> activities;

  const ActivitiesSummaryTabWidget({super.key, required this.activities});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statsAsync = ref.watch(activityStatsNotifierProvider);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 140.0),
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: colorScheme.primary.withAlpha(60),
                      blurRadius: 20.0,
                      offset: const Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: statsAsync.when(
                  loading: () {
                    return _ProgressPlaceholder(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: colorScheme.onPrimary,
                      ),
                    );
                  },
                  error: (err, stack) {
                    return _ProgressPlaceholder(
                      child: Icon(
                        Icons.error_outline,
                        color: colorScheme.onPrimary,
                      ),
                    );
                  },
                  data: (stats) {
                    return _ProgressContent(
                      progress: stats.progress,
                      percent: (stats.progress * 100.0).toInt(),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              flex: 2,
              child: Container(
                height: 145.0,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: statsAsync.when(
                  loading: () {
                    return _MetricStatus(
                      icon: Icons.notification_important_rounded,
                      color: colorScheme.error,
                      child: SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: colorScheme.error,
                        ),
                      ),
                    );
                  },
                  error: (err, stack) {
                    return _MetricStatus(
                      icon: Icons.notification_important_rounded,
                      color: colorScheme.error,
                      child: const Icon(Icons.error_outline),
                    );
                  },
                  data: (stats) {
                    return _MetricStatus(
                      icon: Icons.notification_important_rounded,
                      color: colorScheme.error,
                      child: Text(
                        stats.urgent.toString(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.error,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Row(
          children: <Widget>[
            Expanded(
              child: MetricCardWidget(
                label: "Ativas",
                icon: Icons.bolt_rounded,
                color: colorScheme.secondary,
                valueWidget: statsAsync.when(
                  loading: () => const _SmallLoading(),
                  error: (e, s) {
                    return const Icon(Icons.error_outline, size: 18.0);
                  },
                  data: (stats) {
                    return Text(
                      stats.active.toString(),
                      style: GoogleFonts.plusJakartaSans(
                        color: theme.colorScheme.onSurface,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: MetricCardWidget(
                label: "Concluídas",
                icon: Icons.check_circle_rounded,
                color: Colors.teal,
                valueWidget: statsAsync.when(
                  loading: () => const _SmallLoading(),
                  error: (e, s) {
                    return const Icon(Icons.error_outline, size: 18.0);
                  },
                  data: (stats) {
                    return Text(
                      stats.completed.toString(),
                      style: GoogleFonts.plusJakartaSans(
                        color: theme.colorScheme.onSurface,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40.0),
        Row(
          children: <Widget>[
            Container(
              width: 4.0,
              height: 22.0,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                borderRadius: BorderRadius.circular(2.0),
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              "Próximos Prazos",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20.0),
        if (activities.where((t) {
          return t.status != ActivityStatus.completed;
        }).isEmpty)
          const EmptyStateWidget(
            icon: Icons.celebration_rounded,
            title: 'Sem atividades',
            description: 'Tudo em dia por aqui!',
            isCentered: false,
          )
        else
          ...activities
              .where((t) {
                return t.status != ActivityStatus.completed;
              })
              .take(3)
              .map((task) {
                return ActivityCardWidget(activity: task);
              }),
      ],
    );
  }
}

class _ProgressContent extends StatelessWidget {
  final double progress;
  final int percent;

  const _ProgressContent({required this.progress, required this.percent});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Seu Progresso",
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.onPrimary.withAlpha(200),
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          "$percent%",
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.onPrimary,
            fontSize: 32.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 20.0),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8.0,
            backgroundColor: colorScheme.onPrimary.withAlpha(50),
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
          ),
        ),
      ],
    );
  }
}

class _ProgressPlaceholder extends StatelessWidget {
  final Widget child;

  const _ProgressPlaceholder({required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Seu Progresso",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onPrimary.withAlpha(200),
          ),
        ),
        const SizedBox(height: 12.0),
        child,
      ],
    );
  }
}

class _MetricStatus extends StatelessWidget {
  final Widget child;
  final IconData icon;
  final Color color;

  const _MetricStatus({
    required this.child,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, color: color, size: 28.0),
        const SizedBox(height: 12.0),
        child,
        const SizedBox(height: 8.0),
        Text(
          "URGENTES",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10.0,
            fontWeight: FontWeight.w700,
            color: color.withAlpha(180),
          ),
        ),
      ],
    );
  }
}

class _SmallLoading extends StatelessWidget {
  const _SmallLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 4.0),
      height: 16.0,
      width: 16.0,
      child: CircularProgressIndicator(strokeWidth: 2.0),
    );
  }
}
