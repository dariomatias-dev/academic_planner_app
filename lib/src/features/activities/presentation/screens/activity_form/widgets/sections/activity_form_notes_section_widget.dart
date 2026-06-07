import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:flutter/material.dart';

class ActivityFormNotesSectionWidget extends StatelessWidget {
  const ActivityFormNotesSectionWidget({
    required this.controller,
    super.key,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormSectionTitleWidget(title: 'Anotações'),
        InputWidget(
          controller: controller,
          hint: 'Rascunhos ou lembretes rápidos...',
          maxLines: 5,
        ),
      ],
    );
  }
}
