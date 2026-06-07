import 'package:academic_planner/src/shared/widgets/metadata_card/metadata_info_row_widget.dart';
import 'package:flutter/material.dart';

class MetadataCardWidget extends StatelessWidget {
  const MetadataCardWidget({
    required this.createdAt,
    required this.updatedAt,
    super.key,
  });

  final DateTime createdAt;
  final DateTime updatedAt;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: colorScheme.primary.withAlpha(15),
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: Row(
        children: [
          MetadataInfoRowWidget(
            label: 'Criado em',
            date: createdAt,
            icon: Icons.calendar_today_rounded,
          ),
          Container(
            width: 1.0,
            height: 40.0,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            color: colorScheme.primary.withAlpha(40),
          ),
          MetadataInfoRowWidget(
            label: 'Atualizado em',
            date: updatedAt,
            icon: Icons.edit_note_rounded,
          ),
        ],
      ),
    );
  }
}
