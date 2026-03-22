import 'package:academic_planner/src/shared/widgets/nav_bar/nav_item_widget.dart';
import 'package:flutter/material.dart';

import 'package:academic_planner/src/core/app_colors.dart';

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
    if (index == 1) return 0.0;

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
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
            final itemWidth = (constraints.maxWidth - 16.0) / 3.0;
            return Stack(
              children: <Widget>[
                AnimatedAlign(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.easeInOutBack,
                  alignment: Alignment(getAlignmentX(selectedIndex), 0.0),
                  child: Container(
                    width: itemWidth,
                    height: 52.0,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(31),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    NavItemWidget(
                      icon: Icons.grid_view_rounded,
                      label: "Início",
                      index: 0,
                      isSelected: selectedIndex == 0,
                      onTap: onTap,
                    ),
                    NavItemWidget(
                      icon: Icons.book_rounded,
                      label: "Grade",
                      index: 1,
                      isSelected: selectedIndex == 1,
                      onTap: onTap,
                    ),
                    NavItemWidget(
                      icon: Icons.task_alt_rounded,
                      label: "Tarefas",
                      index: 2,
                      isSelected: selectedIndex == 2,
                      onTap: onTap,
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
