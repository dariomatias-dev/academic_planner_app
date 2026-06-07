import 'dart:async';

import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';
import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TagFormDialogWidget extends ConsumerStatefulWidget {
  const TagFormDialogWidget({super.key, this.tag, this.index});

  final Tag? tag;
  final int? index;

  static Future<void> show(BuildContext context, {Tag? tag, int? index}) {
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

  Future<void> _handleSave() async {
    final name = _controller.text.trim();

    if (name.isEmpty) return;

    final isEditing = widget.tag != null;
    final notifier = ref.read(tagNotifierProvider.notifier);

    (isEditing
            ? await notifier.edit(widget.index!, name)
            : await notifier.add(name))
        .when(
          onSuccess: (_) {
            if (context.mounted) Navigator.pop(context);
          },
          onFailure: (failure) {
            unawaited(Fluttertoast.showToast(msg: failure.message));
          },
        );
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.tag != null;

    return DialogWidget(
      title: isEditing ? 'Editar Tag' : 'Nova Tag',
      message: 'Defina um nome para rotular suas atividades de forma rápida.',
      icon: Icons.local_offer_rounded,
      actions: Column(
        children: [
          const FormFieldLabelWidget(label: 'Nome da Tag', isRequired: true),
          const SizedBox(height: 8.0),
          InputWidget(controller: _controller, hint: 'Ex: Urgente'),
          const SizedBox(height: 32.0),
          Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  label: 'Cancelar',
                  style: AppButtonStyle.neutral,
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(width: 12.0),
              Expanded(
                child: ButtonWidget(
                  label: 'Salvar',
                  onPressed: _handleSave,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
