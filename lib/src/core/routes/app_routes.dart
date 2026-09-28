import 'package:academic_planner/src/core/routes/typed_routes.dart';
import 'package:flutter/widgets.dart';

class AppRoutes {
  static void goToHome(BuildContext context) {
    const HomeRoute().go(context);
  }

  static void goToActivities(BuildContext context) {
    const ActivitiesRoute().go(context);
  }

  static Future<void> goToAbout(BuildContext context) async {
    await const AboutRoute().push<void>(context);
  }

  static Future<void> goToActivityDetails(
    BuildContext context, {
    required String activityId,
  }) async {
    await ActivityDetailsRoute(activityId: activityId).push<void>(context);
  }

  static Future<bool?> goToActivityForm(
    BuildContext context, {
    String? activityId,
    int? disciplineId,
  }) {
    return ActivityFormRoute(
      activityId: activityId,
      disciplineId: disciplineId,
    ).push<bool>(context);
  }

  static Future<void> goToAgenda(BuildContext context) async {
    await const AgendaRoute().push<void>(context);
  }

  static Future<void> goToCategories(BuildContext context) async {
    await const CategoriesRoute().push<void>(context);
  }

  static Future<void> goToCourseDetails(BuildContext context) async {
    await const CourseDetailsRoute().push<void>(context);
  }

  static Future<void> goToDisciplineDetails(
    BuildContext context, {
    required int disciplineId,
    int? tab,
  }) async {
    await DisciplineDetailsRoute(
      disciplineId: disciplineId,
      tab: tab ?? 0,
    ).push<void>(context);
  }

  static Future<void> goToDisciplineSelection(BuildContext context) async {
    await const DisciplineSelectionRoute().push<void>(context);
  }

  static Future<void> goToDisciplines(BuildContext context) async {
    await const DisciplinesRoute().push<void>(context);
  }

  static Future<void> goToEditProfile(BuildContext context) async {
    await const EditProfileRoute().push<void>(context);
  }

  static Future<void> goToForgotPassword(BuildContext context) async {
    await const ForgotPasswordRoute().push<void>(context);
  }

  static Future<void> goToLogin(
    BuildContext context, {
    bool replace = false,
  }) async {
    if (replace) {
      const LoginRoute().go(context);
    } else {
      await const LoginRoute().push<void>(context);
    }
  }

  static Future<void> goToMySchedule(BuildContext context) async {
    await const MyScheduleRoute().push<void>(context);
  }

  static Future<void> goToNoteDetails(
    BuildContext context, {
    required String noteId,
  }) async {
    await NoteDetailsRoute(noteId: noteId).push<void>(context);
  }

  static Future<void> goToNoteForm(
    BuildContext context, {
    required int disciplineId,
    String? noteId,
  }) async {
    await NoteFormRoute(
      disciplineId: disciplineId,
      noteId: noteId,
    ).push<void>(context);
  }

  static Future<void> goToPdfViewer(
    BuildContext context, {
    required String url,
    required String title,
  }) async {
    await PdfViewerRoute(url: url, title: title).push<void>(context);
  }

  static Future<void> goToRegister(
    BuildContext context, {
    bool replace = false,
  }) async {
    if (replace) {
      const RegisterRoute().go(context);
    } else {
      await const RegisterRoute().push<void>(context);
    }
  }

  static Future<void> goToSchedule(BuildContext context, {int? period}) async {
    await ScheduleRoute(period: period).push<void>(context);
  }

  static Future<void> goToTags(BuildContext context) async {
    await const TagsRoute().push<void>(context);
  }

  static Future<void> goToTeacherDetails(
    BuildContext context, {
    required int teacherId,
  }) async {
    await TeacherDetailsRoute(teacherId: teacherId).push<void>(context);
  }

  static Future<void> goToUserManagement(BuildContext context) async {
    await const UserManagementRoute().push<void>(context);
  }
}
