import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:academic_planner/src/core/routes/route_paths.dart';

class AppRoutes {
  static void goToRoot(BuildContext context) {
    context.go(RoutePaths.root);
  }

  static void goToAbout(BuildContext context) {
    context.push(RoutePaths.about);
  }

  static void goToActivityDetails(
    BuildContext context, {
    required String activityId,
  }) {
    final queryParameters = <String, String>{};
    queryParameters['activityId'] = activityId;

    final uri = Uri(
      path: RoutePaths.activityDetails,
      queryParameters: queryParameters,
    );

    context.push(uri.toString());
  }

  static Future<bool?> goToActivityForm(
    BuildContext context, {
    String? activityId,
    int? disciplineId,
  }) async {
    final queryParameters = <String, String>{};

    if (activityId != null) {
      queryParameters['activityId'] = activityId;
    }

    if (disciplineId != null) {
      queryParameters['disciplineId'] = disciplineId.toString();
    }

    final uri = Uri(
      path: RoutePaths.activityForm,
      queryParameters: queryParameters,
    );

    final result = await context.push(uri.toString());

    return result as bool?;
  }

  static void goToAgenda(BuildContext context) {
    context.push(RoutePaths.agenda);
  }

  static void goToCategories(BuildContext context) {
    context.push(RoutePaths.categories);
  }

  static void goToCourseDetails(BuildContext context) {
    context.push(RoutePaths.courseDetails);
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

  static void goToDisciplineSelection(BuildContext context) {
    context.push(RoutePaths.disciplineSelection);
  }

  static void goToDisciplines(BuildContext context) {
    context.push(RoutePaths.disciplines);
  }

  static void goToEditProfile(BuildContext context) {
    context.push(RoutePaths.editProfile);
  }

  static void goToForgotPassword(BuildContext context) {
    context.push(RoutePaths.forgotPassword);
  }

  static void goToLogin(BuildContext context, {bool replace = false}) {
    if (replace) {
      context.go(RoutePaths.login);
    } else {
      context.push(RoutePaths.login);
    }
  }

  static void goToMySchedule(BuildContext context) {
    context.push(RoutePaths.mySchedule);
  }

  static void goToPdfViewer(
    BuildContext context, {
    required String url,
    required String title,
  }) {
    final uri = Uri(
      path: RoutePaths.pdfViewer,
      queryParameters: {'url': url, 'title': title},
    );

    context.push(uri.toString());
  }

  static void goToRegister(BuildContext context, {bool replace = false}) {
    if (replace) {
      context.go(RoutePaths.register);
    } else {
      context.push(RoutePaths.register);
    }
  }

  static void goToSchedule(BuildContext context) {
    context.push(RoutePaths.schedule);
  }

  static void goToTeacherDetails(
    BuildContext context, {
    required int teacherId,
  }) {
    final uri = Uri(path: '${RoutePaths.teacherDetails}/$teacherId');

    context.push(uri.toString());
  }

  static void goToUserManagement(BuildContext context) {
    context.push(RoutePaths.userManagement);
  }
}
