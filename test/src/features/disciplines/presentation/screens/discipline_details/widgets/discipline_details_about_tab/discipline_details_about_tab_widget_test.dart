import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/routes/route_names.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_about_tab_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('DisciplineDetailsAboutTabWidget', () {
    testWidgets('renders description, teacher, schedules, requirements '
        'and the course plan button', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final discipline = adsDisciplines.firstWhere((d) => d.id == 14);
      final prerequisiteFor = adsDisciplines
          .where((d) => discipline.prerequisiteFor.contains(d.id))
          .toList();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DisciplineDetailsAboutTabWidget(
              discipline: discipline,
              prerequisites: const [],
              prerequisiteFor: prerequisiteFor,
            ),
          ),
        ),
      );

      expect(
        find.text(discipline.description, findRichText: true),
        findsOneWidget,
      );
      expect(find.text('Fernanda Costa Ribeiro'), findsOneWidget);
      expect(find.text('Horários das Aulas'), findsOneWidget);
      expect(find.text('Quinta'), findsOneWidget);
      expect(find.text('0 Disciplinas'), findsOneWidget);
      expect(
        find.text('${prerequisiteFor.length} Disciplinas'),
        findsOneWidget,
      );
      expect(find.text('Visualizar Plano de Ensino'), findsOneWidget);
    });

    testWidgets('tapping the teacher card navigates to teacher details', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final discipline = adsDisciplines.firstWhere((d) => d.id == 14);
      int? receivedId;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => Scaffold(
              body: DisciplineDetailsAboutTabWidget(
                discipline: discipline,
                prerequisites: const [],
                prerequisiteFor: const [],
              ),
            ),
          ),
          GoRoute(
            path: '/teacher/:teacherId',
            name: RouteNames.teacherDetails,
            builder: (_, state) {
              receivedId = int.parse(state.pathParameters['teacherId']!);

              return const Text('TEACHER_SCREEN');
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      await tester.tap(find.text('Fernanda Costa Ribeiro'));
      await tester.pumpAndSettle();

      expect(receivedId, discipline.responsibleProfessorId);
      expect(find.text('TEACHER_SCREEN'), findsOneWidget);
    });
  });
}
