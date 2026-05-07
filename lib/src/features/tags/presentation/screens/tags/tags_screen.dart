import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class TagModel {
  final String name;

  TagModel({required this.name});
}

class TagsScreen extends ConsumerWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final tags = <TagModel>[
      TagModel(name: "Urgente"),
      TagModel(name: "Trabalho"),
      TagModel(name: "Estudos"),
      TagModel(name: "Pesquisa"),
      TagModel(name: "Extensão"),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "Tags",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.add_rounded,
            onPressed: () {
              TagFormDialogWidget.show(context);
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
              border: Border.all(
                color:
                    Theme.of(context).dividerTheme.color ?? Colors.transparent,
              ),
              borderRadius: BorderRadius.circular(28.0),
            ),
            child: Row(
              children: <Widget>[
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
                      color: colorScheme.onSurface,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () {
                        TagFormDialogWidget.show(
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
                      onPressed: () {
                        TagDeleteDialogWidget.show(context, index: index);
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

class TagDeleteDialogWidget extends ConsumerWidget {
  final int index;

  const TagDeleteDialogWidget({super.key, required this.index});

  static Future<void> show(BuildContext context, {required int index}) {
    return showDialog(
      context: context,
      builder: (_) {
        return TagDeleteDialogWidget(index: index);
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DialogWidget(
      title: "Excluir Tag",
      message:
          "Tem certeza que deseja remover esta tag? Esta ação não pode ser desfeita.",
      icon: Icons.delete_outline_rounded,
      iconColor: Theme.of(context).colorScheme.error,
      actions: Row(
        children: <Widget>[
          Expanded(
            child: ButtonWidget(
              onPressed: () => Navigator.pop(context),
              label: "Cancelar",
              style: AppButtonStyle.neutral,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: ButtonWidget(
              onPressed: () => Navigator.pop(context),
              label: "Excluir",
              style: AppButtonStyle.destructiveSolid,
            ),
          ),
        ],
      ),
    );
  }
}

class TagFormDialogWidget extends ConsumerStatefulWidget {
  final TagModel? tag;
  final int? index;

  const TagFormDialogWidget({super.key, this.tag, this.index});

  static Future<void> show(BuildContext context, {TagModel? tag, int? index}) {
    return showDialog(
      context: context,
      builder: (_) {
        return TagFormDialogWidget(tag: tag, index: index);
      },
    );
  }

  @override
  ConsumerState<TagFormDialogWidget> createState() =>
      _TagFormDialogWidgetState();
}

class _TagFormDialogWidgetState extends ConsumerState<TagFormDialogWidget> {
  late final _controller = TextEditingController(text: widget.tag?.name);

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.tag != null;

    return DialogWidget(
      title: isEditing ? "Editar Tag" : "Nova Tag",
      message: "Defina um nome para a etiqueta que ajudará na sua organização.",
      icon: Icons.local_offer_rounded,
      actions: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const FormFieldLabelWidget(label: "Nome da Tag", isRequired: true),
          const SizedBox(height: 8.0),
          InputWidget(controller: _controller, hint: "Ex: Urgente"),
          const SizedBox(height: 32.0),
          Row(
            children: <Widget>[
              Expanded(
                child: ButtonWidget(
                  onPressed: () => Navigator.pop(context),
                  label: "Cancelar",
                  style: AppButtonStyle.neutral,
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ButtonWidget(
                  onPressed: () => Navigator.pop(context),
                  label: "Salvar",
                  style: AppButtonStyle.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
