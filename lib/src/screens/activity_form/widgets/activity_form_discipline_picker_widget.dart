import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/notifiers/user_disciplines_notifier.dart';

import 'package:academic_planner/src/screens/activity_form/activity_form_screen.dart';

import 'package:academic_planner/src/shared/models/discipline_model.dart';
import 'package:academic_planner/src/shared/widgets/discipline_list_modal_widget.dart';
import 'package:academic_planner/src/shared/widgets/form_error_message_widget.dart';
import 'package:academic_planner/src/shared/widgets/modal_bottom_sheet_widget.dart';

class ActivityFormDisciplinePickerWidget extends StatefulWidget {
  final DisciplineModel? selectedDiscipline;
  final bool isRequired;
  final String? Function(DisciplineModel?)? validator;
  final Function(DisciplineModel value) onSelected;

  const ActivityFormDisciplinePickerWidget({
    super.key,
    this.selectedDiscipline,
    this.isRequired = false,
    this.validator,
    required this.onSelected,
  });

  @override
  State<ActivityFormDisciplinePickerWidget> createState() =>
      _ActivityFormDisciplinePickerWidgetState();
}

class _ActivityFormDisciplinePickerWidgetState
    extends State<ActivityFormDisciplinePickerWidget> {
  late final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FormField<DisciplineModel>(
      initialValue: widget.selectedDiscipline,
      validator: (value) {
        if (widget.isRequired && widget.selectedDiscipline == null) {
          return "A disciplina é obrigatória";
        }

        return widget.validator?.call(value);
      },
      builder: (state) {
        final hasError = state.hasError;
        final isFocused = _focusNode.hasFocus;

        Color borderColor;
        double borderWidth;

        if (hasError) {
          borderColor = colorScheme.error;
          borderWidth = isFocused ? 1.5 : 1.2;
        } else if (isFocused) {
          borderColor = colorScheme.primary;
          borderWidth = 1.5;
        } else {
          borderColor = theme.dividerTheme.color ?? AppColors.transparent;
          borderWidth = 1.0;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ActivityFormLabelWidget(
              label: "Disciplina",
              isRequired: widget.isRequired,
            ),
            const SizedBox(height: 8.0),
            Focus(
              focusNode: _focusNode,
              child: GestureDetector(
                onTap: () {
                  _focusNode.unfocus();

                  ModalBottomSheetWidget.show(
                    context: context,
                    title: "Minhas Disciplinas",
                    child: DisciplineListModalWidget(
                      selectedId: widget.selectedDiscipline?.id,
                      disciplines: adsDisciplines.filter((d) {
                        return context
                            .read<UserDisciplinesNotifier>()
                            .selectedIds
                            .contains(d.id);
                      }),
                      emptyDescription:
                          'Para vincular atividades, selecione as disciplinas cursadas na sua grade.',
                      actionLabel: 'Configurar',
                      onActionPressed: () {
                        AppRoutes.goToDisciplineSelection(context);
                      },
                      onSelected: widget.onSelected,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: borderColor, width: borderWidth),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 44.0,
                        height: 44.0,
                        decoration: BoxDecoration(
                          color:
                              (hasError
                                      ? colorScheme.error
                                      : colorScheme.primary)
                                  .withAlpha(15),
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                        child: Icon(
                          Icons.collections_bookmark_rounded,
                          color: hasError
                              ? colorScheme.error
                              : colorScheme.primary,
                          size: 20.0,
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.selectedDiscipline?.name ??
                                  "Nenhuma disciplina",
                              style: GoogleFonts.plusJakartaSans(
                                color: widget.selectedDiscipline == null
                                    ? colorScheme.onSurface.withAlpha(120)
                                    : colorScheme.onSurface,
                                fontSize: 15.0,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              widget.selectedDiscipline == null
                                  ? "Toque para vincular uma disciplina"
                                  : "Disciplina selecionada",
                              style: GoogleFonts.plusJakartaSans(
                                color: colorScheme.onSurface.withAlpha(100),
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.unfold_more_rounded,
                        color: colorScheme.onSurface.withAlpha(60),
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FormErrorMessageWidget(
              hasError: hasError,
              errorText: state.errorText,
            ),
          ],
        );
      },
    );
  }
}
