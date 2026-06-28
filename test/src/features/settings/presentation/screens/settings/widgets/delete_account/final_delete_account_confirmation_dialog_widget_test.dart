import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/auth/presentation/providers/auth_notifier.dart';
import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/delete_account/final_delete_account_confirmation_dialog_widget.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier({this.onDeleteAccount});

  final Future<Result<void>> Function()? onDeleteAccount;

  @override
  Future<UserEntity?> build() async => null;

  @override
  Future<Result<void>> deleteAccount() {
    return onDeleteAccount?.call() ?? Future.value(const Success<void>(null));
  }
}

Future<ProviderContainer> _buildContainer({
  Future<Result<void>> Function()? onDeleteAccount,
}) async {
  final container = ProviderContainer(
    overrides: [
      authNotifierProvider.overrideWith(
        () => _FakeAuthNotifier(onDeleteAccount: onDeleteAccount),
      ),
    ],
  );

  await container.read(authNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                await FinalDeleteAccountConfirmationDialogWidget.show(
                  context,
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

  group('FinalDeleteAccountConfirmationDialogWidget', () {
    testWidgets('renders the final confirmation message', (tester) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Confirmação Final'), findsOneWidget);
      expect(find.text('Excluir Permanentemente'), findsOneWidget);
    });

    testWidgets('tapping "Cancelar" closes without deleting', (
      tester,
    ) async {
      var deleteCalls = 0;

      final container = await _buildContainer(
        onDeleteAccount: () async {
          deleteCalls++;

          return const Success<void>(null);
        },
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(deleteCalls, 0);
      expect(find.text('Confirmação Final'), findsNothing);
    });

    testWidgets('confirming success → deletes the account', (tester) async {
      var deleteCalls = 0;

      final container = await _buildContainer(
        onDeleteAccount: () async {
          deleteCalls++;

          return const Success<void>(null);
        },
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Excluir Permanentemente'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      expect(deleteCalls, 1);
    });

    testWidgets('confirming failure → shows the error dialog', (
      tester,
    ) async {
      final container = await _buildContainer(
        onDeleteAccount: () async =>
            const Failure<void>(UnknownFailure('boom')),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Excluir Permanentemente'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Ocorreu um erro ao tentar excluir sua conta'),
        findsOneWidget,
      );
    });
  });
}
