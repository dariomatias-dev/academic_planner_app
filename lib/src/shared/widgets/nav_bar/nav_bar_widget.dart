import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

import 'package:academic_planner/src/shared/widgets/nav_bar/nav_item_widget.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final Function(int value) onTap;

  double getAlignmentX(int index) {
    if (index == 0) return -1.0;
    if (index == 1) return -0.33;
    if (index == 2) return 0.33;

    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24.0,
      left: 24.0,
      right: 24.0,
      child: Container(
        height: 76.0,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(28.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.black.withAlpha(15),
              blurRadius: 20.0,
              offset: const Offset(0.0, 8.0),
            ),
          ],
          border: Border.all(color: AppColors.borderLight, width: 1.5),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth) / 4.0;

            return Stack(
              children: <Widget>[
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOutBack,
                  left: (itemWidth * selectedIndex) + 4.0,
                  top: (76.0 - 56.0) / 2,
                  child: Container(
                    width: itemWidth - 8.0,
                    height: 56.0,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(31),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: NavItemWidget(
                        icon: Icons.grid_view_rounded,
                        label: "Início",
                        index: 0,
                        isSelected: selectedIndex == 0,
                        onTap: onTap,
                      ),
                    ),
                    Expanded(
                      child: NavItemWidget(
                        icon: Icons.calendar_today_rounded,
                        label: "Grade",
                        index: 1,
                        isSelected: selectedIndex == 1,
                        onTap: onTap,
                      ),
                    ),
                    Expanded(
                      child: NavItemWidget(
                        icon: Icons.task_alt_rounded,
                        label: "Tarefas",
                        index: 2,
                        isSelected: selectedIndex == 2,
                        onTap: onTap,
                      ),
                    ),
                    Expanded(
                      child: NavItemWidget(
                        icon: Icons.settings_rounded,
                        label: "Ajustes",
                        index: 3,
                        isSelected: selectedIndex == 3,
                        onTap: onTap,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
