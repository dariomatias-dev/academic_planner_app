import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/activity_status_extension.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/filters/agenda_filter_modal_widget.dart';
import 'package:academic_planner/src/features/agenda/widgets/draggable_agenda_sheet/draggable_agenda_sheet_widget.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';

class AgendaScreen extends ConsumerStatefulWidget {
  const AgendaScreen({super.key});

  @override
  ConsumerState<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends ConsumerState<AgendaScreen> {
  final _calendarController = CalendarController();

  DateTime _displayDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();

  ActivityFilter? _currentFilter;

  final _isLoadingNotifier = ValueNotifier(true);

  final _activities = <Activity>[];

  Future<void> _fetchData({ActivityFilter? filter}) async {
    _isLoadingNotifier.value = true;

    final activityNotifier = ref.read(activityNotifierProvider.notifier);
    final result = await activityNotifier.getAll(filter: filter);

    result.fold(
      onSuccess: (activities) {
        _activities
          ..clear()
          ..addAll(activities.filter((a) => a.dueDate != null));

        _isLoadingNotifier.value = false;
      },
      onFailure: (_) {
        _isLoadingNotifier.value = false;
      },
    );
  }

  void _onViewChanged(ViewChangedDetails details) {
    if (details.visibleDates.isNotEmpty) {
      final midDate = details.visibleDates[details.visibleDates.length ~/ 2];

      if (midDate.month != _displayDate.month ||
          midDate.year != _displayDate.year) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _displayDate = midDate);
        });
      }
    }
  }

  void _openFilterModal() {
    AgendaFilterModalWidget.show(
      context,
      initialFilter: _currentFilter,
      onApply: (filter) {
        _currentFilter = filter;

        _fetchData(filter: filter);
      },
      onClear: () {
        _currentFilter = null;
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchData());
  }

  @override
  void dispose() {
    _calendarController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
      body: ValueListenableBuilder(
        valueListenable: _isLoadingNotifier,
        builder: (context, loading, _) {
          if (loading) {
            return const LoadingStateWidget();
          }

          return Stack(
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
                    activities: _activities,
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
                    activities: _activities,
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

class _ActivityDataSource extends CalendarDataSource {
  _ActivityDataSource(List<Appointment> source) {
    appointments = source;
  }
}
