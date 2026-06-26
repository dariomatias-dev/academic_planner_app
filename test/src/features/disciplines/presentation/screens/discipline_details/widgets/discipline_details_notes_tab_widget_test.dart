import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/disciplines/presentation/screens/discipline_details/widgets/discipline_details_notes_tab_widget.dart';
import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/presentation/providers/note_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

class _FakeNoteNotifier extends NoteNotifier {
  _FakeNoteNotifier(this._notes);

  final List<Note> _notes;

  @override
  Future<void> build() async {}

  @override
  Future<Result<List<Note>>> getAll() async => Success<List<Note>>(_notes);
}

Note _note() => Note(
  id: 'n1',
  title: 'Resumo da prova',
  content: 'conteúdo',
  disciplineId: 14,
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);

Future<ProviderContainer> _buildContainer(List<Note> notes) async {
  final container = ProviderContainer(
    overrides: [
      noteNotifierProvider.overrideWith(() => _FakeNoteNotifier(notes)),
    ],
  );

  await container.read(noteNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container, Widget child) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  group('DisciplineDetailsNotesTabWidget', () {
    testWidgets('no notes → shows the empty state', (tester) async {
      final container = await _buildContainer([]);
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          const DisciplineDetailsNotesTabWidget(disciplineId: 14),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sem anotações'), findsOneWidget);
      expect(find.text('Criar Anotação'), findsOneWidget);
    });

    testWidgets('has notes → renders one card per note', (tester) async {
      final container = await _buildContainer([_note()]);
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          const DisciplineDetailsNotesTabWidget(disciplineId: 14),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Resumo da prova'), findsOneWidget);
      expect(find.text('Sem anotações'), findsNothing);
    });
  });
}
