import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/shared/widgets/popup_menu/popup_menu.dart';

class DisciplineDetailsNotesTabWidget extends StatelessWidget {
  final int disciplineId;

  const DisciplineDetailsNotesTabWidget({
    super.key,
    required this.disciplineId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 120.0),
      itemCount: 8,
      itemBuilder: (context, index) {
        return const _NoteCardWidget();
      },
    );
  }
}

class _NoteCardWidget extends StatelessWidget {
  const _NoteCardWidget();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Text(
                  "Revisão de Arquitetura",
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              PopupMenuWidget<VoidCallback>(
                onSelected: (action) => action(),
                items: <PopupMenuEntry<VoidCallback>>[
                  PopupMenuItem<VoidCallback>(
                    value: () {},
                    height: 48.0,
                    child: const PopupMenuActionWidget(
                      icon: Icons.edit_outlined,
                      label: "Editar",
                    ),
                  ),
                  PopupMenuItem<VoidCallback>(
                    value: () {},
                    height: 48.0,
                    child: PopupMenuActionWidget(
                      icon: Icons.delete_outline_rounded,
                      label: "Excluir",
                      color: colorScheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            "Pontos importantes sobre a camada de domínio e a implementação de Use Cases seguindo os princípios do Clean Architecture...",
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface.withAlpha(160),
              fontSize: 13.0,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.calendar_today_rounded,
                  size: 12.0,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6.0),
                Text(
                  DateFormat(
                    "dd 'de' MMMM, yyyy",
                    'pt_BR',
                  ).format(DateTime.now()),
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.primary,
                    fontSize: 11.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
