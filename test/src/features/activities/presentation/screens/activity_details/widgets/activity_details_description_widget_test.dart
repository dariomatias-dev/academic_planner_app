import 'dart:convert';

import 'package:academic_planner/src/features/activities/presentation/screens/activity_details/widgets/activity_details_description_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _harness(Widget child) {
  return MaterialApp(
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      FlutterQuillLocalizations.delegate,
    ],
    home: Scaffold(body: child),
  );
}

void main() {
  group('ActivityDetailsDescriptionWidget', () {
    testWidgets('plain text description → renders it through the editor', (
      tester,
    ) async {
      await tester.pumpWidget(
        _harness(
          const ActivityDetailsDescriptionWidget(
            description: 'Estudar capítulos 1 a 3',
          ),
        ),
      );
      await tester.pump(Duration.zero);
      await tester.pumpAndSettle();

      expect(
        find.text('Estudar capítulos 1 a 3', findRichText: true),
        findsOneWidget,
      );
    });

    testWidgets('quill delta JSON description → renders the document text', (
      tester,
    ) async {
      final delta = jsonEncode([
        {'insert': 'Resumo do conteúdo\n'},
      ]);

      await tester.pumpWidget(
        _harness(ActivityDetailsDescriptionWidget(description: delta)),
      );
      await tester.pump(Duration.zero);
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Resumo do conteúdo', findRichText: true),
        findsOneWidget,
      );
    });
  });
}
