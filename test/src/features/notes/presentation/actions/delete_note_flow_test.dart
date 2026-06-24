import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/notes/di/note_providers.dart';
import 'package:academic_planner/src/features/notes/domain/entities/note.dart';
import 'package:academic_planner/src/features/notes/domain/repositories/note_repository.dart';
import 'package:academic_planner/src/features/notes/presentation/actions/delete_note_flow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNoteRepository extends Mock implements NoteRepository {}

final Note _note = Note(
  id: '1',
  title: 'Aula 1',
  content: 'Content',
  disciplineId: 1,
);

Widget _harness(
  Future<void> Function(BuildContext context, WidgetRef ref) onPressed,
) {
  return MaterialApp(
    home: Scaffold(
      body: Consumer(
        builder: (context, ref, _) {
          return ElevatedButton(
            onPressed: () => onPressed(context, ref),
            child: const Text('trigger'),
          );
        },
      ),
    ),
  );
}

void main() {
  late MockNoteRepository mockRepository;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(_note);
  });

  setUp(() async {
    mockRepository = MockNoteRepository();
    container = ProviderContainer(
      overrides: [noteRepositoryProvider.overrideWithValue(mockRepository)],
    );

    addTearDown(container.dispose);

    container.read(noteNotifierProvider.notifier);

    await container.read(noteNotifierProvider.future);
  });

  testWidgets(
    'shows the confirm dialog with the note title interpolated',
    (tester) async {
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: _harness(
            (context, ref) {
              return deleteNoteFlow(context: context, ref: ref, note: _note);
            },
          ),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir Anotação'), findsOneWidget);
      expect(
        find.text(
          "Tem certeza que deseja excluir 'Aula 1'? "
          'Esta ação não poderá ser desfeita.',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('cancel → does not call delete and returns false', (
    tester,
  ) async {
    bool? result;

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: _harness((context, ref) async {
          result = await deleteNoteFlow(
            context: context,
            ref: ref,
            note: _note,
          );
        }),
      ),
    );

    await tester.tap(find.text('trigger'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    verifyNever(() => mockRepository.delete(any()));

    expect(result, isFalse);
  });

  testWidgets(
    'confirm success → deletes by id, shows success dialog and returns true',
    (tester) async {
      when(
        () => mockRepository.delete('1'),
      ).thenAnswer((_) async => const Success<void>(null));

      bool? result;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: _harness((context, ref) async {
            result = await deleteNoteFlow(
              context: context,
              ref: ref,
              note: _note,
            );
          }),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Excluir'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Anotação Removida'), findsOneWidget);
      expect(
        find.text(
          'A anotação foi excluída com sucesso da sua base de dados.',
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Entendido'));
      await tester.pumpAndSettle();

      verify(() => mockRepository.delete('1')).called(1);

      expect(result, isTrue);
    },
  );

  testWidgets(
    'confirm failure → shows the failure dialog with the error message',
    (tester) async {
      when(
        () => mockRepository.delete('1'),
      ).thenAnswer((_) async => const Failure<void>(UnknownFailure('boom')));

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: _harness(
            (context, ref) {
              return deleteNoteFlow(context: context, ref: ref, note: _note);
            },
          ),
        ),
      );

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Excluir'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.text(
          'Não conseguimos remover a anotação no momento.'
          ' Por favor, tente novamente em instantes.',
        ),
        findsOneWidget,
      );
      expect(find.text('boom'), findsOneWidget);
    },
  );
}
