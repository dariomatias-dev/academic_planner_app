import 'package:academic_planner/src/features/course_details/presentation/screens/course_details/course_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the main sections of the course details screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: CourseDetailsScreen()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(tester.takeException(), isA<NetworkImageLoadException>());

    expect(find.text('Detalhes do Curso'), findsOneWidget);
    expect(
      find.text('Análise e\nDesenvolvimento\nde Sistemas'),
      findsOneWidget,
    );
    expect(find.text('IFPB Campus Esperança'), findsOneWidget);
    expect(find.text('VISÃO GERAL'), findsOneWidget);
    expect(find.text('O QUE VOCÊ IRÁ APRENDER'), findsOneWidget);
    expect(find.text('RECURSOS OFICIAIS'), findsOneWidget);
    expect(find.text('Projeto Pedagógico (PPC)'), findsOneWidget);
    expect(find.text('Estrutura Curricular'), findsOneWidget);
    expect(find.text('GESTÃO DO CURSO'), findsOneWidget);
    expect(find.text('Valderi Reis da Silva'), findsOneWidget);
    expect(find.text('ads.esperanca@ifpb.edu.br'), findsOneWidget);
    expect(find.text('DADOS ADMINISTRATIVOS'), findsOneWidget);
    expect(find.text('Instituto Federal da Paraíba'), findsOneWidget);
  });
}
