import 'package:go_router/go_router.dart';

import 'package:academic_planner/src/core/root_navigation.dart';
import 'package:academic_planner/src/core/routes/route_names.dart';
import 'package:academic_planner/src/core/routes/route_paths.dart';

import 'package:academic_planner/src/features/about/presentation/screens/about/about_screen.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/activity_details_screen.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/activity_form_screen.dart';
import 'package:academic_planner/src/features/calendar/presentation/screens/agenda/agenda_screen.dart';
import 'package:academic_planner/src/features/categories/presentation/screens/categories/categories_screen.dart';
import 'package:academic_planner/src/features/course_details/presentation/screens/course_details/course_details_screen.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/discipline_details_screen.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_selection/discipline_selection_screen.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/disciplines/disciplines_screen.dart';
import 'package:academic_planner/src/features/users/presentation/screens/edit_profile/edit_profile_screen.dart';
import 'package:academic_planner/src/features/auth/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:academic_planner/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:academic_planner/src/features/schedule/presentation/screens/my_schedule/my_schedule_screen.dart';
import 'package:academic_planner/src/features/not_found/presentation/screens/not_found/not_found_screen.dart';
import 'package:academic_planner/src/features/notes/presentation/screens/note_details/note_details_screen.dart';
import 'package:academic_planner/src/features/notes/presentation/screens/note_form/note_form_screen.dart';
import 'package:academic_planner/src/features/pdf_viewer/presentation/screens/pdf_viewer/pdf_viewer_screen.dart';
import 'package:academic_planner/src/features/auth/presentation/screens/register/register_screen.dart';
import 'package:academic_planner/src/features/schedule/presentation/screens/schedule/schedule_screen.dart';
import 'package:academic_planner/src/features/splash/presentation/screens/splash/splash_screen.dart';
import 'package:academic_planner/src/features/tags/presentation/screens/tags/tags_screen.dart';
import 'package:academic_planner/src/features/teacher/presentation/screens/teacher_details/teacher_details_screen.dart';
import 'package:academic_planner/src/features/users/presentation/screens/user_management/user_management_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RoutePaths.splash,
    errorBuilder: (context, state) {
      return NotFoundScreen();
    },
    routes: <GoRoute>[
      GoRoute(
        name: RouteNames.root,
        path: RoutePaths.root,
        builder: (context, state) => const RootNavigation(),
        routes: <GoRoute>[
          GoRoute(
            name: RouteNames.about,
            path: RoutePaths.about,
            builder: (context, state) => const AboutScreen(),
          ),
          GoRoute(
            name: RouteNames.activityDetails,
            path: RoutePaths.activityDetails,
            builder: (context, state) {
              final activityId =
                  state.pathParameters['activityId'] ?? '';

              return ActivityDetailsScreen(activityId: activityId);
            },
          ),
          GoRoute(
            name: RouteNames.activityForm,
            path: RoutePaths.activityForm,
            builder: (context, state) {
              final disciplineId = int.tryParse(
                state.uri.queryParameters['disciplineId'] ?? '',
              );

              final activityId = state.uri.queryParameters['activityId'];

              return ActivityFormScreen(
                activityId: activityId,
                initialDisciplineId: disciplineId,
              );
            },
          ),
          GoRoute(
            name: RouteNames.categories,
            path: RoutePaths.categories,
            builder: (context, state) => const CategoriesScreen(),
          ),
          GoRoute(
            name: RouteNames.agenda,
            path: RoutePaths.agenda,
            builder: (context, state) => const AgendaScreen(),
          ),
          GoRoute(
            name: RouteNames.courseDetails,
            path: RoutePaths.courseDetails,
            builder: (context, state) => const CourseDetailsScreen(),
          ),
          GoRoute(
            name: RouteNames.disciplineDetails,
            path: RoutePaths.disciplineDetails,
            builder: (context, state) {
              final disciplineId =
                  int.tryParse(state.pathParameters['disciplineId'] ?? '0') ??
                  0;

              final initialTabIndex =
                  int.tryParse(state.uri.queryParameters['tab'] ?? '0') ?? 0;

              return DisciplineDetailsScreen(
                disciplineId: disciplineId,
                initialTabIndex: initialTabIndex,
              );
            },
          ),
          GoRoute(
            name: RouteNames.disciplineSelection,
            path: RoutePaths.disciplineSelection,
            builder: (context, state) => const DisciplineSelectionScreen(),
          ),
          GoRoute(
            name: RouteNames.disciplines,
            path: RoutePaths.disciplines,
            builder: (context, state) => const DisciplinesScreen(),
          ),
          GoRoute(
            name: RouteNames.editProfile,
            path: RoutePaths.editProfile,
            builder: (context, state) => const EditProfileScreen(),
          ),
          GoRoute(
            name: RouteNames.forgotPassword,
            path: RoutePaths.forgotPassword,
            builder: (context, state) => const ForgotPasswordScreen(),
          ),
          GoRoute(
            name: RouteNames.login,
            path: RoutePaths.login,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            name: RouteNames.mySchedule,
            path: RoutePaths.mySchedule,
            builder: (context, state) => const MyScheduleScreen(),
          ),
          GoRoute(
            name: RouteNames.noteForm,
            path: RoutePaths.noteForm,
            builder: (context, state) {
              final query = state.uri.queryParameters;
              final disciplineId =
                  int.tryParse(query['disciplineId'] ?? '0') ?? 0;

              return NoteFormScreen(
                noteId: query['noteId'],
                disciplineId: disciplineId,
              );
            },
          ),
          GoRoute(
            name: RouteNames.noteDetails,
            path: RoutePaths.noteDetails,
            builder: (context, state) {
              final noteId = state.pathParameters['noteId'] as String;

              return NoteDetailsScreen(noteId: noteId);
            },
          ),
          GoRoute(
            name: RouteNames.pdfViewer,
            path: RoutePaths.pdfViewer,
            builder: (context, state) {
              final query = state.uri.queryParameters;

              return PdfViewerScreen(
                url: query['url'] ?? '',
                title: query['title'] ?? '',
              );
            },
          ),
          GoRoute(
            name: RouteNames.register,
            path: RoutePaths.register,
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            name: RouteNames.schedule,
            path: RoutePaths.schedule,
            builder: (context, state) {
              final periodParam = state.uri.queryParameters['period'];
              final initialPeriod =
                  periodParam != null ? int.tryParse(periodParam) : null;
              return ScheduleScreen(initialPeriod: initialPeriod);
            },
          ),
          GoRoute(
            name: RouteNames.splash,
            path: RoutePaths.splash,
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            name: RouteNames.tags,
            path: RoutePaths.tags,
            builder: (context, state) => const TagsScreen(),
          ),
          GoRoute(
            name: RouteNames.teacherDetails,
            path: RoutePaths.teacherDetails,
            builder: (context, state) {
              final teacherId =
                  int.tryParse(state.pathParameters['teacherId'] ?? '0') ?? 0;

              return TeacherDetailsScreen(teacherId: teacherId);
            },
          ),
          GoRoute(
            name: RouteNames.userManagement,
            path: RoutePaths.userManagement,
            builder: (context, state) => const UserManagementScreen(),
          ),
        ],
      ),
    ],
  );
}
