import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';
import 'package:academic_planner/src/core/routes/app_routes.dart';

import 'package:academic_planner/src/notifiers/user_disciplines_notifier.dart';

import 'package:academic_planner/src/screens/my_disciplines/widgets/my_disciplines_empty_state_widget.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/floating_action_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/buttons/notification_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/discipline_card/discipline_card_item_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';

class MyDisciplinesScreen extends StatefulWidget {
  const MyDisciplinesScreen({super.key, this.showBackButton});

  final bool? showBackButton;

  @override
  State<MyDisciplinesScreen> createState() => _MyDisciplinesScreenState();
}

class _MyDisciplinesScreenState extends State<MyDisciplinesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final userDisciplinesNotifier = context.watch<UserDisciplinesNotifier>();

    final enrolledDisciplines = adsDisciplines.filter((discipline) {
      return userDisciplinesNotifier.selectedIds.contains(discipline.id);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(
        showBackButton: widget.showBackButton,
        label: "ESTUDANTE",
        title: "Minha Grade",
        actions: <Widget>[
          IconButtonWidget(
            icon: Icons.account_tree_rounded,
            onPressed: () {
              AppRoutes.goToMySchedule(context);
            },
            style: IconButtonStyle.primary,
          ),
          NotificationButtonWidget(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0),
        child: FloatingActionButtonWidget(
          onPressed: () {
            AppRoutes.goToDisciplineSelection(context);
          },
          icon: Icons.calendar_today_rounded,
        ),
      ),
      body: enrolledDisciplines.isEmpty
          ? const MyDisciplinesEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 190.0),
              itemCount: enrolledDisciplines.length,
              itemBuilder: (context, index) {
                return DisciplineCardItemWidget(
                  index: index + 1,
                  discipline: enrolledDisciplines[index],
                );
              },
            ),
    );
  }
}
