import 'package:academic_planner/src/core/domain/entities/discipline.dart';
import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DisciplineListModalWidget extends StatelessWidget {
  const DisciplineListModalWidget({
    required this.disciplines,
    required this.onSelected,
    super.key,
    this.selectedId,
    this.emptyTitle = 'Nenhuma disciplina',
    this.emptyDescription = 'Não encontramos disciplinas cadastradas.',
    this.actionLabel,
    this.onActionPressed,
  });

  final List<Discipline> disciplines;
  final int? selectedId;
  final String emptyTitle;
  final String emptyDescription;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final void Function(Discipline value) onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (disciplines.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.auto_stories_rounded,
        title: emptyTitle,
        description: emptyDescription,
        isCentered: false,
        actionLabel: actionLabel,
        onActionPressed: onActionPressed,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: disciplines.length,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) {
        final discipline = disciplines[index];
        final isSelected = selectedId == discipline.id;

        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            onTap: () {
              onSelected(discipline);

              Navigator.pop(context);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
              side: BorderSide(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                width: 1.5,
              ),
            ),
            tileColor: isSelected
                ? colorScheme.primary.withAlpha(15)
                : colorScheme.onSurface.withAlpha(5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            title: Text(
              discipline.name,
              style: GoogleFonts.plusJakartaSans(
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                fontSize: 14.0,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w700,
              ),
            ),
            subtitle: Text(
              discipline.acronym,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.0,
                color: colorScheme.onSurface.withAlpha(120),
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: isSelected
                ? Icon(Icons.check_circle_rounded, color: colorScheme.primary)
                : Icon(
                    Icons.circle_outlined,
                    color: colorScheme.onSurface.withAlpha(40),
                    size: 20.0,
                  ),
          ),
        );
      },
    );
  }
}
