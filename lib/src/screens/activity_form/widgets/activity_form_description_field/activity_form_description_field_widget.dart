import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/app_validators.dart';

import 'package:academic_planner/src/screens/activity_form/activity_form_screen.dart';
import 'package:academic_planner/src/screens/activity_form/widgets/activity_form_description_field/activity_form_link_dialog_widget.dart';

import 'package:academic_planner/src/shared/widgets/form_error_message_widget.dart';

class ActivityFormDescriptionFieldWidget extends StatefulWidget {
  final QuillController controller;

  const ActivityFormDescriptionFieldWidget({
    super.key,
    required this.controller,
  });

  @override
  State<ActivityFormDescriptionFieldWidget> createState() =>
      _ActivityFormDescriptionFieldWidgetState();
}

class _ActivityFormDescriptionFieldWidgetState
    extends State<ActivityFormDescriptionFieldWidget> {
  late final _scrollController = ScrollController();
  late final _focusNode = FocusNode();

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final textStyle = GoogleFonts.plusJakartaSans(
      fontSize: 14.0,
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w600,
    );

    final hintStyle = GoogleFonts.plusJakartaSans(
      fontSize: 14.0,
      color: colorScheme.onSurface.withAlpha(120),
      fontWeight: FontWeight.w500,
    );

    final defaultStyles = DefaultStyles(
      paragraph: DefaultTextBlockStyle(
        textStyle,
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(0, 0),
        const VerticalSpacing(0, 0),
        null,
      ),
      link: textStyle.copyWith(
        color: colorScheme.primary,
        decoration: TextDecoration.underline,
      ),
      placeHolder: DefaultTextBlockStyle(
        hintStyle,
        const HorizontalSpacing(0, 0),
        const VerticalSpacing(0, 0),
        const VerticalSpacing(0, 0),
        null,
      ),
    );

    return FormField<String>(
      initialValue: widget.controller.document.toPlainText().trim(),
      validator: (validator) {
        return AppValidators.required(
          validator,
          message: "A descrição é obrigatória",
        );
      },
      builder: (state) {
        widget.controller.addListener(() {
          final plainText = widget.controller.document.toPlainText().trim();
          if (state.value != plainText) {
            state.didChange(plainText);
          }
        });

        final hasError = state.hasError;
        final isFocused = _focusNode.hasFocus;

        Color borderColor;

        if (hasError) {
          borderColor = colorScheme.error;
        } else if (isFocused) {
          borderColor = colorScheme.primary;
        } else {
          borderColor = theme.dividerTheme.color ?? AppColors.transparent;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ActivityFormLabelWidget(label: 'Descrição', isRequired: true),
            const SizedBox(height: 8.0),
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: borderColor, width: 1.0),
              ),
              child: Column(
                children: <Widget>[
                  QuillSimpleToolbar(
                    controller: widget.controller,
                    config: QuillSimpleToolbarConfig(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16.0),
                        ),
                      ),
                      buttonOptions: QuillSimpleToolbarButtonOptions(
                        base: QuillToolbarBaseButtonOptions(
                          iconTheme: QuillIconTheme(
                            iconButtonSelectedData: IconButtonData(
                              color: colorScheme.primary,
                              style: IconButton.styleFrom(
                                backgroundColor: colorScheme.primary.withAlpha(
                                  20,
                                ),
                              ),
                            ),
                            iconButtonUnselectedData: IconButtonData(
                              color: colorScheme.onSurface.withAlpha(160),
                            ),
                          ),
                        ),
                      ),
                      showFontSize: false,
                      showFontFamily: false,
                      showSubscript: false,
                      showSuperscript: false,
                      showSmallButton: false,
                      showInlineCode: false,
                      showDirection: false,
                      showSearchButton: false,
                      showCodeBlock: false,
                      showQuote: false,
                      showHeaderStyle: false,
                      showColorButton: false,
                      showBackgroundColorButton: false,
                      showListCheck: false,
                      multiRowsDisplay: false,
                      showLink: false,
                      customButtons: <QuillToolbarCustomButtonOptions>[
                        QuillToolbarCustomButtonOptions(
                          icon: const Icon(Icons.link_rounded),
                          onPressed: () async {
                            final selection = widget.controller.selection;

                            String? selectedText;
                            if (!selection.isCollapsed) {
                              selectedText = widget.controller.document
                                  .getPlainText(
                                    selection.start,
                                    selection.end - selection.start,
                                  );
                            }

                            final result =
                                await ActivityFormLinkDialogWidget.show(
                                  context,
                                  initialText: selectedText,
                                  initialUrl: '',
                                );

                            if (result != null) {
                              final insertIndex = selection.start;

                              widget.controller.replaceText(
                                insertIndex,
                                selection.isCollapsed
                                    ? 0
                                    : selection.end - selection.start,
                                result['text'] ?? result['url'] ?? '',
                                null,
                              );

                              widget.controller.formatText(
                                insertIndex,
                                (result['text'] ?? result['url'] ?? '').length,
                                LinkAttribute(result['url'] ?? ''),
                              );

                              widget.controller.updateSelection(
                                TextSelection.collapsed(
                                  offset:
                                      insertIndex +
                                      (result['text'] ?? result['url'] ?? '')
                                          .length,
                                ),
                                ChangeSource.local,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 1.0,
                    thickness: 1.0,
                    color: borderColor.withAlpha(50),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 12.0,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 120.0),
                      child: QuillEditor(
                        controller: widget.controller,
                        scrollController: _scrollController,
                        focusNode: _focusNode,
                        config: QuillEditorConfig(
                          scrollable: false,
                          autoFocus: false,
                          expands: false,
                          padding: EdgeInsets.zero,
                          placeholder: "Mais detalhes sobre a atividade...",
                          customStyles: defaultStyles,
                          onTapOutside: (event, focusNode) {
                            focusNode.unfocus();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
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
