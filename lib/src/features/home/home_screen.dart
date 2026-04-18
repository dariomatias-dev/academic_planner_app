import 'package:academic_planner/src/core/result/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/di/activity_providers.dart';
import 'package:academic_planner/src/core/di/user_disciplines_provider.dart';
import 'package:academic_planner/src/core/di/activity_filter_provider.dart';
import 'package:academic_planner/src/core/di/navigation_provider.dart';

import 'package:academic_planner/src/data/filters/activity_filter.dart';

import 'package:academic_planner/src/features/home/widgets/home_main_focus_card_widget.dart';
import 'package:academic_planner/src/features/home/widgets/home_quick_actions_row_widget.dart';
import 'package:academic_planner/src/features/user/di/user_providers.dart';

import 'package:academic_planner/src/shared/models/activity_model.dart';
import 'package:academic_planner/src/shared/utils/date_utils_helper.dart';
import 'package:academic_planner/src/shared/widgets/activity_card/activity_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/notification_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/view_all_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/states.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<({List<ActivityModel> activeTasks, int progress})>
  _fetchHomeData() async {
    final controller = ref.read(activityControllerProvider);

    final results = await Future.wait([
      controller.getActivities(
        filter: const ActivityFilter(
          statuses: <ActivityStatus>[
            ActivityStatus.pending,
            ActivityStatus.inProgress,
          ],
        ),
      ),
      controller.countActivities(),
      controller.countActivities(
        filter: const ActivityFilter(
          statuses: <ActivityStatus>[ActivityStatus.completed],
        ),
      ),
    ]);

    final activeTasks = (results[0] as Result<List<ActivityModel>>).fold(
      onSuccess: (value) => value,
      onFailure: (_) => <ActivityModel>[],
    );

    final totalCount = (results[1] as Result<int>).fold(
      onSuccess: (value) => value,
      onFailure: (_) => 0,
    );

    final completedCount = (results[2] as Result<int>).fold(
      onSuccess: (value) => value,
      onFailure: (_) => 0,
    );

    final progress = totalCount == 0
        ? 0
        : ((completedCount / totalCount) * 100).toInt();

    return (activeTasks: activeTasks, progress: progress);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    ref.watch(activityNotifierProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppBarWidget(
        title: "Bem-vindo",
        showBackButton: false,
        actions: <Widget>[NotificationButtonWidget()],
      ),
      body: FutureBuilder(
        future: _fetchHomeData(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          final isLoading = snapshot.connectionState == ConnectionState.waiting;

          return ListView(
            padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 140.0),
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              const _HomeHeaderSection(),
              const SizedBox(height: 32.0),
              _buildMetricsBar(
                colorScheme,
                data?.activeTasks.length ?? 0,
                data?.progress ?? 0,
              ),
              const SizedBox(height: 32.0),
              const HomeMainFocusCardWidget(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: HomeQuickActionsRowWidget(),
              ),
              const _HomeSectionHeader(),
              const SizedBox(height: 20.0),
              if (isLoading)
                const LoadingStateWidget()
              else if (data == null || data.activeTasks.isEmpty)
                const _EmptyActivitiesState()
              else
                ...data.activeTasks
                    .take(4)
                    .map((task) => ActivityCardWidget(activity: task)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetricsBar(
    ColorScheme colorScheme,
    int activeCount,
    int progress,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(32.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 30.0,
            offset: const Offset(0.0, 15.0),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).dividerTheme.color ?? AppColors.transparent,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _HeaderMetric(
            value: activeCount.toString().padLeft(2, '0'),
            label: "Ativas",
            icon: Icons.bolt_rounded,
          ),
          const _DisciplinesMetric(),
          _HeaderMetric(
            value: "$progress%",
            label: "Progresso",
            icon: Icons.donut_large_rounded,
          ),
        ],
      ),
    );
  }
}

class _HomeHeaderSection extends StatelessWidget {
  const _HomeHeaderSection();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const _WelcomeUserText(),
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
    );
  }
}

class _HomeSectionHeader extends ConsumerWidget {
  const _HomeSectionHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
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
            "Próximas Atividades",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18.0,
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
        ),
        ViewAllButtonWidget(
          onTap: () {
            ref.read(navigationNotifierProvider.notifier).setIndex(2);

            ref
                .read(activityFilterNotifierProvider.notifier)
                .setFilter(
                  const ActivityFilter(
                    statuses: <ActivityStatus>[
                      ActivityStatus.pending,
                      ActivityStatus.inProgress,
                    ],
                  ),
                );
          },
        ),
      ],
    );
  }
}

class _WelcomeUserText extends ConsumerWidget {
  const _WelcomeUserText();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(userNotifierProvider).value;

    return Row(
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
          user?.name.split(' ').first ?? 'Estudante',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28.0,
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
            letterSpacing: -1.0,
          ),
        ),
      ],
    );
  }
}

class _DisciplinesMetric extends ConsumerWidget {
  const _DisciplinesMetric();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(userDisciplinesNotifierProvider).length;

    return _HeaderMetric(
      value: count.toString().padLeft(2, '0'),
      label: "Disciplinas",
      icon: Icons.grid_view_rounded,
    );
  }
}

class _HeaderMetric extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _HeaderMetric({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
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
    );
  }
}

class _EmptyActivitiesState extends StatelessWidget {
  const _EmptyActivitiesState();

  @override
  Widget build(BuildContext context) {
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
