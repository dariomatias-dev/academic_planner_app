import 'package:app_ui/src/typography/app_typography.dart';
import 'package:flutter/material.dart';

class TabBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const TabBarWidget({
    required this.controller,
    required this.tabs,
    super.key,
    this.backgroundColor = Colors.transparent,
  });

  final TabController controller;
  final List<Tab> tabs;
  final Color backgroundColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: backgroundColor,
      child: TabBar(
        controller: controller,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withAlpha(160),
        indicatorColor: colorScheme.primary,
        indicatorWeight: 3.0,
        dividerColor: theme.dividerTheme.color,
        labelStyle: AppTypography.style(
          fontWeight: FontWeight.w800,
          fontSize: 14.0,
        ),
        unselectedLabelStyle: AppTypography.style(
          fontWeight: FontWeight.w600,
          fontSize: 14.0,
        ),
        tabs: tabs,
      ),
    );
  }
}
