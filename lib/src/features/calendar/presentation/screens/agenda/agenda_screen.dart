import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/activity_status_extension.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/agenda_filter_modal_widget.dart';
import 'package:academic_planner/src/features/calendar/di/calendar_provider.dart';
import 'package:academic_planner/src/features/calendar/presentation/screens/agenda/widgets/draggable_agenda_sheet/draggable_agenda_sheet_widget.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/states.dart';

class AgendaScreen extends ConsumerStatefulWidget {
  const AgendaScreen({super.key});

  @override
  ConsumerState<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends ConsumerState<AgendaScreen> {
  final _calendarController = CalendarController();

  void _onViewChanged(ViewChangedDetails details) {
    if (details.visibleDates.isNotEmpty) {
      final midDate = details.visibleDates[details.visibleDates.length ~/ 2];

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(agendaNotifierProvider.notifier).updateDisplayDate(midDate);
      });
    }
  }

  void _openFilterModal() {
    final asyncState = ref.read(agendaNotifierProvider);

    asyncState.whenData((state) {
      AgendaFilterModalWidget.show(context, initialFilter: state.filter);
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final asyncState = ref.watch(agendaNotifierProvider);
    final notifier = ref.read(agendaNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "Minha Agenda",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.filter_list,
            onPressed: _openFilterModal,
          ),
        ],
      ),
      body: asyncState.when(
        loading: () {
          return const LoadingStateWidget();
        },
        error: (error, stackTrace) {
          return ErrorStateWidget(
            description: "Não foi possível carregar sua agenda.",
            actionLabel: "Tentar novamente",
            onActionPressed: notifier.fetchData,
          );
        },
        data: (state) {
          return Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 24.0),
                  _AgendaHeader(
                    displayDate: state.displayDate,
                    onBackward: () => _calendarController.backward?.call(),
                    onForward: () => _calendarController.forward?.call(),
                  ),
                  const SizedBox(height: 24.0),
                  _CalendarView(
                    controller: _calendarController,
                    onViewChanged: _onViewChanged,
                    onTap: (date) => notifier.updateSelectedDate(date),
                    activities: state.activities,
                  ),
                ],
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.34,
                minChildSize: 0.34,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return DraggableAgendaSheetWidget(
                    selectedDate: state.selectedDate,
                    activities: state.activities,
                    scrollController: scrollController,
                  );
                },
              ),
            ],
          );
        },
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
  final List<Activity> activities;

  const _CalendarView({
    required this.controller,
    required this.onViewChanged,
    required this.onTap,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const borderRadiusValue = 28.0;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 300.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(borderRadiusValue),
          border: Border.all(
            color: theme.dividerTheme.color ?? AppColors.transparent,
            width: 1.0,
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: colorScheme.onSurface.withAlpha(12),
              blurRadius: 40.0,
              offset: const Offset(0.0, 12.0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: SfCalendar(
              controller: controller,
              view: CalendarView.month,
              headerHeight: 0.0,
              cellBorderColor: Colors.transparent,
              onViewChanged: onViewChanged,
              onTap: (details) {
                if (details.date != null) onTap(details.date!);
              },
              dataSource: _ActivityDataSource(
                activities.builder((activity, index) {
                  final discipline = adsDisciplines
                      .where((d) => d.id == activity.disciplineId)
                      .firstOrNull;

                  return Appointment(
                    id: activity.id,
                    startTime: activity.dueDate!,
                    endTime: activity.dueDate!.add(const Duration(hours: 1)),
                    subject: activity.title,
                    notes: discipline?.acronym ?? '',
                    color: activity.status.color(colorScheme),
                  );
                }),
              ),
              todayHighlightColor: colorScheme.primary,
              todayTextStyle: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w900,
                fontSize: 14.0,
                color: colorScheme.onPrimary,
              ),
              selectionDecoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: colorScheme.primary, width: 2.0),
              ),
              viewHeaderStyle: ViewHeaderStyle(
                dayTextStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.primary.withAlpha(180),
                ),
              ),
              monthViewSettings: MonthViewSettings(
                dayFormat: 'EEE',
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                monthCellStyle: MonthCellStyle(
                  textStyle: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                    color: colorScheme.onSurface,
                  ),
                  trailingDatesTextStyle: GoogleFonts.plusJakartaSans(
                    color: colorScheme.onSurface.withAlpha(60),
                    fontSize: 13.0,
                  ),
                  leadingDatesTextStyle: GoogleFonts.plusJakartaSans(
                    color: colorScheme.onSurface.withAlpha(60),
                    fontSize: 13.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityDataSource extends CalendarDataSource {
  _ActivityDataSource(List<Appointment> source) {
    appointments = source;
  }
}
