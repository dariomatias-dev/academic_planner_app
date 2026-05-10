import 'package:flutter/material.dart';

import 'popup_menu_action_widget.dart';

class PopupMenuActions {
  static PopupMenuItem edit({required VoidCallback onTap}) {
    return PopupMenuItem(
      onTap: onTap,
      child: const PopupMenuActionWidget(
        icon: Icons.edit_outlined,
        label: 'Editar',
      ),
    );
  }

  static PopupMenuItem delete({
    required VoidCallback onTap,
    required Color color,
  }) {
    return PopupMenuItem(
      onTap: onTap,
      child: PopupMenuActionWidget(
        icon: Icons.delete_outline_rounded,
        label: 'Excluir',
        color: color,
      ),
    );
  }
}
