import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';

import 'package:academic_planner/src/features/activities/presentation/actions/delete_activity_flow.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_card/activity_card_actions_modal/activity_card_action_tile_modal_widget.dart';

class ActivityCardActionsModalWidget extends ConsumerStatefulWidget {
  final Activity activity;

  const ActivityCardActionsModalWidget({super.key, required this.activity});

  @override
  ConsumerState<ActivityCardActionsModalWidget> createState() =>
      _ActivityCardActionsModalWidgetState();
}

class _ActivityCardActionsModalWidgetState
    extends ConsumerState<ActivityCardActionsModalWidget> {
  Future<void> _markAsCompleted(BuildContext context) async {
    final activityNotifier = ref.read(activityNotifierProvider.notifier);

    final updated = widget.activity.copyWith(status: ActivityStatus.completed);

    final result = await activityNotifier.edit(updated);

    result.when(
      onSuccess: (_) {
        Fluttertoast.showToast(msg: "Atividade concluída!");
        Navigator.pop(context);
      },
      onFailure: (failure) {
        Fluttertoast.showToast(msg: "Erro ao atualizar atividade");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
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
                    widget.activity.title,
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
            GestureDetector(
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
          ],
        ),
        const SizedBox(height: 24.0),
        ActivityCardActionTileModalWidget(
          icon: Icons.edit_rounded,
          label: "Editar atividade",
          onTap: () {
            Navigator.pop(context);

            AppRoutes.goToActivityForm(context, activityId: widget.activity.id);
          },
        ),
        if (widget.activity.status != ActivityStatus.completed)
          ActivityCardActionTileModalWidget(
            icon: Icons.check_circle_rounded,
            label: "Marcar como concluída",
            color: Colors.teal,
            onTap: () => _markAsCompleted(context),
          ),
        ActivityCardActionTileModalWidget(
          icon: Icons.delete_outline_rounded,
          label: "Excluir atividade",
          color: colorScheme.error,
          onTap: () {
            deleteActivityFlow(
              context: context,
              ref: ref,
              activity: widget.activity,
            );
          },
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}
