import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/tags/presentation/widgets/dialogs/tag_form_dialog_widget.dart';
import 'package:academic_planner/src/shared/actions/removal_flow.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class TagsScreen extends ConsumerWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final tags = ref.watch(tagNotifierProvider).asData?.value ?? [];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: 'Tags',
        actions: [
          IconButtonWidget(
            icon: Icons.add_rounded,
            onPressed: () async {
              await TagFormDialogWidget.show(context);
            },
            style: IconButtonStyle.primary,
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 120.0),
        itemCount: tags.length,
        itemBuilder: (context, index) {
          final tag = tags[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(28.0),
              border: Border.all(
                color:
                    Theme.of(context).dividerTheme.color ?? Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 54.0,
                  height: 54.0,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: Icon(
                    Icons.local_offer_rounded,
                    color: colorScheme.primary,
                    size: 22.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    tag.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 16.0,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () async {
                        await TagFormDialogWidget.show(
                          context,
                          tag: tag,
                          index: index,
                        );
                      },
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 20.0,
                        color: colorScheme.onSurface.withAlpha(120),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await removalFlow(
                          context: context,
                          confirmTitle: 'Excluir Tag',
                          confirmMessage:
                              'Tem certeza que deseja remover esta tag? '
                              'Esta ação não pode ser desfeita.',
                          onDelete: () {
                            return resultToError(
                              ref
                                  .read(tagNotifierProvider.notifier)
                                  .remove(index),
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        size: 20.0,
                        color: colorScheme.error.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
