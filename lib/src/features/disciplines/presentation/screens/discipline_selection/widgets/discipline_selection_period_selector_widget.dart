import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/disciplines/widgets/disciplines_period_chip_widget.dart';
import 'package:flutter/material.dart';

class DisciplineSelectionPeriodSelectorWidget extends StatelessWidget {
  const DisciplineSelectionPeriodSelectorWidget({
    required this.controller,
    required this.periods,
    super.key,
  });

  final TabController controller;
  final List<int> periods;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 80.0,
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: AppColors.transparent,
        indicatorColor: AppColors.transparent,
        overlayColor: WidgetStateProperty.all(AppColors.transparent),
        splashFactory: NoSplash.splashFactory,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        tabs: periods.builder((period, index) {
          final isSelected = controller.index == periods.indexOf(period);

          return Tab(
            child: DisciplinesPeriodChipWidget(
              label: '$periodº Período',
              isSelected: isSelected,
            ),
          );
        }),
      ),
    );
  }
}
