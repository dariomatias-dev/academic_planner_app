import 'package:academic_planner/src/core/routes/route_names.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/presentation/widgets/note_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';

Note _note() => Note(
  id: 'n1',
  title: 'Resumo da prova',
  content: 'conteúdo',
  disciplineId: 14,
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025, 3, 10),
);

Widget _harness(Widget child) {
  return ProviderScope(child: MaterialApp(home: Scaffold(body: child)));
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  group('NoteCardWidget', () {
    testWidgets('renders the title and the formatted update date', (
      tester,
    ) async {
      await tester.pumpWidget(_harness(NoteCardWidget(note: _note())));

      expect(find.text('Resumo da prova'), findsOneWidget);
      expect(find.text('10 de março, 2025'), findsOneWidget);
      expect(
        find.text(
          'Toque para visualizar o conteúdo completo da anotação...',
        ),
        findsOneWidget,
      );
    });

    testWidgets('tapping the card navigates to note details', (
      tester,
    ) async {
      String? receivedId;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => ProviderScope(
              child: Scaffold(body: NoteCardWidget(note: _note())),
            ),
          ),
          GoRoute(
            path: '/note/:noteId',
            name: RouteNames.noteDetails,
            builder: (_, state) {
              receivedId = state.pathParameters['noteId'];

              return const Text('NOTE_DETAILS_SCREEN');
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      await tester.tap(find.text('Resumo da prova'));
      await tester.pumpAndSettle();

      expect(receivedId, 'n1');
      expect(find.text('NOTE_DETAILS_SCREEN'), findsOneWidget);
    });

    testWidgets('opening the menu shows "Editar" and "Excluir"', (
      tester,
    ) async {
      await tester.pumpWidget(_harness(NoteCardWidget(note: _note())));

      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Editar'), findsOneWidget);
      expect(find.text('Excluir'), findsOneWidget);
    });

    testWidgets('tapping "Editar" navigates to the note form', (
      tester,
    ) async {
      String? receivedId;

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => ProviderScope(
              child: Scaffold(body: NoteCardWidget(note: _note())),
            ),
          ),
          GoRoute(
            path: '/note-form',
            name: RouteNames.noteForm,
            builder: (_, state) {
              receivedId = state.uri.queryParameters['noteId'];

              return const Text('NOTE_FORM_SCREEN');
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      await tester.tap(find.byIcon(Icons.more_vert_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();

      expect(receivedId, 'n1');
      expect(find.text('NOTE_FORM_SCREEN'), findsOneWidget);
    });
  });
}
