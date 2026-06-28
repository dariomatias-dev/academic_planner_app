import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/presentation/providers/tag_notifier.dart';
import 'package:academic_planner/src/features/tags/presentation/widgets/dialogs/tag_form_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTagNotifier extends TagNotifier {
  _FakeTagNotifier({this.tags = const [], this.onAdd, this.onEdit});

  final List<Tag> tags;
  final Future<Result<List<Tag>>> Function(String name)? onAdd;
  final Future<Result<List<Tag>>> Function(int index, String name)? onEdit;

  @override
  Future<List<Tag>> build() async => tags;

  @override
  Future<Result<List<Tag>>> add(String name) {
    return onAdd?.call(name) ?? Future.value(Success<List<Tag>>([...tags]));
  }

  @override
  Future<Result<List<Tag>>> edit(int index, String name) {
    return onEdit?.call(index, name) ??
        Future.value(Success<List<Tag>>([...tags]));
  }
}

Future<ProviderContainer> _buildContainer({
  List<Tag> tags = const [],
  Future<Result<List<Tag>>> Function(String name)? onAdd,
  Future<Result<List<Tag>>> Function(int index, String name)? onEdit,
}) async {
  final container = ProviderContainer(
    overrides: [
      tagNotifierProvider.overrideWith(
        () => _FakeTagNotifier(tags: tags, onAdd: onAdd, onEdit: onEdit),
      ),
    ],
  );

  await container.read(tagNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container, {Tag? tag, int? index}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                await TagFormDialogWidget.show(
                  context,
                  tag: tag,
                  index: index,
                );
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    ),
  );
}

void main() {
  const fluttertoastChannel = MethodChannel('PonnamKarthik/fluttertoast');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(fluttertoastChannel, (_) async => true);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(fluttertoastChannel, null);
  });

  group('TagFormDialogWidget (new tag)', () {
    testWidgets('renders the "Nova Tag" title with an empty field', (
      tester,
    ) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Nova Tag'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);

      final field = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(field.controller!.text, isEmpty);
    });

    testWidgets('saving with an empty name does nothing', (tester) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(find.text('Nova Tag'), findsOneWidget);
    });

    testWidgets('saving a valid name calls add and closes the dialog', (
      tester,
    ) async {
      String? addedName;

      final container = await _buildContainer(
        onAdd: (name) async {
          addedName = name;

          return const Success<List<Tag>>([]);
        },
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'Urgente');
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(addedName, 'Urgente');
      expect(find.text('Nova Tag'), findsNothing);
    });

    testWidgets('add failure → keeps the dialog open', (tester) async {
      final container = await _buildContainer(
        onAdd: (_) async => const Failure<List<Tag>>(UnknownFailure('boom')),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'Urgente');
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Nova Tag'), findsOneWidget);
    });

    testWidgets('tapping "Cancelar" closes without saving', (tester) async {
      var addCalls = 0;

      final container = await _buildContainer(
        onAdd: (_) async {
          addCalls++;

          return const Success<List<Tag>>([]);
        },
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(addCalls, 0);
      expect(find.text('Nova Tag'), findsNothing);
    });
  });

  group('TagFormDialogWidget (editing)', () {
    testWidgets('renders the "Editar Tag" title pre-filled with the tag '
        'name', (tester) async {
      const tag = Tag(name: 'Urgente');

      final container = await _buildContainer(tags: const [tag]);
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container, tag: tag, index: 0));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Editar Tag'), findsOneWidget);
      expect(find.text('Urgente'), findsOneWidget);
    });

    testWidgets('saving calls edit with the index and the new name', (
      tester,
    ) async {
      const tag = Tag(name: 'Urgente');
      int? editedIndex;
      String? editedName;

      final container = await _buildContainer(
        tags: const [tag],
        onEdit: (index, name) async {
          editedIndex = index;
          editedName = name;

          return const Success<List<Tag>>([]);
        },
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container, tag: tag, index: 0));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), 'Prova');
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(editedIndex, 0);
      expect(editedName, 'Prova');
      expect(find.text('Editar Tag'), findsNothing);
    });
  });
}
