import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/screens/disciplines/widgets/disciplines_period_chip_widget.dart';
import 'package:academic_planner/src/screens/disciplines/widgets/disciplines_period_summary/disciplines_period_summary_widget.dart';

import 'package:academic_planner/src/shared/models/discipline_model.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/discipline_card/discipline_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_buttons.dart';
import 'package:academic_planner/src/shared/widgets/tab_bar_widget.dart';

class DisciplineSelectionScreen extends StatefulWidget {
  const DisciplineSelectionScreen({super.key});

  @override
  State<DisciplineSelectionScreen> createState() =>
      _DisciplineSelectionScreenState();
}

class _DisciplineSelectionScreenState extends State<DisciplineSelectionScreen>
    with TickerProviderStateMixin {
  late final _mainTabController = TabController(length: 2, vsync: this);
  late final _periodTabController = TabController(
    length: _periods.length,
    vsync: this,
  );

  final _selectedIds = <int>{51, 52, 53, 54, 55};
  final _periods = adsDisciplines.map((d) => d.period).toSet().toList()..sort();

  void _toggleDiscipline(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _mainTabController.addListener(() => setState(() {}));
    _periodTabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _periodTabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDisciplines = adsDisciplines.filter(
      (d) => _selectedIds.contains(d.id),
    );

    final isAddTab = _mainTabController.index == 1;
    final headerHeight = isAddTab ? 128.0 : 48.0;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        title: "",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.check_rounded,
            onPressed: () => Navigator.pop(context, _selectedIds),
            style: IconButtonStyle.primary,
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverToBoxAdapter(child: _buildTextHeader(context)),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                height: headerHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TabBarWidget(
                      controller: _mainTabController,
                      tabs: const <Tab>[
                        Tab(text: "Minha Grade"),
                        Tab(text: "Adicionar"),
                      ],
                    ),
                    if (isAddTab) _buildPeriodSelector(context),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _mainTabController,
          children: <Widget>[
            _buildMyGradeTab(context, selectedDisciplines),
            _buildAddTabContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 16.0),
      decoration: BoxDecoration(color: colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Configurar Grade",
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface,
              fontSize: 28.0,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            "Gerencie as disciplinas do seu semestre",
            style: GoogleFonts.plusJakartaSans(
              color: colorScheme.onSurface.withAlpha(160),
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 80.0,
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: TabBar(
        controller: _periodTabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        dividerColor: AppColors.transparent,
        indicatorColor: AppColors.transparent,
        overlayColor: WidgetStateProperty.all(AppColors.transparent),
        splashFactory: NoSplash.splashFactory,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
        tabs: _periods.builder((period, index) {
          final isSelected =
              _periodTabController.index == _periods.indexOf(period);
          return Tab(
            child: DisciplinesPeriodChipWidget(
              label: "$periodº Período",
              isSelected: isSelected,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMyGradeTab(
    BuildContext context,
    List<DisciplineModel> selected,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    if (selected.isEmpty) {
      return Center(
        child: Text(
          "Nenhuma disciplina selecionada",
          style: GoogleFonts.plusJakartaSans(
            color: colorScheme.onSurface.withAlpha(160),
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final totalWorkload = selected.fold(0, (sum, item) => sum + item.workload);

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 40.0),
      itemCount: selected.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: DisciplinesPeriodSummaryWidget(
              count: selected.length,
              workload: totalWorkload,
            ),
          );
        }

        final discipline = selected[index - 1];
        return DisciplineCardWidget(
          index: index,
          discipline: discipline,
          onTap: () => _toggleDiscipline(discipline.id),
          trailing: Icon(
            Icons.remove_circle_outline_rounded,
            color: colorScheme.primary,
            size: 24.0,
          ),
        );
      },
    );
  }

  Widget _buildAddTabContent(BuildContext context) {
    return TabBarView(
      controller: _periodTabController,
      children: _periods.builder((period, index) {
        final periodDisciplines = adsDisciplines.filter(
          (d) => d.period == period,
        );

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 40.0),
          itemCount: periodDisciplines.length,
          itemBuilder: (context, index) {
            final discipline = periodDisciplines[index];
            final isSelected = _selectedIds.contains(discipline.id);

            return DisciplineCardWidget(
              index: index + 1,
              discipline: discipline,
              opacity: isSelected ? 1.0 : 0.4,
              onTap: () => _toggleDiscipline(discipline.id),
              trailing: _buildCheckIcon(context, isSelected),
            );
          },
        );
      }),
    );
  }

  Widget _buildCheckIcon(BuildContext context, bool isSelected) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 28.0,
      height: 28.0,
      decoration: BoxDecoration(
        color: isSelected ? colorScheme.primary : AppColors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : Theme.of(context).dividerTheme.color ?? AppColors.transparent,
          width: 2.0,
        ),
      ),
      child: isSelected
          ? Icon(Icons.check_rounded, size: 18.0, color: colorScheme.onPrimary)
          : null,
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.child, required this.height});

  final Widget child;
  final double height;

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(
      height: height,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: child,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return oldDelegate.height != height || oldDelegate.child != child;
  }
}
