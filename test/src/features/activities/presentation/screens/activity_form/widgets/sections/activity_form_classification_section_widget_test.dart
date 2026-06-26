import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/widgets/sections/activity_form_classification_section_widget.dart';
import 'package:academic_planner/src/features/categories/di/category_providers.dart';
import 'package:academic_planner/src/features/categories/domain/entities/category.dart';
import 'package:academic_planner/src/features/categories/presentation/providers/category_notifier.dart';
import 'package:academic_planner/src/features/disciplines/domain/entities/discipline.dart';
import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/presentation/providers/tag_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeCategoryNotifier extends CategoryNotifier {
  @override
  Future<List<Category>> build() async => const [Category(name: 'Prova')];
}

class _FakeTagNotifier extends TagNotifier {
  @override
  Future<List<Tag>> build() async => const [Tag(name: 'urgente')];
}

Future<ProviderContainer> _buildContainer() async {
  final container = ProviderContainer(
    overrides: [
      categoryNotifierProvider.overrideWith(_FakeCategoryNotifier.new),
      tagNotifierProvider.overrideWith(_FakeTagNotifier.new),
    ],
  );

  await container.read(categoryNotifierProvider.future);
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
  group('ActivityFormClassificationSectionWidget', () {
    testWidgets(
      'renders discipline placeholder, status, categories and tags',
      (tester) async {
        final container = await _buildContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          _harness(
            container,
            ActivityFormClassificationSectionWidget(
              discipline: ValueNotifier<Discipline?>(null),
              onDisciplineSelected: (_) {},
              status: ValueNotifier(ActivityStatus.pending),
              onStatusSelected: (_) {},
              category: ValueNotifier<String?>(null),
              onCategorySelected: (_) {},
              onCreateCategory: () {},
              tags: ValueNotifier<List<String>>(const []),
              onTagToggled: (_, {value = false}) {},
              onCreateTag: () {},
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Nenhuma disciplina'), findsOneWidget);
        expect(find.text('Pendente'), findsOneWidget);
        expect(find.text('Prova'), findsOneWidget);
        expect(find.text('urgente'), findsOneWidget);
      },
    );

    testWidgets('selecting a status calls onStatusSelected', (tester) async {
      ActivityStatus? selected;

      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _harness(
          container,
          ActivityFormClassificationSectionWidget(
            discipline: ValueNotifier<Discipline?>(null),
            onDisciplineSelected: (_) {},
            status: ValueNotifier(ActivityStatus.pending),
            onStatusSelected: (value) => selected = value,
            category: ValueNotifier<String?>(null),
            onCategorySelected: (_) {},
            onCreateCategory: () {},
            tags: ValueNotifier<List<String>>(const []),
            onTagToggled: (_, {value = false}) {},
            onCreateTag: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Concluído'));

      expect(selected, ActivityStatus.completed);
    });
  });
}
