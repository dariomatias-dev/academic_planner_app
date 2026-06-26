import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/routes/route_names.dart';
import 'package:academic_planner/src/features/disciplines/presentation/widgets/discipline_card/discipline_card_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('DisciplineCardItemWidget', () {
    testWidgets('renders the discipline through DisciplineCardWidget', (
      tester,
    ) async {
      final discipline = adsDisciplines.firstWhere((d) => d.id == 14);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DisciplineCardItemWidget(index: 1, discipline: discipline),
          ),
        ),
      );

      expect(find.text('Algoritmos e Lógica de Programação'), findsOneWidget);
    });

    testWidgets('tapping navigates to discipline details with the right '
        'id', (tester) async {
      final discipline = adsDisciplines.firstWhere((d) => d.id == 14);
      int? receivedId;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => Scaffold(
              body: DisciplineCardItemWidget(
                index: 1,
                discipline: discipline,
              ),
            ),
          ),
          GoRoute(
            path: '/discipline/:disciplineId',
            name: RouteNames.disciplineDetails,
            builder: (_, state) {
              receivedId = int.parse(state.pathParameters['disciplineId']!);

              return const Text('DETAILS_SCREEN');
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      await tester.tap(find.text('Algoritmos e Lógica de Programação'));
      await tester.pumpAndSettle();

      expect(receivedId, 14);
      expect(find.text('DETAILS_SCREEN'), findsOneWidget);
    });
  });
}
