import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/constants/schedules.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_section_title_widget.dart';

class DisciplineDetailsSchedulesWidget extends StatelessWidget {
  final int disciplineId;

  const DisciplineDetailsSchedulesWidget({
    super.key,
    required this.disciplineId,
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

    return Column(
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
                margin: const EdgeInsets.only(right: 12.0),
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 20.0, 16.0),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: theme.dividerTheme.color ?? Colors.transparent,
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 4.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _getDayName(day),
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w800,
                            fontSize: 15.0,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Row(
                          children: times.builder((time, index) {
                            return Container(
                              margin: const EdgeInsets.only(right: 6.0),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withAlpha(20),
                                borderRadius: BorderRadius.circular(8.0),
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
                  ],
                ),
              );
            }),
          ),
      ],
    );
  }
}
