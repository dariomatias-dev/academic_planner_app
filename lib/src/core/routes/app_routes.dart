import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:academic_planner/src/core/routes/route_names.dart';

class AppRoutes {
  static void goToRoot(BuildContext context) {
    context.goNamed(RouteNames.root);
  }

  static void goToAbout(BuildContext context) {
    context.pushNamed(RouteNames.about);
  }

  static void goToActivityDetails(
    BuildContext context, {
    required String activityId,
  }) {
    context.pushNamed(
      RouteNames.activityDetails,
      queryParameters: <String, String>{'activityId': activityId},
    );
  }

  static Future<bool?> goToActivityForm(
    BuildContext context, {
    String? activityId,
    int? disciplineId,
  }) async {
    final result = await context.pushNamed(
      RouteNames.activityForm,
      queryParameters: <String, String>{
        'activityId': ?activityId,
        if (disciplineId != null) 'disciplineId': disciplineId.toString(),
      },
    );

    return result as bool?;
  }

  static void goToAgenda(BuildContext context) {
    context.pushNamed(RouteNames.agenda);
  }

  static void goToCategories(BuildContext context) {
    context.pushNamed(RouteNames.categories);
  }

  static void goToCourseDetails(BuildContext context) {
    context.pushNamed(RouteNames.courseDetails);
  }

  static void goToDisciplineDetails(
    BuildContext context, {
    required int disciplineId,
    int? tab,
  }) {
    context.pushNamed(
      RouteNames.disciplineDetails,
      pathParameters: <String, String>{'disciplineId': disciplineId.toString()},
      queryParameters: <String, String>{if (tab != null) 'tab': tab.toString()},
    );
  }

  static void goToDisciplineSelection(BuildContext context) {
    context.pushNamed(RouteNames.disciplineSelection);
  }

  static void goToDisciplines(BuildContext context) {
    context.pushNamed(RouteNames.disciplines);
  }

  static void goToEditProfile(BuildContext context) {
    context.pushNamed(RouteNames.editProfile);
  }

  static void goToForgotPassword(BuildContext context) {
    context.pushNamed(RouteNames.forgotPassword);
  }

  static void goToLogin(BuildContext context, {bool replace = false}) {
    if (replace) {
      context.goNamed(RouteNames.login);
    } else {
      context.pushNamed(RouteNames.login);
    }
  }

  static void goToMySchedule(BuildContext context) {
    context.pushNamed(RouteNames.mySchedule);
  }

  static void goToNoteDetails(BuildContext context, {required String noteId}) {
    context.pushNamed(
      RouteNames.noteDetails,
      pathParameters: <String, String>{'noteId': noteId},
    );
  }

  static void goToNoteForm(
    BuildContext context, {
    String? noteId,
    required int disciplineId,
  }) {
    context.pushNamed(
      RouteNames.noteForm,
      queryParameters: <String, String>{
        'noteId': ?noteId,
        'disciplineId': disciplineId.toString(),
      },
    );
  }

  static void goToPdfViewer(
    BuildContext context, {
    required String url,
    required String title,
  }) {
    context.pushNamed(
      RouteNames.pdfViewer,
      queryParameters: <String, String>{'url': url, 'title': title},
    );
  }

  static void goToRegister(BuildContext context, {bool replace = false}) {
    if (replace) {
      context.goNamed(RouteNames.register);
    } else {
      context.pushNamed(RouteNames.register);
    }
  }

  static void goToSchedule(BuildContext context, {int? period}) {
    context.pushNamed(
      RouteNames.schedule,
      queryParameters: <String, String>{
        if (period != null) 'period': period.toString(),
      },
    );
  }

  static void goToTags(BuildContext context) {
    context.pushNamed(RouteNames.tags);
  }

  static void goToTeacherDetails(
    BuildContext context, {
    required int teacherId,
  }) {
    context.pushNamed(
      RouteNames.teacherDetails,
      pathParameters: <String, String>{'teacherId': teacherId.toString()},
    );
  }

  static void goToUserManagement(BuildContext context) {
    context.pushNamed(RouteNames.userManagement);
  }
}
