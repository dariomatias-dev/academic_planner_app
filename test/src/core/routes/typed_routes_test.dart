import 'package:academic_planner/src/core/routes/typed_routes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('typed route locations', () {
    test('static routes resolve to their path', () {
      expect(const HomeRoute().location, '/home');
      expect(const LoginRoute().location, '/login');
      expect(const SplashRoute().location, '/splash');
    });

    test('path parameters are embedded in the path', () {
      expect(
        const ActivityDetailsRoute(activityId: 'a1').location,
        '/activity-details/a1',
      );
      expect(
        const TeacherDetailsRoute(teacherId: 7).location,
        '/teacher-details/7',
      );
    });

    test('optional query parameters are omitted when null', () {
      expect(const ActivityFormRoute().location, '/activity-form');
      expect(const ScheduleRoute().location, '/schedule');
    });

    test('query parameters are kebab-case', () {
      expect(
        const ActivityFormRoute(
          activityId: 'a1',
          disciplineId: 3,
        ).location,
        '/activity-form?activity-id=a1&discipline-id=3',
      );
      expect(
        const NoteFormRoute(disciplineId: 3, noteId: 'n1').location,
        '/note-form?discipline-id=3&note-id=n1',
      );
    });

    test('discipline details defaults to the first tab', () {
      expect(
        const DisciplineDetailsRoute(disciplineId: 5).location,
        '/discipline-details/5',
      );
      expect(
        const DisciplineDetailsRoute(disciplineId: 5, tab: 2).location,
        '/discipline-details/5?tab=2',
      );
    });
  });
}
