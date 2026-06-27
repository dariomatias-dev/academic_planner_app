import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/domain/entities/discipline.dart';
import 'package:academic_planner/src/core/domain/entities/schedule_entry.dart';
import 'package:academic_planner/src/core/routes/route_names.dart';
import 'package:academic_planner/src/core/routes/route_paths.dart';
import 'package:academic_planner/src/shared/widgets/schedule_table_view/schedule_data_cell/schedule_discipline_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

final Discipline _discipline = adsDisciplines.firstWhere((d) => d.id == 15);

const _entry = ScheduleEntry(
  disciplineId: 15,
  day: 2,
  time: '7:00',
  teacherId: 1,
);

Widget _harness(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(height: 200.0, width: 250.0, child: child),
      ),
    ),
  );
}

GoRouter _router(Widget home) {
  return GoRouter(
    initialLocation: RoutePaths.home,
    routes: [
      GoRoute(
        path: RoutePaths.home,
        builder: (_, _) => Scaffold(body: Center(child: home)),
      ),
      GoRoute(
        name: RouteNames.disciplineDetails,
        path: RoutePaths.disciplineDetails,
        builder: (context, state) {
          final disciplineId = state.pathParameters['disciplineId'];
          final tab = state.uri.queryParameters['tab'];

          return Scaffold(body: Text('details-$disciplineId-$tab'));
        },
      ),
    ],
  );
}

void main() {
  group('ScheduleDisciplineCardWidget', () {
    testWidgets('renders acronym, period, name and teacher', (tester) async {
      await tester.pumpWidget(
        _harness(
          ScheduleDisciplineCardWidget(
            entry: _entry,
            disciplines: adsDisciplines,
          ),
        ),
      );

      expect(find.text(_discipline.acronym), findsOneWidget);
      expect(find.text('${_discipline.period}º Período'), findsOneWidget);
      expect(find.text(_discipline.name), findsOneWidget);
      expect(find.text('Marcos Vinicius Andrade Lima'), findsOneWidget);
    });

    testWidgets(
      'tap → navigates to discipline details with the id and tab 2',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: _router(
              SizedBox(
                height: 200.0,
                width: 250.0,
                child: ScheduleDisciplineCardWidget(
                  entry: _entry,
                  disciplines: adsDisciplines,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.text(_discipline.name));
        await tester.pumpAndSettle();

        expect(find.text('details-15-2'), findsOneWidget);
      },
    );
  });
}
