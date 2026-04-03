import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/constants/mock_activities.dart';

import 'package:academic_planner/src/screens/home/widgets/home_main_focus_card_widget.dart';
import 'package:academic_planner/src/screens/home/widgets/home_quick_actions_row_widget.dart';

import 'package:academic_planner/src/shared/utils/date_utils_helper.dart';
import 'package:academic_planner/src/shared/widgets/activity_card/activity_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/notification_button_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppBarWidget(
        title: "Bem-vindo",
        showBackButton: false,
        actions: <Widget>[NotificationButtonWidget()],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: -120.0,
            right: -80.0,
            child: Container(
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    colorScheme.primary.withAlpha(25),
                    colorScheme.primary.withAlpha(0),
                  ],
                ),
              ),
            ),
          ),
          ListView(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 140.0),
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              _buildImpactfulHeader(context),
              const SizedBox(height: 32.0),
              const HomeMainFocusCardWidget(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: HomeQuickActionsRowWidget(),
              ),
              _buildSectionHeader(context, "Próximas Atividades"),
              const SizedBox(height: 20.0),
              if (mockActivities.isEmpty)
                _buildEmptyState(context)
              else
                ...mockActivities
                    .take(4)
                    .map((task) => ActivityCardWidget(task: task)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImpactfulHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      "Olá, ",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      "John Doe",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28.0,
                        fontWeight: FontWeight.w900,
                        color: colorScheme.onSurface,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  DateUtilsHelper.formatWeekdayDate(DateTime.now()),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            Container(
              width: 56.0,
              height: 56.0,
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(20),
                borderRadius: BorderRadius.circular(18.0),
                border: Border.all(
                  color: colorScheme.primary.withAlpha(40),
                  width: 2.0,
                ),
              ),
              child: Icon(
                Icons.person_rounded,
                color: colorScheme.primary,
                size: 30.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32.0),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(32.0),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withAlpha(10),
                blurRadius: 30.0,
                offset: const Offset(0.0, 15.0),
              ),
            ],
            border: Border.all(
              color: theme.dividerTheme.color ?? AppColors.transparent,
            ),
          ),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _buildHeaderMetric(
                    context,
                    value: "14",
                    label: "Atividades",
                    icon: Icons.auto_stories_rounded,
                  ),
                  _buildHeaderMetric(
                    context,
                    value: "06",
                    label: "Disciplinas",
                    icon: Icons.grid_view_rounded,
                  ),
                  _buildHeaderMetric(
                    context,
                    value: "9.2",
                    label: "IRA Geral",
                    icon: Icons.stars_rounded,
                    isLast: true,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: LinearProgressIndicator(
                  value: 0.72,
                  minHeight: 8.0,
                  backgroundColor: colorScheme.onSurface.withAlpha(15),
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Progresso do Semestre",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface.withAlpha(140),
                    ),
                  ),
                  Text(
                    "72%",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w900,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderMetric(
    BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
    bool isLast = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon, size: 14.0, color: colorScheme.primary),
                  const SizedBox(width: 6.0),
                  Text(
                    value,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Text(
                label.toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w800,
                  color: colorScheme.onSurface.withAlpha(100),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          if (!isLast) const Spacer(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 4.0,
          height: 20.0,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18.0,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primary.withAlpha(20),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Text(
              "Ver todas",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.0,
                fontWeight: FontWeight.w800,
                color: colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(32.0),
        border: Border.all(
          color: theme.dividerTheme.color ?? AppColors.transparent,
        ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.emerald500.withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.done_all_rounded,
              size: 32.0,
              color: AppColors.emerald500,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            "Tudo organizado!",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16.0,
              fontWeight: FontWeight.w800,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
