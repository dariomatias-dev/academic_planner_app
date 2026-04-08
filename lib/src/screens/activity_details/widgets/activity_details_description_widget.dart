import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/shared/utils/open_url.dart';

class ActivityDetailsDescriptionWidget extends StatefulWidget {
  final String description;

  const ActivityDetailsDescriptionWidget({
    super.key,
    required this.description,
  });

  @override
  State<ActivityDetailsDescriptionWidget> createState() =>
      _ActivityDetailsDescriptionWidgetState();
}

class _ActivityDetailsDescriptionWidgetState
    extends State<ActivityDetailsDescriptionWidget> {
  late QuillController _quillController;

  @override
  void initState() {
    super.initState();

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
          openUrl(context, url);
        },
      ),
    );
  }
}
