import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final TabController controller;
  final List<Tab> tabs;

  const TabBarWidget({super.key, required this.controller, required this.tabs});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return TabBar(
      controller: controller,
      labelColor: colorScheme.primary,
      unselectedLabelColor: colorScheme.onSurface.withAlpha(160),
      indicatorColor: colorScheme.primary,
      indicatorWeight: 3.0,
      dividerColor: theme.dividerTheme.color,
      labelStyle: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w800,
        fontSize: 14.0,
      ),
      unselectedLabelStyle: GoogleFonts.plusJakartaSans(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
      ),
      tabs: tabs,
    );
  }
}
