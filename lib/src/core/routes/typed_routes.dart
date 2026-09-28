import 'package:academic_planner/src/core/routes/root_navigation.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activities/activities_screen.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/activity_details_screen.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/activity_form_screen.dart';
import 'package:academic_planner/src/features/auth/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:academic_planner/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:academic_planner/src/features/auth/presentation/screens/register/register_screen.dart';
import 'package:academic_planner/src/features/calendar/presentation/screens/agenda/agenda_screen.dart';
import 'package:academic_planner/src/features/categories/presentation/screens/categories/categories_screen.dart';
import 'package:academic_planner/src/features/course_details/presentation/screens/course_details/course_details_screen.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/discipline_details_screen.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_selection/discipline_selection_screen.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/disciplines/disciplines_screen.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/my_disciplines/my_disciplines_screen.dart';
import 'package:academic_planner/src/features/home/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:academic_planner/src/features/notes/presentation/screens/note_details/note_details_screen.dart';
import 'package:academic_planner/src/features/notes/presentation/screens/note_form/note_form_screen.dart';
import 'package:academic_planner/src/features/schedule/presentation/screens/my_schedule/my_schedule_screen.dart';
import 'package:academic_planner/src/features/schedule/presentation/screens/schedule/schedule_screen.dart';
import 'package:academic_planner/src/features/settings/presentation/screens/settings/settings_screen.dart';
import 'package:academic_planner/src/features/tags/presentation/screens/tags/tags_screen.dart';
import 'package:academic_planner/src/features/teacher/presentation/screens/teacher_details/teacher_details_screen.dart';
import 'package:academic_planner/src/features/users/presentation/screens/edit_profile/edit_profile_screen.dart';
import 'package:academic_planner/src/features/users/presentation/screens/user_management/user_management_screen.dart';
import 'package:academic_planner/src/shared/screens/about/about_screen.dart';
import 'package:academic_planner/src/shared/screens/pdf_viewer/pdf_viewer_screen.dart';
import 'package:academic_planner/src/shared/screens/splash/splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part 'typed_routes.g.dart';

@TypedStatefulShellRoute<AppShellRoute>(
  branches: [
    TypedStatefulShellBranch<HomeBranch>(
      routes: [TypedGoRoute<HomeRoute>(path: '/home')],
    ),
    TypedStatefulShellBranch<MyDisciplinesBranch>(
      routes: [TypedGoRoute<MyDisciplinesRoute>(path: '/my-disciplines')],
    ),
    TypedStatefulShellBranch<ActivitiesBranch>(
      routes: [TypedGoRoute<ActivitiesRoute>(path: '/activities')],
    ),
    TypedStatefulShellBranch<SettingsBranch>(
      routes: [TypedGoRoute<SettingsRoute>(path: '/settings')],
    ),
  ],
)
class AppShellRoute extends StatefulShellRouteData {
  const AppShellRoute();

  static Widget $navigatorContainerBuilder(
    BuildContext context,
    StatefulNavigationShell navigationShell,
    List<Widget> children,
  ) {
    return RootNavigation(navigationShell: navigationShell, children: children);
  }

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return navigationShell;
  }
}

class HomeBranch extends StatefulShellBranchData {
  const HomeBranch();
}

class MyDisciplinesBranch extends StatefulShellBranchData {
  const MyDisciplinesBranch();
}

class ActivitiesBranch extends StatefulShellBranchData {
  const ActivitiesBranch();
}

class SettingsBranch extends StatefulShellBranchData {
  const SettingsBranch();
}

class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DashboardScreen();
  }
}

class MyDisciplinesRoute extends GoRouteData with $MyDisciplinesRoute {
  const MyDisciplinesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MyDisciplinesScreen(showBackButton: false);
  }
}

class ActivitiesRoute extends GoRouteData with $ActivitiesRoute {
  const ActivitiesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ActivitiesScreen();
  }
}

class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsScreen();
  }
}

@TypedGoRoute<AboutRoute>(path: '/about')
class AboutRoute extends GoRouteData with $AboutRoute {
  const AboutRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AboutScreen();
  }
}

@TypedGoRoute<ActivityDetailsRoute>(path: '/activity-details/:activityId')
class ActivityDetailsRoute extends GoRouteData with $ActivityDetailsRoute {
  const ActivityDetailsRoute({required this.activityId});

  final String activityId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ActivityDetailsScreen(activityId: activityId);
  }
}

@TypedGoRoute<ActivityFormRoute>(path: '/activity-form')
class ActivityFormRoute extends GoRouteData with $ActivityFormRoute {
  const ActivityFormRoute({this.activityId, this.disciplineId});

  final String? activityId;
  final int? disciplineId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ActivityFormScreen(
      activityId: activityId,
      initialDisciplineId: disciplineId,
    );
  }
}

@TypedGoRoute<AgendaRoute>(path: '/agenda')
class AgendaRoute extends GoRouteData with $AgendaRoute {
  const AgendaRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AgendaScreen();
  }
}

@TypedGoRoute<CategoriesRoute>(path: '/categories')
class CategoriesRoute extends GoRouteData with $CategoriesRoute {
  const CategoriesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CategoriesScreen();
  }
}

@TypedGoRoute<CourseDetailsRoute>(path: '/course-details')
class CourseDetailsRoute extends GoRouteData with $CourseDetailsRoute {
  const CourseDetailsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const CourseDetailsScreen();
  }
}

@TypedGoRoute<DisciplineDetailsRoute>(path: '/discipline-details/:disciplineId')
class DisciplineDetailsRoute extends GoRouteData with $DisciplineDetailsRoute {
  const DisciplineDetailsRoute({required this.disciplineId, this.tab = 0});

  final int disciplineId;
  final int tab;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DisciplineDetailsScreen(
      disciplineId: disciplineId,
      initialTabIndex: tab,
    );
  }
}

@TypedGoRoute<DisciplineSelectionRoute>(path: '/discipline-selection')
class DisciplineSelectionRoute extends GoRouteData
    with $DisciplineSelectionRoute {
  const DisciplineSelectionRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DisciplineSelectionScreen();
  }
}

@TypedGoRoute<DisciplinesRoute>(path: '/disciplines')
class DisciplinesRoute extends GoRouteData with $DisciplinesRoute {
  const DisciplinesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DisciplinesScreen();
  }
}

@TypedGoRoute<EditProfileRoute>(path: '/edit-profile')
class EditProfileRoute extends GoRouteData with $EditProfileRoute {
  const EditProfileRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const EditProfileScreen();
  }
}

@TypedGoRoute<ForgotPasswordRoute>(path: '/forgot-password')
class ForgotPasswordRoute extends GoRouteData with $ForgotPasswordRoute {
  const ForgotPasswordRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const ForgotPasswordScreen();
  }
}

@TypedGoRoute<LoginRoute>(path: '/login')
class LoginRoute extends GoRouteData with $LoginRoute {
  const LoginRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LoginScreen();
  }
}

@TypedGoRoute<MyScheduleRoute>(path: '/my-schedule')
class MyScheduleRoute extends GoRouteData with $MyScheduleRoute {
  const MyScheduleRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const MyScheduleScreen();
  }
}

@TypedGoRoute<NoteDetailsRoute>(path: '/note-details/:noteId')
class NoteDetailsRoute extends GoRouteData with $NoteDetailsRoute {
  const NoteDetailsRoute({required this.noteId});

  final String noteId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NoteDetailsScreen(noteId: noteId);
  }
}

@TypedGoRoute<NoteFormRoute>(path: '/note-form')
class NoteFormRoute extends GoRouteData with $NoteFormRoute {
  const NoteFormRoute({this.disciplineId, this.noteId});

  final int? disciplineId;
  final String? noteId;

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final id = disciplineId;

    if (id == null || id <= 0) return const HomeRoute().location;

    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return NoteFormScreen(noteId: noteId, disciplineId: disciplineId!);
  }
}

@TypedGoRoute<PdfViewerRoute>(path: '/pdf-viewer')
class PdfViewerRoute extends GoRouteData with $PdfViewerRoute {
  const PdfViewerRoute({this.url, this.title});

  final String? url;
  final String? title;

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    final target = url;

    if (target == null || target.isEmpty) return const HomeRoute().location;

    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return PdfViewerScreen(url: url!, title: title ?? '');
  }
}

@TypedGoRoute<RegisterRoute>(path: '/register')
class RegisterRoute extends GoRouteData with $RegisterRoute {
  const RegisterRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const RegisterScreen();
  }
}

@TypedGoRoute<ScheduleRoute>(path: '/schedule')
class ScheduleRoute extends GoRouteData with $ScheduleRoute {
  const ScheduleRoute({this.period});

  final int? period;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return ScheduleScreen(initialPeriod: period);
  }
}

@TypedGoRoute<SplashRoute>(path: '/splash')
class SplashRoute extends GoRouteData with $SplashRoute {
  const SplashRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashScreen();
  }
}

@TypedGoRoute<TagsRoute>(path: '/tags')
class TagsRoute extends GoRouteData with $TagsRoute {
  const TagsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TagsScreen();
  }
}

@TypedGoRoute<TeacherDetailsRoute>(path: '/teacher-details/:teacherId')
class TeacherDetailsRoute extends GoRouteData with $TeacherDetailsRoute {
  const TeacherDetailsRoute({required this.teacherId});

  final int teacherId;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return TeacherDetailsScreen(teacherId: teacherId);
  }
}

@TypedGoRoute<UserManagementRoute>(path: '/user-management')
class UserManagementRoute extends GoRouteData with $UserManagementRoute {
  const UserManagementRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UserManagementScreen();
  }
}
