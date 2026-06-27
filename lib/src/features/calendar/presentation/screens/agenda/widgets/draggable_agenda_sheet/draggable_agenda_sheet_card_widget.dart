import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/extensions/activity_status_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DraggableAgendaSheetCardWidget extends StatelessWidget {
  const DraggableAgendaSheetCardWidget({
    required this.index,
    required this.activity,
    super.key,
  });
  final int index;
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = activity.status.color(colorScheme);

    final discipline = adsDisciplines
        .where((d) => d.id == activity.disciplineId)
        .firstOrNull;

    return GestureDetector(
      onTap: () async {
        await AppRoutes.goToActivityDetails(context, activityId: activity.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20.0),
        height: 120.0,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28.0),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.onSurface.withAlpha(6),
                    blurRadius: 16.0,
                    offset: const Offset(0.0, 6.0),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(28.0),
                  border: Border.all(
                    color: statusColor.withAlpha(20),
                    width: 1.5,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                    child: Row(
                      children: [
                        Container(
                          width: 6.0,
                          height: 44.0,
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: statusColor.withAlpha(40),
                                blurRadius: 8.0,
                                offset: const Offset(2.0, 0.0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                (discipline?.acronym ?? 'GERAL').toUpperCase(),
                                style: GoogleFonts.plusJakartaSans(
                                  color: statusColor,
                                  fontSize: 11.0,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                activity.title,
                                style: GoogleFonts.plusJakartaSans(
                                  color: colorScheme.onSurface,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                  height: 1.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule_rounded,
                                    size: 15.0,
                                    color: colorScheme.onSurface.withAlpha(100),
                                  ),
                                  const SizedBox(width: 6.0),
                                  Text(
                                    activity.dueDate != null
                                        ? DateFormat(
                                            'HH:mm',
                                          ).format(activity.dueDate!)
                                        : '--:--',
                                    style: GoogleFonts.plusJakartaSans(
                                      color: colorScheme.onSurface.withAlpha(
                                        160,
                                      ),
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: colorScheme.onSurface.withAlpha(60),
                          size: 26.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 40.0,
              bottom: -10.0,
              child: IgnorePointer(
                child: Text(
                  index.toString().padLeft(2, '0'),
                  style: GoogleFonts.plusJakartaSans(
                    color: statusColor.withAlpha(15),
                    fontSize: 58.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
