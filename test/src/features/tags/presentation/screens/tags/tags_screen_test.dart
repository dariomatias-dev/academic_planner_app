import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/presentation/providers/tag_notifier.dart';
import 'package:academic_planner/src/features/tags/presentation/screens/tags/tags_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTagNotifier extends TagNotifier {
  _FakeTagNotifier({this.tags = const [], this.onAdd, this.onRemove});

  final List<Tag> tags;
  final Future<Result<List<Tag>>> Function(String name)? onAdd;
  final Future<Result<List<Tag>>> Function(int index)? onRemove;

  @override
  Future<List<Tag>> build() async => tags;

  @override
  Future<Result<List<Tag>>> add(String name) {
    return onAdd?.call(name) ?? Future.value(Success<List<Tag>>([...tags]));
  }

  @override
  Future<Result<List<Tag>>> remove(int index) {
    return onRemove?.call(index) ??
        Future.value(Success<List<Tag>>([...tags]));
  }
}

Future<ProviderContainer> _buildContainer({
  List<Tag> tags = const [],
  Future<Result<List<Tag>>> Function(String name)? onAdd,
  Future<Result<List<Tag>>> Function(int index)? onRemove,
}) async {
  final container = ProviderContainer(
    overrides: [
      tagNotifierProvider.overrideWith(
        () => _FakeTagNotifier(tags: tags, onAdd: onAdd, onRemove: onRemove),
      ),
    ],
  );

  await container.read(tagNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(home: TagsScreen()),
  );
}

void main() {
  group('TagsScreen', () {
    testWidgets('no tags → renders an empty list', (tester) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Tags'), findsOneWidget);
      expect(find.byIcon(Icons.local_offer_rounded), findsNothing);
    });

    testWidgets('renders one row per tag with edit and delete actions', (
      tester,
    ) async {
      final container = await _buildContainer(
        tags: const [Tag(name: 'Urgente'), Tag(name: 'Prova')],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Urgente'), findsOneWidget);
      expect(find.text('Prova'), findsOneWidget);
      expect(find.byIcon(Icons.edit_outlined), findsNWidgets(2));
      expect(find.byIcon(Icons.delete_outline_rounded), findsNWidgets(2));
    });

    testWidgets('tapping the add button opens the "Nova Tag" dialog', (
      tester,
    ) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.add_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Nova Tag'), findsOneWidget);
    });

    testWidgets('tapping the edit icon opens the dialog pre-filled', (
      tester,
    ) async {
      final container = await _buildContainer(
        tags: const [Tag(name: 'Urgente')],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Editar Tag'), findsOneWidget);
      expect(find.text('Urgente'), findsWidgets);
    });

    testWidgets('deleting a tag → confirm and remove it', (tester) async {
      int? removedIndex;

      final container = await _buildContainer(
        tags: const [Tag(name: 'Urgente')],
        onRemove: (index) async {
          removedIndex = index;

          return const Success<List<Tag>>([]);
        },
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Excluir Tag'), findsOneWidget);

      await tester.tap(find.text('Excluir'));
      await tester.pumpAndSettle();

      expect(removedIndex, 0);
    });

    testWidgets('canceling the delete confirmation does not remove the '
        'tag', (tester) async {
      var removeCalls = 0;

      final container = await _buildContainer(
        tags: const [Tag(name: 'Urgente')],
        onRemove: (_) async {
          removeCalls++;

          return const Success<List<Tag>>([]);
        },
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(removeCalls, 0);
      expect(find.text('Urgente'), findsOneWidget);
    });
  });
}
