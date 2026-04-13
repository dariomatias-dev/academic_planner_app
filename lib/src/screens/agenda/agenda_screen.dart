import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/constants/mock_activities.dart';
import 'package:academic_planner/src/core/extensions/activity_status_extension.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/screens/agenda/widgets/draggable_agenda_sheet/draggable_agenda_sheet_widget.dart';

import 'package:academic_planner/src/shared/models/agenda_entry_model.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({super.key});

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  final _calendarController = CalendarController();

  DateTime _displayDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  void _onViewChanged(ViewChangedDetails details) {
    if (details.visibleDates.isNotEmpty) {
      final midDate = details.visibleDates[details.visibleDates.length ~/ 2];
      if (midDate.month != _displayDate.month ||
          midDate.year != _displayDate.year) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() => _displayDate = midDate);
        });
      }
    }
  }

  @override
  void dispose() {
    _calendarController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final entries = AgendaEntryFactory.build(colorScheme);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "Minha Agenda",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.tune_rounded,
            onPressed: () {},
            style: IconButtonStyle.primary,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              const SizedBox(height: 24.0),
              _AgendaHeader(
                displayDate: _displayDate,
                onBackward: () => _calendarController.backward?.call(),
                onForward: () => _calendarController.forward?.call(),
              ),
              const SizedBox(height: 16.0),
              _CalendarView(
                controller: _calendarController,
                onViewChanged: _onViewChanged,
                onTap: (date) => setState(() => _selectedDate = date),
                entries: entries,
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.38,
            minChildSize: 0.38,
            maxChildSize: 0.90,
            builder: (context, scrollController) {
              return DraggableAgendaSheetWidget(
                selectedDate: _selectedDate,
                entries: entries,
                scrollController: scrollController,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AgendaHeader extends StatelessWidget {
  final DateTime displayDate;
  final VoidCallback onBackward;
  final VoidCallback onForward;

  const _AgendaHeader({
    required this.displayDate,
    required this.onBackward,
    required this.onForward,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateFormat(
                    'MMMM yyyy',
                    'pt_BR',
                  ).format(displayDate).toUpperCase(),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                ),
                Container(
                  height: 4.0,
                  width: 32.0,
                  margin: const EdgeInsets.only(top: 4.0),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ],
            ),
          ),
          IconButtonWidget(
            icon: Icons.chevron_left_rounded,
            onPressed: onBackward,
            style: IconButtonStyle.primary,
          ),
          const SizedBox(width: 8.0),
          IconButtonWidget(
            icon: Icons.chevron_right_rounded,
            onPressed: onForward,
            style: IconButtonStyle.primary,
          ),
        ],
      ),
    );
  }
}

class _CalendarView extends StatelessWidget {
  final CalendarController controller;
  final Function(ViewChangedDetails value) onViewChanged;
  final Function(DateTime value) onTap;
  final List<AgendaEntryModel> entries;

  const _CalendarView({
    required this.controller,
    required this.onViewChanged,
    required this.onTap,
    required this.entries,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 320.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(32.0),
          border: Border.all(
            color: theme.dividerTheme.color ?? AppColors.transparent,
            width: 1.0,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colorScheme.onSurface.withAlpha(15),
              blurRadius: 30.0,
              offset: const Offset(0.0, 10.0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.0),
          child: SfCalendar(
            controller: controller,
            view: CalendarView.month,
            headerHeight: 0.0,
            onViewChanged: onViewChanged,
            onTap: (details) {
              details.date != null ? onTap(details.date!) : null;
            },
            dataSource: _AgendaDataSource(
              entries.builder((e, index) => e.toAppointment()),
            ),
            todayHighlightColor: colorScheme.primary,
            selectionDecoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(15),
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: colorScheme.primary, width: 2.0),
            ),
            monthViewSettings: const MonthViewSettings(
              dayFormat: 'EEE',
              appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
              monthCellStyle: MonthCellStyle(
                textStyle: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AgendaEntryFactory {
  static List<AgendaEntryModel> build(ColorScheme colorScheme) {
    final entries = <AgendaEntryModel>[];

    for (final activity in mockActivities) {
      if (activity.dueDate != null) {
        final discipline = adsDisciplines.firstWhere(
          (d) => d.id == activity.disciplineId,
        );

        entries.add(
          AgendaEntryModel(
            id: 'activity_${activity.id}',
            title: activity.title,
            subtitle: discipline.acronym,
            startTime: activity.dueDate!,
            endTime: activity.dueDate!.add(const Duration(hours: 1)),
            color: activity.status?.color(colorScheme) ?? colorScheme.primary,
            type: AgendaEntryType.activity,
          ),
        );
      }
    }

    final now = DateTime.now();

    entries.addAll(<AgendaEntryModel>[
      AgendaEntryModel(
        id: 'holiday_tiradentes',
        title: "Tiradentes",
        subtitle: "Feriado Nacional",
        startTime: DateTime(now.year, 4, 21),
        endTime: DateTime(now.year, 4, 21, 23, 59),
        color: Colors.blueGrey,
        isAllDay: true,
        type: AgendaEntryType.holiday,
      ),
      AgendaEntryModel(
        id: 'exam_p1',
        title: "Prova Substitutiva P1",
        subtitle: "Sistemas Operacionais",
        startTime: now.add(const Duration(days: 3, hours: 10)),
        endTime: now.add(const Duration(days: 3, hours: 12)),
        color: Colors.deepOrange,
        type: AgendaEntryType.exam,
      ),
      AgendaEntryModel(
        id: 'event_hack',
        title: "Hackathon IFPB",
        subtitle: "Auditório Principal",
        startTime: now.add(const Duration(days: 5, hours: 8)),
        endTime: now.add(const Duration(days: 5, hours: 18)),
        color: Colors.indigo,
        type: AgendaEntryType.event,
      ),
    ]);

    return entries;
  }
}

class _AgendaDataSource extends CalendarDataSource {
  _AgendaDataSource(List<Appointment> source) {
    appointments = source;
  }
}
