import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/activity_status_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/activity/domain/entities/activity.dart';

import 'package:academic_planner/src/shared/widgets/activity_card/activity_card_actions_modal/activity_card_actions_modal_widget.dart';
import 'package:academic_planner/src/shared/widgets/modal_bottom_sheet_widget.dart';

class ActivityCardWidget extends StatelessWidget {
  final Activity activity;

  const ActivityCardWidget({super.key, required this.activity});

  bool _isUrgent() {
    if (activity.dueDate == null ||
        activity.status == ActivityStatus.completed) {
      return false;
    }

    final now = DateTime.now();
    final difference = activity.dueDate!.difference(now);

    return difference.inDays <= 3;
  }

  void _showActionMenu(BuildContext context) {
    ModalBottomSheetWidget.show(
      context: context,
      child: ActivityCardActionsModalWidget(activity: activity),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final discipline = adsDisciplines.firstWhere(
      (d) => d.id == activity.disciplineId,
    );

    final isUrgent = _isUrgent();

    return GestureDetector(
      onTap: () {
        AppRoutes.goToActivityDetails(context, activityId: activity.id);
      },
      onLongPress: () => _showActionMenu(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28.0),
          border: Border.all(
            color: theme.dividerTheme.color ?? Colors.transparent,
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 54.0,
              height: 54.0,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Center(
                child: Text(
                  discipline.acronym,
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w900,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      if (activity.category != null) ...<Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 2.0,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withAlpha(20),
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: Text(
                            activity.category!.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              color: colorScheme.primary,
                              fontSize: 9.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                      ],
                      Container(
                        width: 6.0,
                        height: 6.0,
                        decoration: BoxDecoration(
                          color: activity.status.color(colorScheme),
                          shape: BoxShape.circle,
                        ),
                      ),
                      if (activity.dueDate != null) ...<Widget>[
                        const SizedBox(width: 8.0),
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 12.0,
                          color: colorScheme.onSurface.withAlpha(120),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          DateFormat('dd MMM').format(activity.dueDate!),
                          style: GoogleFonts.plusJakartaSans(
                            color: colorScheme.onSurface.withAlpha(160),
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6.0),
                  Text(
                    activity.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 15.0,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            if (isUrgent)
              Container(
                margin: const EdgeInsets.only(left: 8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(
                  Icons.priority_high_rounded,
                  size: 14.0,
                  color: colorScheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
