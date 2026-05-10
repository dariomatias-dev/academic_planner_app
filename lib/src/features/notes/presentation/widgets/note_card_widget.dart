import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/presentation/actions/delete_note_flow.dart';

import 'package:academic_planner/src/shared/widgets/popup_menu/popup_menu.dart';

enum NoteCardAction { edit, delete }

class NoteCardWidget extends ConsumerWidget {
  final Note note;

  const NoteCardWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: () {
        AppRoutes.goToNoteDetails(context, noteId: note.id);
      },
      child: Container(
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
                    note.title,
                    style: GoogleFonts.plusJakartaSans(
                      color: colorScheme.onSurface,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                PopupMenuWidget(
                  items: <PopupMenuEntry>[
                    PopupMenuActions.edit(
                      onTap: () {
                        AppRoutes.goToNoteForm(
                          context,
                          noteId: note.id,
                          disciplineId: note.disciplineId,
                        );
                      },
                    ),
                    PopupMenuActions.delete(
                      color: colorScheme.error,
                      onTap: () async {
                        await deleteNoteFlow(
                          context: context,
                          ref: ref,
                          note: note,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
              "Toque para visualizar o conteúdo completo da anotação...",
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
                    ).format(note.updatedAt),
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
      ),
    );
  }
}
