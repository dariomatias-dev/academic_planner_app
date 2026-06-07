import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/features/disciplines/presentation/widgets/discipline_list_modal_widget.dart';
import 'package:academic_planner/src/shared/widgets/modal_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisciplineFilterSectionWidget extends StatelessWidget {
  const DisciplineFilterSectionWidget({
    required this.selectedId,
    required this.onSelected,
    super.key,
  });

  final int? selectedId;
  final void Function(int? id) onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedDiscipline = selectedId == null
        ? null
        : adsDisciplines.firstWhere((d) => d.id == selectedId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DISCIPLINA',
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.primary,
            fontSize: 11.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16.0),
        GestureDetector(
          onTap: () async {
            await ModalBottomSheetWidget.show<void>(
              context: context,
              title: 'Filtrar por Disciplina',
              child: DisciplineListModalWidget(
                selectedId: selectedId,
                disciplines: adsDisciplines,
                emptyTitle: 'Nenhuma disciplina disponível',
                emptyDescription:
                    'Não há disciplinas cadastradas para filtragem.',
                onSelected: (discipline) => onSelected(discipline.id),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: theme.dividerTheme.color ?? AppColors.transparent,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44.0,
                  height: 44.0,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Icon(
                    Icons.collections_bookmark_rounded,
                    color: colorScheme.primary,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedDiscipline?.name ?? 'Nenhuma disciplina',
                        style: GoogleFonts.plusJakartaSans(
                          color: selectedDiscipline == null
                              ? colorScheme.onSurface.withAlpha(120)
                              : colorScheme.onSurface,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        selectedDiscipline == null
                            ? 'Toque para selecionar'
                            : 'Filtro ativo',
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
      ],
    );
  }
}
