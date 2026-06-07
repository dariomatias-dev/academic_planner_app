import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:flutter/material.dart';

class PopupMenuWidget<T> extends StatelessWidget {
  PopupMenuWidget({
    required this.items,
    super.key,
    this.icon = Icons.more_vert_rounded,
    this.style = IconButtonStyle.primary,
  });

  final IconData icon;
  final List<PopupMenuEntry<T>> items;
  final IconButtonStyle style;

  final _menuKey = GlobalKey<PopupMenuButtonState<T>>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButtonWidget(
          onPressed: _menuKey.currentState?.showButtonMenu,
          icon: icon,
          style: style,
        ),
        SizedBox.shrink(
          child: PopupMenuButton<T>(
            key: _menuKey,
            offset: const Offset(0.0, 32.0),
            elevation: 8.0,
            color: colorScheme.surface,
            shadowColor: colorScheme.onSurface.withAlpha(40),
            surfaceTintColor: colorScheme.surface,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24.0),
              side: BorderSide(
                color: theme.dividerTheme.color ?? Colors.transparent,
              ),
            ),
            itemBuilder: (context) => items,
            child: const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
