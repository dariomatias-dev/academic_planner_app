import 'package:go_router/go_router.dart';

import 'package:academic_planner/src/core/root_navigation.dart';
import 'package:academic_planner/src/core/routes/route_names.dart';
import 'package:academic_planner/src/core/routes/route_paths.dart';

import 'package:academic_planner/src/screens/about/about_screen.dart';
import 'package:academic_planner/src/screens/activity_form/activity_form_screen.dart';
import 'package:academic_planner/src/screens/discipline_details/discipline_details_screen.dart';
import 'package:academic_planner/src/screens/discipline_selection/discipline_selection_screen.dart';
import 'package:academic_planner/src/screens/disciplines/disciplines_screen.dart';
import 'package:academic_planner/src/screens/my_schedule/my_schedule_screen.dart';
import 'package:academic_planner/src/screens/not_found/not_found_screen.dart';
import 'package:academic_planner/src/screens/pdf_viewer/pdf_viewer_screen.dart';
import 'package:academic_planner/src/screens/schedule/schedule_screen.dart';
import 'package:academic_planner/src/screens/splash/splash_screen.dart';

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
            name: RouteNames.splash,
            path: RoutePaths.splash,
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            name: RouteNames.disciplines,
            path: RoutePaths.disciplines,
            builder: (context, state) => const DisciplinesScreen(),
          ),
          GoRoute(
            name: RouteNames.activityForm,
            path: RoutePaths.activityForm,
            builder: (context, state) {
              final disciplineId =
                  int.tryParse(
                    state.uri.queryParameters['disciplineId'] ?? '0',
                  ) ??
                  0;

              return ActivityFormScreen(initialDisciplineId: disciplineId);
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
                subtitle: query['subtitle'],
              );
            },
          ),
          GoRoute(
            name: RouteNames.schedule,
            path: RoutePaths.schedule,
            builder: (context, state) => const ScheduleScreen(),
          ),
          GoRoute(
            name: RouteNames.mySchedule,
            path: RoutePaths.mySchedule,
            builder: (context, state) => const MyScheduleScreen(),
          ),
          GoRoute(
            name: RouteNames.disciplineSelection,
            path: RoutePaths.disciplineSelection,
            builder: (context, state) => const DisciplineSelectionScreen(),
          ),
          GoRoute(
            name: RouteNames.about,
            path: RoutePaths.about,
            builder: (context, state) => const AboutScreen(),
          ),
          GoRoute(
            name: RouteNames.disciplineDetails,
            path: '${RoutePaths.disciplineDetails}/:disciplineId',
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
        ],
      ),
    ],
  );
}
