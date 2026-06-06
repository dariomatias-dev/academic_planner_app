import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:academic_planner/src/core/validators.dart';

import 'package:academic_planner/src/shared/widgets/forms/forms.dart';

class ActivityFormContentSectionWidget extends StatelessWidget {
  final TextEditingController titleController;
  final QuillController descriptionController;

  const ActivityFormContentSectionWidget({
    super.key,
    required this.titleController,
    required this.descriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const FormSectionTitleWidget(
          title: "Conteúdo",
          padding: EdgeInsets.only(bottom: 16.0),
        ),
        InputFieldWidget(
          controller: titleController,
          label: "Título",
          hint: "O que deve ser feito?",
          isRequired: true,
          validator: (value) => Validators.required(
            value?.trim(),
            message: "O título é obrigatório",
          ),
        ),
        const SizedBox(height: 20.0),
        RichTextFieldWidget(
          controller: descriptionController,
          label: "Descrição",
          placeholder: "Mais detalhes sobre a atividade...",
          validatorMessage: "A descrição é obrigatória",
        ),
      ],
    );
  }
}
