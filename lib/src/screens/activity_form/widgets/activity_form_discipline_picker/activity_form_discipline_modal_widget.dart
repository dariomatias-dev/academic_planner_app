import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/notifiers/user_disciplines_notifier.dart';

import 'package:academic_planner/src/shared/models/discipline_model.dart';

class ActivityFormDisciplineModalWidget extends StatelessWidget {
  final int? selectedId;
  final Function(DisciplineModel value) onSelected;

  const ActivityFormDisciplineModalWidget({
    super.key,
    this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userDisciplinesNotifier = context.watch<UserDisciplinesNotifier>();

    final enrolled = adsDisciplines.filter((discipline) {
      return userDisciplinesNotifier.selectedIds.contains(discipline.id);
    });

    return ListView.builder(
      shrinkWrap: true,
      itemCount: enrolled.length,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (context, index) {
        final discipline = enrolled[index];
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
