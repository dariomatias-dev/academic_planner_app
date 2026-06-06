import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/shared/widgets/nav_bar/nav_item_widget.dart';

class NavBarWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const NavBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Positioned(
      bottom: 24.0,
      left: 24.0,
      right: 24.0,
      child: Container(
        height: 76.0,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28.0),
          boxShadow: [
            BoxShadow(
              color: colorScheme.onSurface.withAlpha(15),
              blurRadius: 20.0,
              offset: const Offset(0.0, 8.0),
            ),
          ],
          border: Border.all(
            color: theme.dividerTheme.color ?? AppColors.transparent,
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / 4.0;

              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOutBack,
                    left: (itemWidth * selectedIndex) + 4.0,
                    top: (constraints.maxHeight - 56.0) / 2.0,
                    child: Container(
                      width: itemWidth - 8.0,
                      height: 56.0,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withAlpha(31),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      NavItemWidget(
                        icon: Icons.grid_view_rounded,
                        label: 'Início',
                        index: 0,
                        isSelected: selectedIndex == 0,
                        onTap: onTap,
                      ),
                      NavItemWidget(
                        icon: Icons.calendar_today_rounded,
                        label: 'Grade',
                        index: 1,
                        isSelected: selectedIndex == 1,
                        onTap: onTap,
                      ),
                      NavItemWidget(
                        icon: Icons.task_alt_rounded,
                        label: 'Atividades',
                        index: 2,
                        isSelected: selectedIndex == 2,
                        onTap: onTap,
                      ),
                      NavItemWidget(
                        icon: Icons.settings_rounded,
                        label: 'Ajustes',
                        index: 3,
                        isSelected: selectedIndex == 3,
                        onTap: onTap,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
