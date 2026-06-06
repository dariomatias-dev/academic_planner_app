import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/modal_bottom_sheet_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/empty_state_widget.dart';

class TagsFilterSectionWidget extends ConsumerWidget {
  final List<String> tags;
  final ValueChanged<List<String>> onChanged;

  const TagsFilterSectionWidget({
    super.key,
    required this.tags,
    required this.onChanged,
  });

  void _openModal(BuildContext context, WidgetRef ref) {
    final availableTags = ref.read(tagNotifierProvider).asData?.value ?? [];

    ModalBottomSheetWidget.show(
      context: context,
      title: 'Filtrar por Tags',
      child: _TagListModal(
        availableTags: availableTags.builder((t, index) => t.name),
        selected: tags,
        onConfirm: onChanged,
      ),
    );
  }

  String get _label {
    if (tags.isEmpty) return 'Nenhuma tag';
    if (tags.length == 1) return tags.first;

    return '${tags.length} tags selecionadas';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TAGS',
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.primary,
            fontSize: 11.0,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 16.0),
        GestureDetector(
          onTap: () => _openModal(context, ref),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(
                color: theme.dividerTheme.color ?? AppColors.transparent,
                width: 1.0,
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
                    Icons.tag_rounded,
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
                        _label,
                        style: GoogleFonts.plusJakartaSans(
                          color: tags.isEmpty
                              ? colorScheme.onSurface.withAlpha(120)
                              : colorScheme.onSurface,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        tags.isEmpty ? 'Toque para selecionar' : 'Filtro ativo',
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

class _TagListModal extends StatefulWidget {
  final List<String> availableTags;
  final List<String> selected;
  final ValueChanged<List<String>> onConfirm;

  const _TagListModal({
    required this.availableTags,
    required this.selected,
    required this.onConfirm,
  });

  @override
  State<_TagListModal> createState() => _TagListModalState();
}

class _TagListModalState extends State<_TagListModal> {
  late final _selected = List<String>.from(widget.selected);
  final _scrollController = ScrollController();

  void _toggle(String name) {
    setState(() {
      if (_selected.contains(name)) {
        _selected.remove(name);
      } else {
        _selected.add(name);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.availableTags.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.tag_rounded,
        title: 'Nenhuma tag',
        description: 'Não há tags cadastradas para filtragem.',
        isCentered: false,
      );
    }

    final maxListHeight = MediaQuery.sizeOf(context).height * 0.45;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxListHeight),
          child: ScrollbarTheme(
            data: ScrollbarThemeData(
              thumbColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.dragged)) {
                  return colorScheme.onSurface.withAlpha(90);
                }

                if (states.contains(WidgetState.hovered)) {
                  return colorScheme.onSurface.withAlpha(70);
                }

                return colorScheme.onSurface.withAlpha(45);
              }),
              trackColor: WidgetStatePropertyAll(
                colorScheme.onSurface.withAlpha(6),
              ),
              trackBorderColor: const WidgetStatePropertyAll(
                AppColors.transparent,
              ),
              thickness: const WidgetStatePropertyAll(4.0),
              radius: const Radius.circular(999.0),
              thumbVisibility: const WidgetStatePropertyAll(true),
            ),
            child: Scrollbar(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: widget.availableTags.length,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                itemBuilder: (context, index) {
                  final name = widget.availableTags[index];
                  final isSelected = _selected.contains(name);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      onTap: () => _toggle(name),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
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
                        name,
                        style: GoogleFonts.plusJakartaSans(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                          fontSize: 14.0,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w700,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                              Icons.check_circle_rounded,
                              color: colorScheme.primary,
                            )
                          : Icon(
                              Icons.circle_outlined,
                              color: colorScheme.onSurface.withAlpha(40),
                              size: 20.0,
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: ButtonWidget(
                onPressed: () {
                  setState(() => _selected.clear());
                },
                label: 'Limpar',
                style: AppButtonStyle.outline,
              ),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: ButtonWidget(
                onPressed: () {
                  widget.onConfirm(_selected);

                  Navigator.pop(context);
                },
                label: 'Filtrar',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
