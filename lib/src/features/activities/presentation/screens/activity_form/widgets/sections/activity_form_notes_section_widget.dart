import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/forms/forms.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';

class ActivityFormNotesSectionWidget extends StatelessWidget {
  final TextEditingController controller;

  const ActivityFormNotesSectionWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FormSectionTitleWidget(title: "Anotações"),
        InputWidget(
          controller: controller,
          hint: "Rascunhos ou lembretes rápidos...",
          maxLines: 5,
        ),
      ],
    );
  }
}
