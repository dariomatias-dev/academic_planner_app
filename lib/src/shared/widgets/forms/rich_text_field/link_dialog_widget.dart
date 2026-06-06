import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/validators.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';

class LinkDialogWidget extends StatefulWidget {
  final String? initialText;
  final String? initialUrl;

  const LinkDialogWidget({
    super.key,
    this.initialText,
    this.initialUrl,
  });

  static Future<Map<String, String>?> show(
    BuildContext context, {
    String? initialText,
    String? initialUrl,
  }) async {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) => LinkDialogWidget(
        initialText: initialText,
        initialUrl: initialUrl,
      ),
    );
  }

  @override
  State<LinkDialogWidget> createState() => _LinkDialogWidgetState();
}

class _LinkDialogWidgetState extends State<LinkDialogWidget> {
  final _formKey = GlobalKey<FormState>();

  late final _textController = TextEditingController(text: widget.initialText);
  late final _urlController = TextEditingController(text: widget.initialUrl);

  void _onConfirm() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.pop(context, {
        'text': _textController.text,
        'url': _urlController.text,
      });
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _urlController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DialogWidget(
      title: "Adicionar Link",
      message: "Insira o texto de exibição e o endereço da URL para o link.",
      icon: Icons.link_rounded,
      actions: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputWidget(
              controller: _textController,
              hint: "Texto para exibir (ex: Documentação)",
              validator: Validators.required,
            ),
            const SizedBox(height: 16.0),
            InputWidget(
              controller: _urlController,
              hint: "Endereço URL (ex: https://...)",
              validator: Validators.multiple([
                Validators.required,
                Validators.url,
              ]),
            ),
            const SizedBox(height: 32.0),
            Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    label: "Cancelar",
                    onPressed: () => Navigator.pop(context),
                    style: AppButtonStyle.neutral,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ButtonWidget(
                    label: "Adicionar",
                    onPressed: _onConfirm,
                    style: AppButtonStyle.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
