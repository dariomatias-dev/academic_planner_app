import 'package:academic_planner/src/core/routes/route_names.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_about_tab/discipline_details_course_plan_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('DisciplineDetailsCoursePlanButtonWidget', () {
    testWidgets('renders the icon and the label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DisciplineDetailsCoursePlanButtonWidget(
              url: 'https://example.com/plan.pdf',
              disciplineName: 'Algoritmos e Lógica de Programação',
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.picture_as_pdf_rounded), findsOneWidget);
      expect(find.text('Visualizar Plano de Ensino'), findsOneWidget);
    });

    testWidgets('tapping navigates to the pdf viewer with the url and '
        'title', (tester) async {
      String? receivedUrl;
      String? receivedTitle;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(
              body: DisciplineDetailsCoursePlanButtonWidget(
                url: 'https://example.com/plan.pdf',
                disciplineName: 'Algoritmos e Lógica de Programação',
              ),
            ),
          ),
          GoRoute(
            path: '/pdf',
            name: RouteNames.pdfViewer,
            builder: (_, state) {
              receivedUrl = state.uri.queryParameters['url'];
              receivedTitle = state.uri.queryParameters['title'];

              return const Text('PDF_SCREEN');
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      await tester.tap(find.text('Visualizar Plano de Ensino'));
      await tester.pumpAndSettle();

      expect(receivedUrl, 'https://example.com/plan.pdf');
      expect(receivedTitle, 'Algoritmos e Lógica de Programação');
      expect(find.text('PDF_SCREEN'), findsOneWidget);
    });
  });
}
