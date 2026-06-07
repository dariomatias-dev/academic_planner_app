import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/actions/delete_activity_flow.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityCardActionsModalWidget extends ConsumerWidget {
  const ActivityCardActionsModalWidget({required this.activity, super.key});

  final Activity activity;

  Future<void> _markAsCompleted(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(activityNotifierProvider.notifier);

    final result = await notifier.edit(
      activity.copyWith(status: ActivityStatus.completed),
    );

    result.when(
      onSuccess: (_) async {
        await Fluttertoast.showToast(msg: 'Atividade concluída!');

        if (!context.mounted) return;

        Navigator.pop(context);
      },
      onFailure: (_) async {
        await Fluttertoast.showToast(msg: 'Erro ao atualizar atividade');
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.45;

    final actions =
        <({IconData icon, String label, Color color, VoidCallback onTap})>[
          (
            icon: Icons.edit_note_rounded,
            label: 'Editar informações',
            color: colorScheme.primary,
            onTap: () async {
              Navigator.pop(context);

              await AppRoutes.goToActivityForm(
                context,
                activityId: activity.id,
              );
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
            onTap: () async {
              final deleted = await deleteActivityFlow(
                context: context,
                ref: ref,
                activity: activity,
              );

              if (deleted && context.mounted) Navigator.pop(context);
            },
          ),
        ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AÇÕES DA ATIVIDADE',
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
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.onSurface,
            fontSize: 20.0,
            fontWeight: FontWeight.w800,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 32.0),
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxHeight),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: actions.builder((action, index) {
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
                            children: [
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
              ),
            ),
          ),
        ),
        const SizedBox(height: 24.0),
        ButtonWidget(
          onPressed: () => Navigator.pop(context),
          label: 'Fechar',
          isFullWidth: true,
        ),
      ],
    );
  }
}
