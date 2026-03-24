import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';

import 'package:academic_planner/src/screens/disciplines/widgets/disciplines_period_chip_widget.dart';
import 'package:academic_planner/src/screens/disciplines/widgets/disciplines_period_summary/disciplines_period_summary_widget.dart';

import 'package:academic_planner/src/shared/widgets/discipline_card/discipline_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_button_widget.dart';
import 'package:academic_planner/src/shared/models/discipline_model.dart';

class DisciplineSelectionScreen extends StatefulWidget {
  const DisciplineSelectionScreen({super.key});

  @override
  State<DisciplineSelectionScreen> createState() =>
      _DisciplineSelectionScreenState();
}

class _DisciplineSelectionScreenState extends State<DisciplineSelectionScreen>
    with TickerProviderStateMixin {
  late final TabController _mainTabController;
  late final TabController _periodTabController;

  final Set<int> _selectedIds = <int>{51, 52, 53, 54, 55};
  final List<int> _periods =
      adsDisciplines.map((d) => d.period).toSet().toList()..sort();

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 2, vsync: this);
    _periodTabController = TabController(length: _periods.length, vsync: this);

    _mainTabController.addListener(() => setState(() {}));
    _periodTabController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    _periodTabController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    final selectedDisciplines = adsDisciplines
        .where((d) => _selectedIds.contains(d.id))
        .toList();
    final isAddTab = _mainTabController.index == 1;
    final headerHeight = isAddTab ? 172.0 : 92.0;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return <Widget>[
              SliverToBoxAdapter(child: _buildTopHeader()),
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  height: headerHeight,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _buildSelectionSummary(),
                      TabBar(
                        controller: _mainTabController,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textSub,
                        indicatorColor: AppColors.primary,
                        indicatorWeight: 3.0,
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w800,
                          fontSize: 14.0,
                        ),
                        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                        tabs: const <Widget>[
                          Tab(text: "Minha Grade"),
                          Tab(text: "Adicionar"),
                        ],
                      ),
                      if (isAddTab) _buildPeriodSelector(),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _mainTabController,
            children: <Widget>[
              _buildMyGradeTab(selectedDisciplines),
              _buildAddTabContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 16.0),
      decoration: const BoxDecoration(color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.bg,
                  fixedSize: const Size(48.0, 48.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.textMain,
                  size: 28.0,
                ),
              ),
              IconButtonWidget(
                icon: Icons.check_rounded,
                onPressed: () => Navigator.pop(context, _selectedIds),
                style: IconButtonStyles.primary,
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          Text(
            "Configurar Grade",
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textMain,
              fontSize: 28.0,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            "Gerencie as disciplinas do seu semestre",
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSub,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionSummary() {
    return Container(
      height: 44.0,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "MINHA SELEÇÃO ATUAL",
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.primary,
              fontSize: 10.0,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            "${_selectedIds.length} ITENS SELECIONADOS",
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textSub,
              fontSize: 10.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      height: 80.0,
      color: AppColors.white,
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
        tabs: _periods.map((period) {
          final isSelected =
              _periodTabController.index == _periods.indexOf(period);
          return Tab(
            child: DisciplinesPeriodChipWidget(
              label: "$periodº Período",
              isSelected: isSelected,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMyGradeTab(List<DisciplineModel> selected) {
    if (selected.isEmpty) {
      return Center(
        child: Text(
          "Nenhuma disciplina selecionada",
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.textSub,
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
          trailing: const Icon(
            Icons.remove_circle_outline_rounded,
            color: AppColors.primary,
            size: 24.0,
          ),
        );
      },
    );
  }

  Widget _buildAddTabContent() {
    return TabBarView(
      controller: _periodTabController,
      children: _periods.map((period) {
        final periodDisciplines = adsDisciplines
            .where((d) => d.period == period)
            .toList();
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
              trailing: _buildCheckIcon(isSelected),
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildCheckIcon(bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 28.0,
      height: 28.0,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.borderMedium,
          width: 2.0,
        ),
      ),
      child: isSelected
          ? const Icon(Icons.check_rounded, size: 18.0, color: AppColors.white)
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
        color: AppColors.white,
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
