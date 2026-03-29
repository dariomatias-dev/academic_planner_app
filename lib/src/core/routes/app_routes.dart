import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:academic_planner/src/core/routes/route_paths.dart';

class AppRoutes {
  static void goHome(BuildContext context) {
    context.go(RoutePaths.home);
  }

  static void goToCreateTask(
    BuildContext context, {
    required int disciplineId,
  }) {
    final uri = Uri(
      path: RoutePaths.createTask,
      queryParameters: {'disciplineId': disciplineId.toString()},
    );

    context.push(uri.toString());
  }

  static void goToPdfViewer(
    BuildContext context, {
    required String url,
    required String title,
    String? subtitle,
  }) {
    final uri = Uri(
      path: RoutePaths.pdfViewer,
      queryParameters: {'url': url, 'title': title, 'subtitle': ?subtitle},
    );

    context.push(uri.toString());
  }

  static void goToSchedule(BuildContext context) {
    context.push(RoutePaths.schedule);
  }

  static void goToMySchedule(BuildContext context) {
    context.push(RoutePaths.mySchedule);
  }

  static void goToDisciplineSelection(BuildContext context) {
    context.push(RoutePaths.disciplineSelection);
  }

  static void goToAbout(BuildContext context) {
    context.push(RoutePaths.about);
  }

  static void goToDisciplineDetails(
    BuildContext context, {
    required int disciplineId,
    int? tab,
  }) {
    final uri = Uri(
      path: '${RoutePaths.disciplineDetails}/$disciplineId',
      queryParameters: {if (tab != null) 'tab': tab.toString()},
    );

    context.push(uri.toString());
  }

  static void goToDisciplines(BuildContext context) {
    context.push(RoutePaths.disciplines);
  }
}
