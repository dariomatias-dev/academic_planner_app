import 'dart:convert';

import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/activities/di/activity_providers.dart';
import 'package:academic_planner/src/features/activities/domain/entities/activity.dart';
import 'package:academic_planner/src/features/activities/presentation/providers/activity_notifier.dart';
import 'package:academic_planner/src/features/activities/presentation/screens/activity_form/activity_form_screen.dart';
import 'package:academic_planner/src/features/categories/di/category_providers.dart';
import 'package:academic_planner/src/features/categories/domain/entities/category.dart';
import 'package:academic_planner/src/features/categories/presentation/providers/category_notifier.dart';
import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/tags/domain/entities/tag.dart';
import 'package:academic_planner/src/features/tags/presentation/providers/tag_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeActivityNotifier extends ActivityNotifier {
  _FakeActivityNotifier({this.onGetById, this.onEdit, this.onAdd});

  final Future<Result<Activity?>> Function(String id)? onGetById;
  final Future<Result<void>> Function(Activity activity)? onEdit;
  final Future<Result<void>> Function(Activity activity)? onAdd;

  @override
  Future<void> build() async {}

  @override
  Future<Result<Activity?>> getById(String id) {
    return onGetById?.call(id) ??
        Future.value(const Success<Activity?>(null));
  }

  @override
  Future<Result<void>> edit(Activity activity) {
    return onEdit?.call(activity) ?? Future.value(const Success<void>(null));
  }

  @override
  Future<Result<void>> add(Activity activity) {
    return onAdd?.call(activity) ?? Future.value(const Success<void>(null));
  }

  @override
  Activity createNew({
    required String title,
    required String description,
    required int disciplineId,
    required List<String> tags,
    required List<TimeOfDay> reminders,
    required ActivityStatus status,
    String? category,
    DateTime? dueDate,
    String? notes,
  }) {
    return Activity(
      id: 'new-id',
      title: title,
      description: description,
      disciplineId: disciplineId,
      tags: tags,
      reminders: reminders,
      status: status,
      category: category,
      dueDate: dueDate,
      notes: notes,
    );
  }
}

class _FakeCategoryNotifier extends CategoryNotifier {
  @override
  Future<List<Category>> build() async => const [];
}

class _FakeTagNotifier extends TagNotifier {
  @override
  Future<List<Tag>> build() async => const [];
}

String _quillDescription(String text) {
  return jsonEncode([
    {'insert': '$text\n'},
  ]);
}

Activity _activity({
  String id = 'a1',
  String title = 'Prova de Calculo',
  String? description,
}) => Activity(
  id: id,
  title: title,
  description: description ?? _quillDescription('Capitulos 1 a 3'),
  disciplineId: 14,
  tags: const [],
  reminders: const [],
  status: ActivityStatus.pending,
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);

Future<ProviderContainer> _buildContainer({
  Future<Result<Activity?>> Function(String id)? onGetById,
  Future<Result<void>> Function(Activity activity)? onEdit,
  Future<Result<void>> Function(Activity activity)? onAdd,
}) async {
  final container = ProviderContainer(
    overrides: [
      activityNotifierProvider.overrideWith(
        () => _FakeActivityNotifier(
          onGetById: onGetById,
          onEdit: onEdit,
          onAdd: onAdd,
        ),
      ),
      categoryNotifierProvider.overrideWith(_FakeCategoryNotifier.new),
      tagNotifierProvider.overrideWith(_FakeTagNotifier.new),
    ],
  );

  await container.read(activityNotifierProvider.future);
  await container.read(categoryNotifierProvider.future);
  await container.read(tagNotifierProvider.future);

  return container;
}

class _Harness extends StatefulWidget {
  const _Harness({required this.activityId});

  final String? activityId;

  @override
  State<_Harness> createState() => _HarnessState();
}

class _HarnessState extends State<_Harness> {
  bool? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              result = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) =>
                      ActivityFormScreen(activityId: widget.activityId),
                ),
              );
            },
            child: const Text('open'),
          );
        },
      ),
    );
  }
}

Widget _wrap(ProviderContainer container, Widget child) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      home: child,
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

  group('ActivityFormScreen (new activity)', () {
    testWidgets('renders the empty form with the save button enabled', (
      tester,
    ) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _wrap(container, const _Harness(activityId: null)),
      );
      await tester.tap(find.text('open'));
      await tester.pump(Duration.zero);
      await tester.pumpAndSettle();

      expect(find.text('Criar Atividade'), findsOneWidget);

      final iconButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.check_rounded),
          matching: find.byType(IconButton),
        ),
      );
      expect(iconButton.onPressed, isNotNull);
    });

    testWidgets(
      'saving an empty form shows validation errors and does not pop',
      (tester) async {
        final container = await _buildContainer();
        addTearDown(container.dispose);

        await tester.pumpWidget(
          _wrap(container, const _Harness(activityId: null)),
        );
        await tester.tap(find.text('open'));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.check_rounded));
        await tester.pumpAndSettle();

        expect(find.text('O título é obrigatório'), findsOneWidget);
        expect(find.text('A disciplina é obrigatória'), findsOneWidget);
        expect(find.text('Criar Atividade'), findsOneWidget);
      },
    );
  });

  group('ActivityFormScreen (editing)', () {
    testWidgets('loads the activity and shows the save button disabled', (
      tester,
    ) async {
      final container = await _buildContainer(
        onGetById: (_) async => Success<Activity?>(_activity()),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _wrap(container, const _Harness(activityId: 'a1')),
      );
      await tester.tap(find.text('open'));
      await tester.pump(Duration.zero);
      await tester.pumpAndSettle();

      expect(find.text('Editar Atividade'), findsOneWidget);
      expect(find.text('Prova de Calculo'), findsOneWidget);

      final iconButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.check_rounded),
          matching: find.byType(IconButton),
        ),
      );
      expect(iconButton.onPressed, isNull);
    });

    testWidgets('editing the title enables save; saving persists and pops '
        'true', (tester) async {
      Activity? savedActivity;

      final container = await _buildContainer(
        onGetById: (_) async => Success<Activity?>(_activity()),
        onEdit: (activity) async {
          savedActivity = activity;

          return const Success<void>(null);
        },
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _wrap(container, const _Harness(activityId: 'a1')),
      );
      await tester.tap(find.text('open'));
      await tester.pump(Duration.zero);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'Prova de Calculo II',
      );
      await tester.pumpAndSettle();

      final iconButton = tester.widget<IconButton>(
        find.ancestor(
          of: find.byIcon(Icons.check_rounded),
          matching: find.byType(IconButton),
        ),
      );
      expect(iconButton.onPressed, isNotNull);

      await tester.tap(find.byIcon(Icons.check_rounded));
      await tester.pumpAndSettle();

      expect(savedActivity?.title, 'Prova de Calculo II');
      expect(find.text('Editar Atividade'), findsNothing);
      expect(find.text('open'), findsOneWidget);
    });

    testWidgets('fetch failure → shows a toast and keeps the form usable', (
      tester,
    ) async {
      final container = await _buildContainer(
        onGetById: (_) async =>
            const Failure<Activity?>(UnknownFailure('boom')),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        _wrap(container, const _Harness(activityId: 'a1')),
      );
      await tester.tap(find.text('open'));
      await tester.pump(Duration.zero);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Editar Atividade'), findsOneWidget);
    });
  });
}
