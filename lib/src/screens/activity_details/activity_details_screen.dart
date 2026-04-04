import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/constants/mock_activities.dart';
import 'package:academic_planner/src/core/extensions/activity_status_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/screens/activity_details/widgets/activity_details_description_widget.dart';
import 'package:academic_planner/src/screens/activity_details/widgets/activity_details_discipline_widget.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/selectable_chip_widget.dart';

class ActivityDetailsScreen extends StatefulWidget {
  final String activityId;

  const ActivityDetailsScreen({super.key, required this.activityId});

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  late ActivityStatus? _originalStatus;
  late ActivityStatus? _currentStatus;

  bool get _hasStatusChanged => _originalStatus != _currentStatus;

  void _saveStatus() {
    setState(() {
      _originalStatus = _currentStatus;
    });

    Fluttertoast.showToast(msg: 'Status atualizado com sucesso!');
  }

  @override
  void initState() {
    super.initState();

    final activity = mockActivities.firstWhere(
      (a) => a.id == widget.activityId,
    );

    _originalStatus = activity.status;
    _currentStatus = activity.status;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activity = mockActivities.firstWhere(
      (a) => a.id == widget.activityId,
    );
    final discipline = adsDisciplines.firstWhere(
      (d) => d.id == activity.disciplineId,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "Detalhes",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.edit_outlined,
            onPressed: () {
              AppRoutes.goToActivityForm(context, activityId: activity.id);
            },
            style: IconButtonStyle.primary,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 140.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    if (activity.category != null) ...<Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withAlpha(25),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          activity.category!.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            color: colorScheme.primary,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12.0),
                    ],
                    Container(
                      width: 8.0,
                      height: 8.0,
                      decoration: BoxDecoration(
                        color:
                            _currentStatus?.color(colorScheme) ??
                            colorScheme.onSurface.withAlpha(80),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      (_currentStatus?.label ?? "Sem Status").toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        color: colorScheme.onSurface.withAlpha(150),
                        fontSize: 11.0,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                Text(
                  activity.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 24.0),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(24.0),
                    border: Border.all(
                      color: theme.dividerTheme.color ?? Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.calendar_today_rounded,
                        color: colorScheme.primary,
                        size: 20.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "PRAZO DE ENTREGA",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w900,
                                color: colorScheme.onSurface.withAlpha(120),
                              ),
                            ),
                            Text(
                              activity.dueDate != null
                                  ? DateFormat(
                                      "dd 'de' MMMM, yyyy",
                                      "pt_BR",
                                    ).format(activity.dueDate!)
                                  : "Sem data definida",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32.0),
                const ActivityDetailsSectionTitleWidget(
                  title: "Alterar Status",
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    spacing: 8.0,
                    children: ActivityStatus.values.map((status) {
                      final isSelected = _currentStatus == status;
                      return SelectableChipWidget(
                        onTap: () => setState(
                          () => _currentStatus = isSelected ? null : status,
                        ),
                        label: status.label,
                        isSelected: isSelected,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 32.0),
                const ActivityDetailsSectionTitleWidget(title: "Descrição"),
                ActivityDetailsDescriptionWidget(
                  description: activity.description,
                ),
                const SizedBox(height: 32.0),
                const ActivityDetailsSectionTitleWidget(title: "Disciplina"),
                ActivityDetailsDisciplineWidget(discipline: discipline),
                if (activity.tags.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 32.0),
                  const ActivityDetailsSectionTitleWidget(title: "Tags"),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: activity.tags.toList().map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color:
                                theme.dividerTheme.color ?? Colors.transparent,
                          ),
                        ),
                        child: Text(
                          "#$tag",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface.withAlpha(180),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                if (activity.reminders.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 32.0),
                  const ActivityDetailsSectionTitleWidget(title: "Lembretes"),
                  ...activity.reminders.map((time) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.notifications_active_outlined,
                            size: 20.0,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            time.format(context),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w800,
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
                if (activity.notes != null &&
                    activity.notes!.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 32.0),
                  const ActivityDetailsSectionTitleWidget(title: "Anotações"),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: Colors.amber.withAlpha(15),
                      borderRadius: BorderRadius.circular(24.0),
                      border: Border.all(color: Colors.amber.withAlpha(30)),
                    ),
                    child: Text(
                      activity.notes!,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15.0,
                        height: 1.5,
                        color: colorScheme.onSurface.withAlpha(200),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_hasStatusChanged)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      theme.scaffoldBackgroundColor.withAlpha(0),
                      theme.scaffoldBackgroundColor,
                    ],
                  ),
                ),
                child: ButtonWidget(
                  label: "Salvar Alterações",
                  onPressed: _saveStatus,
                  style: AppButtonStyle.primary,
                  isFullWidth: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ActivityDetailsSectionTitleWidget extends StatelessWidget {
  final String title;

  const ActivityDetailsSectionTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11.0,
          fontWeight: FontWeight.w900,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
