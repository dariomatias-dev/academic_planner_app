import 'package:flutter/material.dart';

import 'package:academic_planner/src/shared/widgets/popup_menu/popup_menu.dart';

class ActivityDetailsMenuWidget extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ActivityDetailsMenuWidget({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopupMenuWidget<VoidCallback>(
      onSelected: (action) => action(),
      items: <PopupMenuEntry<VoidCallback>>[
        PopupMenuItem<VoidCallback>(
          value: onEdit,
          height: 48.0,
          child: const PopupMenuActionWidget(
            icon: Icons.edit_outlined,
            label: "Editar",
          ),
        ),
        const PopupMenuDivider(height: 1.0),
        PopupMenuItem<VoidCallback>(
          value: onDelete,
          height: 48.0,
          child: PopupMenuActionWidget(
            icon: Icons.delete_outline_rounded,
            label: "Excluir",
            color: colorScheme.error,
          ),
        ),
      ],
    );
  }
}
