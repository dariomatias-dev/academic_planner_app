import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/logging/logger_provider.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_discipline_widget.dart';
import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/presentation/actions/delete_note_flow.dart';

import 'package:academic_planner/src/shared/utils/open_url.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/popup_menu/popup_menu.dart';
import 'package:academic_planner/src/shared/widgets/states/states.dart';

final noteDetailProvider = FutureProvider.family<Note?, String>((
  ref,
  noteId,
) async {
  ref.watch(noteNotifierProvider);

  final notifier = ref.read(noteNotifierProvider.notifier);
  final result = await notifier.getById(noteId);

  return result.fold(onSuccess: (note) => note, onFailure: (_) => null);
});

class NoteDetailsScreen extends ConsumerWidget {
  final String noteId;

  const NoteDetailsScreen({super.key, required this.noteId});

  Future<void> _deleteNote(
    BuildContext context,
    WidgetRef ref,
    Note note,
  ) async {
    await deleteNoteFlow(context: context, ref: ref, note: note);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final noteAsync = ref.watch(noteDetailProvider(noteId));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: noteAsync.value?.title ?? 'Detalhes',
        actions: <Widget>[
          noteAsync.maybeWhen(
            data: (note) => note == null
                ? const SizedBox.shrink()
                : PopupMenuWidget(
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
                        onTap: () {
                          _deleteNote(context, ref, note);
                        },
                        color: colorScheme.error,
                      ),
                    ],
                  ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: noteAsync.when(
        loading: () {
          return const LoadingStateWidget();
        },
        error: (_, _) {
          return EmptyStateWidget(
            icon: Icons.error_outline_rounded,
            title: "Erro ao carregar",
            description: "Não foi possível carregar os detalhes desta nota.",
            actionLabel: "Tentar novamente",
            onActionPressed: () {
              ref.invalidate(noteDetailProvider(noteId));
            },
          );
        },
        data: (note) {
          if (note == null) {
            return const EmptyStateWidget(
              icon: Icons.notes_rounded,
              title: "Anotação não encontrada",
              description: "Os dados desta anotação não estão disponíveis.",
            );
          }

          final discipline = adsDisciplines
              .where((d) => d.id == note.disciplineId)
              .firstOrNull;

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (discipline != null) ...<Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withAlpha(25),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      discipline.acronym.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        color: colorScheme.primary,
                        fontSize: 10.0,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
                Text(
                  note.title,
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.onSurface,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 32.0),
                const _NoteSectionTitleWidget(title: "Conteúdo"),
                NoteDetailsDescriptionWidget(description: note.content),
                if (discipline != null) ...<Widget>[
                  const SizedBox(height: 32.0),
                  const _NoteSectionTitleWidget(title: "Disciplina"),
                  ActivityDetailsDisciplineWidget(discipline: discipline),
                ],
                const SizedBox(height: 48.0),
                const _NoteSectionTitleWidget(title: "Metadados"),
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      _buildMetadataInfo(
                        context,
                        "Criada",
                        note.createdAt,
                        Icons.calendar_today_rounded,
                      ),
                      Container(
                        width: 1.0,
                        height: 40.0,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        color: colorScheme.primary.withAlpha(40),
                      ),
                      _buildMetadataInfo(
                        context,
                        "Editada",
                        note.updatedAt,
                        Icons.edit_note_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetadataInfo(
    BuildContext context,
    String label,
    DateTime date,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Row(
        children: <Widget>[
          Icon(icon, size: 20.0, color: colorScheme.primary),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.primary.withAlpha(180),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  DateFormat('dd/MM/yyyy').format(date),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w800,
                    color: colorScheme.onSurface,
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

class _NoteSectionTitleWidget extends StatelessWidget {
  final String title;

  const _NoteSectionTitleWidget({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11.0,
          fontWeight: FontWeight.w900,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class NoteDetailsDescriptionWidget extends ConsumerStatefulWidget {
  final String description;

  const NoteDetailsDescriptionWidget({super.key, required this.description});

  @override
  ConsumerState<NoteDetailsDescriptionWidget> createState() =>
      _NoteDetailsDescriptionWidgetState();
}

class _NoteDetailsDescriptionWidgetState
    extends ConsumerState<NoteDetailsDescriptionWidget> {
  late QuillController _quillController;

  void _initializeController() {
    if (widget.description.startsWith('[') ||
        widget.description.startsWith('{')) {
      _quillController = QuillController(
        document: Document.fromJson(jsonDecode(widget.description)),
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      );
    } else {
      final doc = Document()..insert(0, widget.description);
      _quillController = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
        readOnly: true,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    _initializeController();
  }

  @override
  void didUpdateWidget(covariant NoteDetailsDescriptionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.description != widget.description) {
      _initializeController();
    }
  }

  @override
  void dispose() {
    _quillController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final defaultStyles = DefaultStyles(
      paragraph: DefaultTextBlockStyle(
        GoogleFonts.plusJakartaSans(
          fontSize: 16.0,
          color: colorScheme.onSurface.withAlpha(180),
          height: 1.6,
        ),
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(0, 0),
        const VerticalSpacing(0, 0),
        null,
      ),
      link: GoogleFonts.plusJakartaSans(
        color: colorScheme.primary,
        fontWeight: FontWeight.w700,
        decoration: TextDecoration.underline,
      ),
    );

    return QuillEditor(
      controller: _quillController,
      scrollController: ScrollController(),
      focusNode: FocusNode(),
      config: QuillEditorConfig(
        scrollable: false,
        autoFocus: false,
        expands: false,
        showCursor: false,
        padding: EdgeInsets.zero,
        customStyles: defaultStyles,
        onLaunchUrl: (url) async {
          openUrl(context, url, logger: ref.read(loggerProvider));
        },
      ),
    );
  }
}
