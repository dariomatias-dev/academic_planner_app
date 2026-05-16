import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/constants/schedules.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_section_title_widget.dart';

class DisciplineDetailsSchedulesWidget extends StatelessWidget {
  final int disciplineId;
  final int period;

  const DisciplineDetailsSchedulesWidget({
    super.key,
    required this.disciplineId,
    required this.period,
  });

  String _getDayName(int day) {
    return switch (day) {
      1 => "Segunda",
      2 => "Terça",
      3 => "Quarta",
      4 => "Quinta",
      5 => "Sexta",
      6 => "Sábado",
      _ => "Domingo",
    };
  }

  Map<int, List<String>> _getGroupedSchedules() {
    final grouped = <int, List<String>>{};
    final filtered = schedules.filter((s) => s.disciplineId == disciplineId);

    filtered.sort((a, b) => a.time.compareTo(b.time));

    for (final entry in filtered) {
      grouped.putIfAbsent(entry.day, () => <String>[]).add(entry.time);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final groupedSchedules = _getGroupedSchedules();
    final sortedDays = groupedSchedules.keys.toList()..sort();

    return InkWell(
      onTap: () => AppRoutes.goToSchedule(context, period: period),
      borderRadius: BorderRadius.circular(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const DisciplineDetailsSectionTitleWidget(
            title: "Horários das Aulas",
            icon: Icons.schedule_rounded,
          ),
          const SizedBox(height: 16.0),
          if (groupedSchedules.isEmpty)
            Text(
              "Nenhum horário definido.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14.0,
                color: colorScheme.onSurface.withAlpha(120),
              ),
            )
          else
            Column(
              spacing: 12.0,
              children: sortedDays.builder((day, index) {
                final times = groupedSchedules[day]!;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colorScheme.onSurface.withAlpha(20),
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 24.0,
                        backgroundColor:
                            colorScheme.primary.withAlpha(30),
                        child: Icon(
                          Icons.calendar_today_rounded,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _getDayName(day),
                              style: GoogleFonts.plusJakartaSans(
                                color: colorScheme.onSurface,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Wrap(
                              spacing: 6.0,
                              runSpacing: 6.0,
                              children: times.builder((time, index) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        colorScheme.primary.withAlpha(20),
                                    borderRadius:
                                        BorderRadius.circular(8.0),
                                  ),
                                  child: Text(
                                    time,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w700,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: colorScheme.onSurface.withAlpha(60),
                      ),
                    ],
                  ),
                );
              }),
            ),
        ],
      ),
    );
  }
}