import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:flutter/material.dart';

class InputFieldWidget extends StatelessWidget {
  const InputFieldWidget({
    required this.controller,
    required this.label,
    required this.hint,
    super.key,
    this.maxLines = 1,
    this.isRequired = false,
    this.validator,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final bool isRequired;
  final String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldLabelWidget(label: label, isRequired: isRequired),
        const SizedBox(height: 8.0),
        InputWidget(
          controller: controller,
          hint: hint,
          maxLines: maxLines,
          validator: validator,
        ),
      ],
    );
  }
}
