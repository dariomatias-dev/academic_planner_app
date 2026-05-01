import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/di/navigation_provider.dart';
import 'package:academic_planner/src/core/domain/entities/pagination.dart';
import 'package:academic_planner/src/core/result/result.dart';

import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/domain/value_objects/activity_filter.dart';
import 'package:academic_planner/src/features/activities/presentation/widgets/activity_card/activity_card_widget.dart';
import 'package:academic_planner/src/features/home/widgets/home_activities_empty_state_widget.dart';
import 'package:academic_planner/src/features/home/widgets/home_metrics_bar_widget.dart';
import 'package:academic_planner/src/features/home/widgets/home_quick_actions_row_widget.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';

import 'package:academic_planner/src/shared/utils/date_utils_helper.dart';
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

  Future<({List<Activity> recentActivities, int activeCount, int progress})>
  _fetchHomeData() async {
    final activityNotifier = ref.read(activityNotifierProvider.notifier);

    const activeFilter = ActivityFilter(
      statuses: <ActivityStatus>[
        ActivityStatus.pending,
        ActivityStatus.inProgress,
      ],
    );

    final results = await Future.wait([
      activityNotifier.getAll(
        filter: activeFilter,
        pagination: const Pagination(limit: 4),
      ),
      activityNotifier.count(filter: activeFilter),
      activityNotifier.count(),
      activityNotifier.count(
        filter: const ActivityFilter(
          statuses: <ActivityStatus>[ActivityStatus.completed],
        ),
      ),
    ]);

    final recentActivities = (results[0] as Result<List<Activity>>).fold(
      onSuccess: (value) => value,
      onFailure: (_) => <Activity>[],
    );

    final activeCount = (results[1] as Result<int>).fold(
      onSuccess: (value) => value,
      onFailure: (_) => 0,
    );

    final totalCount = (results[2] as Result<int>).fold(
      onSuccess: (value) => value,
      onFailure: (_) => 0,
    );

    final completedCount = (results[3] as Result<int>).fold(
      onSuccess: (value) => value,
      onFailure: (_) => 0,
    );

    final progressValue = totalCount == 0
        ? 0
        : ((completedCount / totalCount) * 100).toInt();

    return (
      recentActivities: recentActivities,
      activeCount: activeCount,
      progress: progressValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);

    ref.watch(activityNotifierProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppBarWidget(
        title: "Bem-vindo",
        showBackButton: false,
        actions: <Widget>[NotificationButtonWidget()],
      ),
      body:
          FutureBuilder<
            ({List<Activity> recentActivities, int activeCount, int progress})
          >(
            future: _fetchHomeData(),
            builder: (context, snapshot) {
              final data = snapshot.data;
              final isLoading =
                  snapshot.connectionState == ConnectionState.waiting;

              return ListView(
                padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 140.0),
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  const _HomeHeaderSection(),
                  const SizedBox(height: 32.0),
                  HomeMetricsBarWidget(),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32.0),
                    child: HomeQuickActionsRowWidget(),
                  ),
                  const _HomeSectionHeader(),
                  const SizedBox(height: 20.0),
                  if (isLoading)
                    const LoadingStateWidget()
                  else if (data == null || data.recentActivities.isEmpty)
                    const HomeActivitiesEmptyStateWidget()
                  else
                    ...data.recentActivities.map(
                      (activity) => ActivityCardWidget(activity: activity),
                    ),
                ],
              );
            },
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
