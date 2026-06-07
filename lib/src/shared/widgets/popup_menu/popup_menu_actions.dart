import 'package:academic_planner/src/shared/widgets/popup_menu/popup_menu_action_widget.dart';
import 'package:flutter/material.dart';

class PopupMenuActions {
  static PopupMenuItem<void> edit({required VoidCallback onTap}) {
    return PopupMenuItem<void>(
      onTap: onTap,
      child: const PopupMenuActionWidget(
        icon: Icons.edit_outlined,
        label: 'Editar',
      ),
    );
  }

  static PopupMenuItem<void> delete({
    required VoidCallback onTap,
    required Color color,
  }) {
    return PopupMenuItem<void>(
      onTap: onTap,
      child: PopupMenuActionWidget(
        icon: Icons.delete_outline_rounded,
        label: 'Excluir',
        color: color,
      ),
    );
  }
}
