import 'package:academic_planner/src/core/constants/disciplines/ads_disciplines.dart';
import 'package:academic_planner/src/core/di/shared_preferences_provider.dart';
import 'package:academic_planner/src/core/domain/entities/discipline.dart';
import 'package:academic_planner/src/core/services/shared_preferences_service.dart';
import 'package:academic_planner/src/core/shared_preferences_keys.dart';
import 'package:academic_planner/src/shared/widgets/forms/discipline_picker_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSharedPreferencesService extends Mock
    implements SharedPreferencesService {}

final Discipline _computacao = adsDisciplines.firstWhere((d) => d.id == 15);
final Discipline _algoritmos = adsDisciplines.firstWhere((d) => d.id == 14);
final Discipline _matematica = adsDisciplines.firstWhere((d) => d.id == 11);

Widget _harness(Widget child, {GlobalKey<FormState>? formKey}) {
  return MaterialApp(
    home: Scaffold(
      body: formKey != null ? Form(key: formKey, child: child) : child,
    ),
  );
}

void main() {
  group('DisciplinePickerFieldWidget', () {
    testWidgets('renders the label without an asterisk by default', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: _harness(DisciplinePickerFieldWidget(onSelected: (_) {})),
        ),
      );

      expect(find.text('Disciplina'), findsOneWidget);
    });

    testWidgets('isRequired → appends asterisk to the label', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: _harness(
            DisciplinePickerFieldWidget(onSelected: (_) {}, isRequired: true),
          ),
        ),
      );

      expect(find.text('Disciplina'), findsNothing);
      expect(find.text('Disciplina *'), findsOneWidget);
    });

    testWidgets('no selectedDiscipline → shows the placeholder copy', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: _harness(DisciplinePickerFieldWidget(onSelected: (_) {})),
        ),
      );

      expect(find.text('Nenhuma disciplina'), findsOneWidget);
      expect(
        find.text('Toque para vincular uma disciplina'),
        findsOneWidget,
      );
    });

    testWidgets('selectedDiscipline set → shows its name as selected', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: _harness(
            DisciplinePickerFieldWidget(
              onSelected: (_) {},
              selectedDiscipline: _computacao,
            ),
          ),
        ),
      );

      expect(find.text(_computacao.name), findsOneWidget);
      expect(find.text('Disciplina selecionada'), findsOneWidget);
    });

    testWidgets(
      'isRequired and no selection → validation shows the required error',
      (tester) async {
        final formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          ProviderScope(
            child: _harness(
              formKey: formKey,
              DisciplinePickerFieldWidget(
                onSelected: (_) {},
                isRequired: true,
              ),
            ),
          ),
        );

        formKey.currentState!.validate();
        await tester.pump();

        expect(find.text('A disciplina é obrigatória'), findsOneWidget);
      },
    );

    testWidgets('custom validator → its message is shown on validation', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        ProviderScope(
          child: _harness(
            formKey: formKey,
            DisciplinePickerFieldWidget(
              onSelected: (_) {},
              selectedDiscipline: _computacao,
              validator: (_) => 'Disciplina inválida para este período',
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pump();

      expect(
        find.text('Disciplina inválida para este período'),
        findsOneWidget,
      );
    });

    testWidgets(
      'tap → opens the modal listing only the user disciplines and '
      'selects one',
      (tester) async {
        final mockPrefs = MockSharedPreferencesService();
        when(
          () => mockPrefs.getStringListOrNull(
            SharedPreferencesKeys.userDisciplinesKey,
          ),
        ).thenReturn(['15', '14']);

        Discipline? selected;

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              sharedPreferencesServiceProvider.overrideWithValue(mockPrefs),
            ],
            child: _harness(
              DisciplinePickerFieldWidget(
                onSelected: (value) => selected = value,
              ),
            ),
          ),
        );

        await tester.tap(find.text('Nenhuma disciplina'));
        await tester.pumpAndSettle();

        expect(find.text(_computacao.name), findsOneWidget);
        expect(find.text(_algoritmos.name), findsOneWidget);
        expect(find.text(_matematica.name), findsNothing);

        await tester.tap(find.text(_algoritmos.name));
        await tester.pumpAndSettle();

        expect(selected, _algoritmos);
        expect(find.text('Minhas Disciplinas'), findsNothing);
      },
    );
  });
}
