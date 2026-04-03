import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/widgets/activity_card/activity_delete_dialog_widget.dart';
import 'package:academic_planner/src/shared/widgets/modal_bottom_sheet_widget.dart';

class ActivityCardWidget extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback? onTap;

  const ActivityCardWidget({super.key, required this.activity, this.onTap});

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
    final colorScheme = Theme.of(context).colorScheme;

    ModalBottomSheetWidget.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Ações da Atividade",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      activity.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w800,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 16.0,
                right: 16.0,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withAlpha(220),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: colorScheme.onSurface.withAlpha(200),
                      size: 24.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24.0),
          _ActionTile(
            icon: Icons.edit_rounded,
            label: "Editar atividade",
            onTap: () {
              AppRoutes.goToActivityForm(context, activityId: activity.id);

              Navigator.pop(context);
            },
          ),
          _ActionTile(
            icon: Icons.check_circle_rounded,
            label: "Marcar como concluída",
            color: Colors.teal,
            onTap: () => Navigator.pop(context),
          ),
          _ActionTile(
            icon: Icons.delete_outline_rounded,
            label: "Excluir atividade",
            color: colorScheme.error,
            onTap: () {
              ActivityDeleteDialogWidget.show(
                context,
                task: activity,
                onDelete: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          const SizedBox(height: 8.0),
        ],
      ),
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

    final statusColor = switch (activity.status) {
      ActivityStatus.completed => Colors.teal,
      ActivityStatus.inProgress => colorScheme.secondary,
      ActivityStatus.canceled => colorScheme.error.withAlpha(150),
      ActivityStatus.draft => colorScheme.onSurface.withAlpha(80),
      _ => Colors.orange,
    };

    return GestureDetector(
      onTap: onTap,
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
                    spacing: 8.0,
                    children: <Widget>[
                      if (activity.category != null)
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
                            activity.category?.toUpperCase() ?? '',
                            style: GoogleFonts.plusJakartaSans(
                              color: colorScheme.primary,
                              fontSize: 9.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      if (activity.dueDate != null)
                        Row(
                          children: <Widget>[
                            Container(
                              width: 6.0,
                              height: 6.0,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
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
                        ),
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

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.0),
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: colorScheme.surface.withAlpha(40),
          ),
          child: Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: effectiveColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Icon(icon, color: effectiveColor, size: 22.0),
              ),
              const SizedBox(width: 16.0),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.0,
                color: colorScheme.onSurface.withAlpha(40),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
