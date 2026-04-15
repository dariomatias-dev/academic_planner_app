import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/features/agenda/widgets/draggable_agenda_sheet/draggable_agenda_sheet_card_widget.dart';
import 'package:academic_planner/src/features/agenda/widgets/draggable_agenda_sheet/draggable_agenda_sheet_header_widget.dart';

import 'package:academic_planner/src/shared/models/agenda_entry_model.dart';
import 'package:academic_planner/src/shared/widgets/empty_state_widget.dart';

class DraggableAgendaSheetWidget extends StatelessWidget {
  final DateTime selectedDate;
  final List<AgendaEntryModel> entries;
  final ScrollController scrollController;

  const DraggableAgendaSheetWidget({
    super.key,
    required this.selectedDate,
    required this.entries,
    required this.scrollController,
  });

  String _getRelativeDateText() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final difference = selected.difference(today).inDays;

    if (difference == 0) return "Hoje";
    if (difference == 1) return "Amanhã";
    if (difference == -1) return "Ontem";
    if (difference > 0) return "Em $difference dias";

    return "Há ${difference.abs()} dias";
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final dailyEntries = entries.filter((e) {
      return e.startTime.year == selectedDate.year &&
          e.startTime.month == selectedDate.month &&
          e.startTime.day == selectedDate.day;
    });

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(40.0)),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 40.0,
              offset: const Offset(0.0, -10.0),
            ),
          ],
          border: Border.all(
            color: theme.dividerTheme.color ?? AppColors.transparent,
            width: 1.0,
          ),
        ),
        child: ListView.builder(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(24.0, 18.0, 24.0, 40.0),
          itemCount: dailyEntries.isEmpty ? 2 : dailyEntries.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: <Widget>[
                  DraggableAgendaSheetHeaderWidget(
                    date: selectedDate,
                    relativeText: _getRelativeDateText(),
                    count: dailyEntries.length,
                  ),
                  const SizedBox(height: 8.0),
                ],
              );
            }

            if (dailyEntries.isEmpty) {
              return const EmptyStateWidget(
                icon: Icons.event_available_rounded,
                title: "Tudo limpo por aqui!",
                description: "Nenhum compromisso agendado.",
                isCentered: true,
              );
            }

            return DraggableAgendaSheetCardWidget(
              index: index,
              entry: dailyEntries[index - 1],
            );
          },
        ),
      ),
    );
  }
}
