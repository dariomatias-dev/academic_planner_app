import 'package:academic_planner/src/core/errors/failure.dart';
import 'package:academic_planner/src/core/errors/result.dart';
import 'package:academic_planner/src/shared/actions/removal_flow.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/pump_app.dart';

void main() {
  group('resultToError', () {
    test('Success → returns null', () async {
      final error = await resultToError(
        Future.value(const Success<void>(null)),
      );

      expect(error, isNull);
    });

    test('Failure → returns the failure message', () async {
      final error = await resultToError(
        Future.value(const Failure<void>(UnknownFailure('boom'))),
      );

      expect(error, 'boom');
    });
  });

  group('removalFlow', () {
    testWidgets('cancel → does not call onDelete, returns false', (
      tester,
    ) async {
      bool? result;
      var deleteCalls = 0;

      await pumpScopedApp(tester, (context) async {
        result = await removalFlow(
          context: context,
          confirmTitle: 'Excluir item',
          confirmMessage: 'Tem certeza?',
          onDelete: () async {
            deleteCalls++;
            return null;
          },
        );
      });

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      expect(find.text('Excluir item'), findsOneWidget);

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(deleteCalls, 0);
      expect(result, isFalse);
      expect(find.text('Excluir item'), findsNothing);
    });

    testWidgets(
      'confirm success without success dialog → calls onSuccess, returns true',
      (tester) async {
        bool? result;
        var onSuccessCalls = 0;

        await pumpScopedApp(tester, (context) async {
          result = await removalFlow(
            context: context,
            confirmTitle: 'Excluir item',
            confirmMessage: 'Tem certeza?',
            onDelete: () async => null,
            onSuccess: () => onSuccessCalls++,
          );
        });

        await tester.tap(find.text('trigger'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Excluir'));
        await tester.pumpAndSettle();

        expect(onSuccessCalls, 1);
        expect(result, isTrue);
        expect(find.text('Excluir item'), findsNothing);
      },
    );

    testWidgets(
      'confirm success with success dialog → shows it, then calls onSuccess',
      (tester) async {
        bool? result;
        var onSuccessCalls = 0;

        await pumpScopedApp(tester, (context) async {
          result = await removalFlow(
            context: context,
            confirmTitle: 'Excluir item',
            confirmMessage: 'Tem certeza?',
            onDelete: () async => null,
            onSuccess: () => onSuccessCalls++,
            successTitle: 'Removido',
            successMessage: 'Item removido com sucesso.',
          );
        });

        await tester.tap(find.text('trigger'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Excluir'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));

        expect(find.text('Removido'), findsOneWidget);
        expect(onSuccessCalls, 0);
        expect(result, isNull);

        await tester.tap(find.text('Entendido'));
        await tester.pumpAndSettle();

        expect(onSuccessCalls, 1);
        expect(result, isTrue);
        expect(find.text('Excluir item'), findsNothing);
      },
    );

    testWidgets('delete failure → shows failure dialog with error message', (
      tester,
    ) async {
      await pumpScopedApp(tester, (context) async {
        await removalFlow(
          context: context,
          confirmTitle: 'Excluir item',
          confirmMessage: 'Tem certeza?',
          onDelete: () async => 'network error',
        );
      });

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Excluir'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(
        find.text(
          'Não conseguimos remover o item no momento.'
          ' Por favor, tente novamente em instantes.',
        ),
        findsOneWidget,
      );
      expect(find.text('network error'), findsOneWidget);
    });

    testWidgets('failure → close without retry returns false', (
      tester,
    ) async {
      bool? result;
      var deleteCalls = 0;

      await pumpScopedApp(tester, (context) async {
        result = await removalFlow(
          context: context,
          confirmTitle: 'Excluir item',
          confirmMessage: 'Tem certeza?',
          onDelete: () async {
            deleteCalls++;
            return 'network error';
          },
        );
      });

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Excluir'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Fechar'));
      await tester.pumpAndSettle();

      expect(deleteCalls, 1);
      expect(result, isFalse);
      expect(find.text('Excluir item'), findsNothing);
    });

    testWidgets('failure → retry attempts delete again until it succeeds', (
      tester,
    ) async {
      bool? result;
      var deleteCalls = 0;

      await pumpScopedApp(tester, (context) async {
        result = await removalFlow(
          context: context,
          confirmTitle: 'Excluir item',
          confirmMessage: 'Tem certeza?',
          onDelete: () async {
            deleteCalls++;

            return deleteCalls == 1 ? 'network error' : null;
          },
        );
      });

      await tester.tap(find.text('trigger'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Excluir'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      await tester.tap(find.text('Tentar Novamente'));
      await tester.pumpAndSettle();

      expect(deleteCalls, 2);
      expect(result, isTrue);
      expect(find.text('Excluir item'), findsNothing);
    });
  });
}
