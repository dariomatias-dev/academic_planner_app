import 'package:academic_planner/src/core/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static void goToHome(BuildContext context) {
    context.goNamed(RouteNames.home);
  }

  static void goToActivities(BuildContext context) {
    context.goNamed(RouteNames.activities);
  }

  static Future<void> goToAbout(BuildContext context) async {
    await context.pushNamed(RouteNames.about);
  }

  static Future<void> goToActivityDetails(
    BuildContext context, {
    required String activityId,
  }) async {
    await context.pushNamed(
      RouteNames.activityDetails,
      pathParameters: <String, String>{'activityId': activityId},
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

  static Future<void> goToAgenda(BuildContext context) async {
    await context.pushNamed(RouteNames.agenda);
  }

  static Future<void> goToCategories(BuildContext context) async {
    await context.pushNamed(RouteNames.categories);
  }

  static Future<void> goToCourseDetails(BuildContext context) async {
    await context.pushNamed(RouteNames.courseDetails);
  }

  static Future<void> goToDisciplineDetails(
    BuildContext context, {
    required int disciplineId,
    int? tab,
  }) async {
    await context.pushNamed(
      RouteNames.disciplineDetails,
      pathParameters: <String, String>{'disciplineId': disciplineId.toString()},
      queryParameters: <String, String>{if (tab != null) 'tab': tab.toString()},
    );
  }

  static Future<void> goToDisciplineSelection(BuildContext context) async {
    await context.pushNamed(RouteNames.disciplineSelection);
  }

  static Future<void> goToDisciplines(BuildContext context) async {
    await context.pushNamed(RouteNames.disciplines);
  }

  static Future<void> goToEditProfile(BuildContext context) async {
    await context.pushNamed(RouteNames.editProfile);
  }

  static Future<void> goToForgotPassword(BuildContext context) async {
    await context.pushNamed(RouteNames.forgotPassword);
  }

  static Future<void> goToLogin(
    BuildContext context, {
    bool replace = false,
  }) async {
    if (replace) {
      context.goNamed(RouteNames.login);
    } else {
      await context.pushNamed(RouteNames.login);
    }
  }

  static Future<void> goToMySchedule(BuildContext context) async {
    await context.pushNamed(RouteNames.mySchedule);
  }

  static Future<void> goToNoteDetails(
    BuildContext context, {
    required String noteId,
  }) async {
    await context.pushNamed(
      RouteNames.noteDetails,
      pathParameters: <String, String>{'noteId': noteId},
    );
  }

  static Future<void> goToNoteForm(
    BuildContext context, {
    required int disciplineId,
    String? noteId,
  }) async {
    await context.pushNamed(
      RouteNames.noteForm,
      queryParameters: <String, String>{
        'noteId': ?noteId,
        'disciplineId': disciplineId.toString(),
      },
    );
  }

  static Future<void> goToPdfViewer(
    BuildContext context, {
    required String url,
    required String title,
  }) async {
    await context.pushNamed(
      RouteNames.pdfViewer,
      queryParameters: <String, String>{'url': url, 'title': title},
    );
  }

  static Future<void> goToRegister(
    BuildContext context, {
    bool replace = false,
  }) async {
    if (replace) {
      context.goNamed(RouteNames.register);
    } else {
      await context.pushNamed(RouteNames.register);
    }
  }

  static Future<void> goToSchedule(BuildContext context, {int? period}) async {
    await context.pushNamed(
      RouteNames.schedule,
      queryParameters: <String, String>{
        if (period != null) 'period': period.toString(),
      },
    );
  }

  static Future<void> goToTags(BuildContext context) async {
    await context.pushNamed(RouteNames.tags);
  }

  static Future<void> goToTeacherDetails(
    BuildContext context, {
    required int teacherId,
  }) async {
    await context.pushNamed(
      RouteNames.teacherDetails,
      pathParameters: <String, String>{'teacherId': teacherId.toString()},
    );
  }

  static Future<void> goToUserManagement(BuildContext context) async {
    await context.pushNamed(RouteNames.userManagement);
  }
}
