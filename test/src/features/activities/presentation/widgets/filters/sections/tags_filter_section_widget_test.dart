import 'package:academic_planner/src/features/activities/presentation/widgets/filters/sections/tags_filter_section_widget.dart';
import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/presentation/providers/tag_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTagNotifier extends TagNotifier {
  _FakeTagNotifier(this._tags);

  final List<Tag> _tags;

  @override
  Future<List<Tag>> build() async => _tags;
}

Future<ProviderContainer> _buildContainer(List<String> tags) async {
  final container = ProviderContainer(
    overrides: [
      tagNotifierProvider.overrideWith(
        () => _FakeTagNotifier(tags.map((name) => Tag(name: name)).toList()),
      ),
    ],
  );

  await container.read(tagNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container, Widget child) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(home: Scaffold(body: child)),
  );
}

void main() {
  group('TagsFilterSectionWidget', () {
    testWidgets('no tags selected → shows the placeholder', (tester) async {
      final container = await _buildContainer(['urgente']);
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          TagsFilterSectionWidget(tags: const [], onChanged: (_) {}),
        ),
      );

      expect(find.text('Nenhuma tag'), findsOneWidget);
      expect(find.text('Toque para selecionar'), findsOneWidget);
    });

    testWidgets('one tag selected → shows its name', (tester) async {
      final container = await _buildContainer(['urgente']);
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          TagsFilterSectionWidget(
            tags: const ['urgente'],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('urgente'), findsOneWidget);
      expect(find.text('Filtro ativo'), findsOneWidget);
    });

    testWidgets('multiple tags selected → shows the count', (tester) async {
      final container = await _buildContainer(['urgente', 'prova']);
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          TagsFilterSectionWidget(
            tags: const ['urgente', 'prova'],
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.text('2 tags selecionadas'), findsOneWidget);
    });

    testWidgets(
      'selecting tags in the modal and confirming calls onChanged',
      (tester) async {
        final container = await _buildContainer(['urgente', 'prova']);
        addTearDown(container.dispose);

        List<String>? confirmed;

        await tester.pumpWidget(
          _harness(
            container,
            TagsFilterSectionWidget(
              tags: const [],
              onChanged: (value) => confirmed = value,
            ),
          ),
        );

        await tester.tap(find.text('Nenhuma tag'));
        await tester.pumpAndSettle();

        expect(find.text('Filtrar por Tags'), findsOneWidget);

        await tester.tap(find.text('urgente'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Filtrar'));
        await tester.pumpAndSettle();

        expect(confirmed, ['urgente']);
        expect(find.text('Filtrar por Tags'), findsNothing);
      },
    );

    testWidgets('tapping "Limpar" in the modal clears the selection', (
      tester,
    ) async {
      final container = await _buildContainer(['urgente', 'prova']);
      addTearDown(container.dispose);

      List<String>? confirmed;

      await tester.pumpWidget(
        _harness(
          container,
          TagsFilterSectionWidget(
            tags: const ['urgente'],
            onChanged: (value) => confirmed = value,
          ),
        ),
      );

      await tester.tap(find.text('urgente'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Limpar'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Filtrar'));
      await tester.pumpAndSettle();

      expect(confirmed, isEmpty);
    });

    testWidgets('no tags registered → shows the empty state', (
      tester,
    ) async {
      final container = await _buildContainer([]);
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          TagsFilterSectionWidget(tags: const [], onChanged: (_) {}),
        ),
      );

      await tester.tap(find.text('Nenhuma tag'));
      await tester.pumpAndSettle();

      expect(
        find.text('Não há tags cadastradas para filtragem.'),
        findsOneWidget,
      );
    });
  });
}
