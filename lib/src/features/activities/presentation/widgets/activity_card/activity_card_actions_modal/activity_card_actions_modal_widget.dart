import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/actions/delete_activity_flow.dart';

class ActivityCardActionsModalWidget extends ConsumerWidget {
  final Activity activity;

  const ActivityCardActionsModalWidget({super.key, required this.activity});

  Future<void> _markAsCompleted(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(activityNotifierProvider.notifier);

    final result = await notifier.edit(
      activity.copyWith(status: ActivityStatus.completed),
    );

    result.when(
      onSuccess: (_) {
        Fluttertoast.showToast(msg: 'Atividade concluída!');

        Navigator.pop(context);
      },
      onFailure: (_) {
        Fluttertoast.showToast(msg: 'Erro ao atualizar atividade');
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final actions =
        <({IconData icon, String label, Color color, VoidCallback onTap})>[
          (
            icon: Icons.edit_note_rounded,
            label: 'Editar informações',
            color: colorScheme.primary,
            onTap: () {
              Navigator.pop(context);
              AppRoutes.goToActivityForm(context, activityId: activity.id);
            },
          ),
          if (activity.status != ActivityStatus.completed)
            (
              icon: Icons.check_circle_outline_rounded,
              label: 'Marcar como concluída',
              color: Colors.teal,
              onTap: () => _markAsCompleted(context, ref),
            ),
          (
            icon: Icons.delete_outline_rounded,
            label: 'Excluir permanentemente',
            color: colorScheme.error,
            onTap: () {
              deleteActivityFlow(
                context: context,
                ref: ref,
                activity: activity,
              );
            },
          ),
        ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text(
              "Ações da Atividade",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.primary,
                fontSize: 11.0,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              activity.title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface,
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32.0),
        ...actions.builder((action, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: action.onTap,
                borderRadius: BorderRadius.circular(20.0),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color:
                          theme.dividerTheme.color ??
                          colorScheme.onSurface.withAlpha(20),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: action.color.withAlpha(20),
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: Icon(
                          action.icon,
                          color: action.color,
                          size: 20.0,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Text(
                          action.label,
                          style: GoogleFonts.plusJakartaSans(
                            color: colorScheme.onSurface.withAlpha(220),
                            fontSize: 14.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20.0,
                        color: colorScheme.onSurface.withAlpha(60),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
