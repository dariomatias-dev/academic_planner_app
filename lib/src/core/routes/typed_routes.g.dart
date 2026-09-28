// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typed_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [
  $appShellRoute,
  $aboutRoute,
  $activityDetailsRoute,
  $activityFormRoute,
  $agendaRoute,
  $categoriesRoute,
  $courseDetailsRoute,
  $disciplineDetailsRoute,
  $disciplineSelectionRoute,
  $disciplinesRoute,
  $editProfileRoute,
  $forgotPasswordRoute,
  $loginRoute,
  $myScheduleRoute,
  $noteDetailsRoute,
  $noteFormRoute,
  $pdfViewerRoute,
  $registerRoute,
  $scheduleRoute,
  $splashRoute,
  $tagsRoute,
  $teacherDetailsRoute,
  $userManagementRoute,
];

RouteBase get $appShellRoute => StatefulShellRouteData.$route(
  navigatorContainerBuilder: AppShellRoute.$navigatorContainerBuilder,
  factory: $AppShellRouteExtension._fromState,
  branches: [
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/home',
          hasOverriddenOnExit: false,
          factory: $HomeRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/my-disciplines',
          hasOverriddenOnExit: false,
          factory: $MyDisciplinesRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/activities',
          hasOverriddenOnExit: false,
          factory: $ActivitiesRoute._fromState,
        ),
      ],
    ),
    StatefulShellBranchData.$branch(
      routes: [
        GoRouteData.$route(
          path: '/settings',
          hasOverriddenOnExit: false,
          factory: $SettingsRoute._fromState,
        ),
      ],
    ),
  ],
);

extension $AppShellRouteExtension on AppShellRoute {
  static AppShellRoute _fromState(GoRouterState state) => const AppShellRoute();
}

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/home');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MyDisciplinesRoute on GoRouteData {
  static MyDisciplinesRoute _fromState(GoRouterState state) =>
      const MyDisciplinesRoute();

  @override
  String get location => GoRouteData.$location('/my-disciplines');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ActivitiesRoute on GoRouteData {
  static ActivitiesRoute _fromState(GoRouterState state) =>
      const ActivitiesRoute();

  @override
  String get location => GoRouteData.$location('/activities');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $aboutRoute => GoRouteData.$route(
  path: '/about',
  hasOverriddenOnExit: false,
  factory: $AboutRoute._fromState,
);

mixin $AboutRoute on GoRouteData {
  static AboutRoute _fromState(GoRouterState state) => const AboutRoute();

  @override
  String get location => GoRouteData.$location('/about');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $activityDetailsRoute => GoRouteData.$route(
  path: '/activity-details/:activityId',
  hasOverriddenOnExit: false,
  factory: $ActivityDetailsRoute._fromState,
);

mixin $ActivityDetailsRoute on GoRouteData {
  static ActivityDetailsRoute _fromState(GoRouterState state) =>
      ActivityDetailsRoute(activityId: state.pathParameters['activityId']!);

  ActivityDetailsRoute get _self => this as ActivityDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/activity-details/${Uri.encodeComponent(_self.activityId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $activityFormRoute => GoRouteData.$route(
  path: '/activity-form',
  hasOverriddenOnExit: false,
  factory: $ActivityFormRoute._fromState,
);

mixin $ActivityFormRoute on GoRouteData {
  static ActivityFormRoute _fromState(GoRouterState state) => ActivityFormRoute(
    activityId: state.uri.queryParameters['activity-id'],
    disciplineId: _$convertMapValue(
      'discipline-id',
      state.uri.queryParameters,
      int.tryParse,
    ),
  );

  ActivityFormRoute get _self => this as ActivityFormRoute;

  @override
  String get location => GoRouteData.$location(
    '/activity-form',
    queryParams: {
      if (_self.activityId != null) 'activity-id': _self.activityId,
      if (_self.disciplineId != null)
        'discipline-id': _self.disciplineId!.toString(),
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

T? _$convertMapValue<T>(
  String key,
  Map<String, String> map,
  T? Function(String) converter,
) {
  final value = map[key];
  return value == null ? null : converter(value);
}

RouteBase get $agendaRoute => GoRouteData.$route(
  path: '/agenda',
  hasOverriddenOnExit: false,
  factory: $AgendaRoute._fromState,
);

mixin $AgendaRoute on GoRouteData {
  static AgendaRoute _fromState(GoRouterState state) => const AgendaRoute();

  @override
  String get location => GoRouteData.$location('/agenda');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $categoriesRoute => GoRouteData.$route(
  path: '/categories',
  hasOverriddenOnExit: false,
  factory: $CategoriesRoute._fromState,
);

mixin $CategoriesRoute on GoRouteData {
  static CategoriesRoute _fromState(GoRouterState state) =>
      const CategoriesRoute();

  @override
  String get location => GoRouteData.$location('/categories');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $courseDetailsRoute => GoRouteData.$route(
  path: '/course-details',
  hasOverriddenOnExit: false,
  factory: $CourseDetailsRoute._fromState,
);

mixin $CourseDetailsRoute on GoRouteData {
  static CourseDetailsRoute _fromState(GoRouterState state) =>
      const CourseDetailsRoute();

  @override
  String get location => GoRouteData.$location('/course-details');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $disciplineDetailsRoute => GoRouteData.$route(
  path: '/discipline-details/:disciplineId',
  hasOverriddenOnExit: false,
  factory: $DisciplineDetailsRoute._fromState,
);

mixin $DisciplineDetailsRoute on GoRouteData {
  static DisciplineDetailsRoute _fromState(GoRouterState state) =>
      DisciplineDetailsRoute(
        disciplineId: int.parse(state.pathParameters['disciplineId']!),
        tab:
            _$convertMapValue('tab', state.uri.queryParameters, int.parse) ?? 0,
      );

  DisciplineDetailsRoute get _self => this as DisciplineDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/discipline-details/${Uri.encodeComponent(_self.disciplineId.toString())}',
    queryParams: {if (_self.tab != 0) 'tab': _self.tab.toString()},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $disciplineSelectionRoute => GoRouteData.$route(
  path: '/discipline-selection',
  hasOverriddenOnExit: false,
  factory: $DisciplineSelectionRoute._fromState,
);

mixin $DisciplineSelectionRoute on GoRouteData {
  static DisciplineSelectionRoute _fromState(GoRouterState state) =>
      const DisciplineSelectionRoute();

  @override
  String get location => GoRouteData.$location('/discipline-selection');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $disciplinesRoute => GoRouteData.$route(
  path: '/disciplines',
  hasOverriddenOnExit: false,
  factory: $DisciplinesRoute._fromState,
);

mixin $DisciplinesRoute on GoRouteData {
  static DisciplinesRoute _fromState(GoRouterState state) =>
      const DisciplinesRoute();

  @override
  String get location => GoRouteData.$location('/disciplines');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $editProfileRoute => GoRouteData.$route(
  path: '/edit-profile',
  hasOverriddenOnExit: false,
  factory: $EditProfileRoute._fromState,
);

mixin $EditProfileRoute on GoRouteData {
  static EditProfileRoute _fromState(GoRouterState state) =>
      const EditProfileRoute();

  @override
  String get location => GoRouteData.$location('/edit-profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $forgotPasswordRoute => GoRouteData.$route(
  path: '/forgot-password',
  hasOverriddenOnExit: false,
  factory: $ForgotPasswordRoute._fromState,
);

mixin $ForgotPasswordRoute on GoRouteData {
  static ForgotPasswordRoute _fromState(GoRouterState state) =>
      const ForgotPasswordRoute();

  @override
  String get location => GoRouteData.$location('/forgot-password');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $loginRoute => GoRouteData.$route(
  path: '/login',
  hasOverriddenOnExit: false,
  factory: $LoginRoute._fromState,
);

mixin $LoginRoute on GoRouteData {
  static LoginRoute _fromState(GoRouterState state) => const LoginRoute();

  @override
  String get location => GoRouteData.$location('/login');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $myScheduleRoute => GoRouteData.$route(
  path: '/my-schedule',
  hasOverriddenOnExit: false,
  factory: $MyScheduleRoute._fromState,
);

mixin $MyScheduleRoute on GoRouteData {
  static MyScheduleRoute _fromState(GoRouterState state) =>
      const MyScheduleRoute();

  @override
  String get location => GoRouteData.$location('/my-schedule');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $noteDetailsRoute => GoRouteData.$route(
  path: '/note-details/:noteId',
  hasOverriddenOnExit: false,
  factory: $NoteDetailsRoute._fromState,
);

mixin $NoteDetailsRoute on GoRouteData {
  static NoteDetailsRoute _fromState(GoRouterState state) =>
      NoteDetailsRoute(noteId: state.pathParameters['noteId']!);

  NoteDetailsRoute get _self => this as NoteDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/note-details/${Uri.encodeComponent(_self.noteId)}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $noteFormRoute => GoRouteData.$route(
  path: '/note-form',
  hasOverriddenOnExit: false,
  factory: $NoteFormRoute._fromState,
);

mixin $NoteFormRoute on GoRouteData {
  static NoteFormRoute _fromState(GoRouterState state) => NoteFormRoute(
    disciplineId: _$convertMapValue(
      'discipline-id',
      state.uri.queryParameters,
      int.tryParse,
    ),
    noteId: state.uri.queryParameters['note-id'],
  );

  NoteFormRoute get _self => this as NoteFormRoute;

  @override
  String get location => GoRouteData.$location(
    '/note-form',
    queryParams: {
      if (_self.disciplineId != null)
        'discipline-id': _self.disciplineId!.toString(),
      if (_self.noteId != null) 'note-id': _self.noteId,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $pdfViewerRoute => GoRouteData.$route(
  path: '/pdf-viewer',
  hasOverriddenOnExit: false,
  factory: $PdfViewerRoute._fromState,
);

mixin $PdfViewerRoute on GoRouteData {
  static PdfViewerRoute _fromState(GoRouterState state) => PdfViewerRoute(
    url: state.uri.queryParameters['url'],
    title: state.uri.queryParameters['title'],
  );

  PdfViewerRoute get _self => this as PdfViewerRoute;

  @override
  String get location => GoRouteData.$location(
    '/pdf-viewer',
    queryParams: {
      if (_self.url != null) 'url': _self.url,
      if (_self.title != null) 'title': _self.title,
    },
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $registerRoute => GoRouteData.$route(
  path: '/register',
  hasOverriddenOnExit: false,
  factory: $RegisterRoute._fromState,
);

mixin $RegisterRoute on GoRouteData {
  static RegisterRoute _fromState(GoRouterState state) => const RegisterRoute();

  @override
  String get location => GoRouteData.$location('/register');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $scheduleRoute => GoRouteData.$route(
  path: '/schedule',
  hasOverriddenOnExit: false,
  factory: $ScheduleRoute._fromState,
);

mixin $ScheduleRoute on GoRouteData {
  static ScheduleRoute _fromState(GoRouterState state) => ScheduleRoute(
    period: _$convertMapValue(
      'period',
      state.uri.queryParameters,
      int.tryParse,
    ),
  );

  ScheduleRoute get _self => this as ScheduleRoute;

  @override
  String get location => GoRouteData.$location(
    '/schedule',
    queryParams: {if (_self.period != null) 'period': _self.period!.toString()},
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $splashRoute => GoRouteData.$route(
  path: '/splash',
  hasOverriddenOnExit: false,
  factory: $SplashRoute._fromState,
);

mixin $SplashRoute on GoRouteData {
  static SplashRoute _fromState(GoRouterState state) => const SplashRoute();

  @override
  String get location => GoRouteData.$location('/splash');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $tagsRoute => GoRouteData.$route(
  path: '/tags',
  hasOverriddenOnExit: false,
  factory: $TagsRoute._fromState,
);

mixin $TagsRoute on GoRouteData {
  static TagsRoute _fromState(GoRouterState state) => const TagsRoute();

  @override
  String get location => GoRouteData.$location('/tags');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $teacherDetailsRoute => GoRouteData.$route(
  path: '/teacher-details/:teacherId',
  hasOverriddenOnExit: false,
  factory: $TeacherDetailsRoute._fromState,
);

mixin $TeacherDetailsRoute on GoRouteData {
  static TeacherDetailsRoute _fromState(GoRouterState state) =>
      TeacherDetailsRoute(
        teacherId: int.parse(state.pathParameters['teacherId']!),
      );

  TeacherDetailsRoute get _self => this as TeacherDetailsRoute;

  @override
  String get location => GoRouteData.$location(
    '/teacher-details/${Uri.encodeComponent(_self.teacherId.toString())}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $userManagementRoute => GoRouteData.$route(
  path: '/user-management',
  hasOverriddenOnExit: false,
  factory: $UserManagementRoute._fromState,
);

mixin $UserManagementRoute on GoRouteData {
  static UserManagementRoute _fromState(GoRouterState state) =>
      const UserManagementRoute();

  @override
  String get location => GoRouteData.$location('/user-management');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
