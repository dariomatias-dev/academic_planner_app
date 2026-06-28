import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/auth/presentation/providers/auth_notifier.dart';
import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/logout_confirmation_dialog_widget.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier({this.onSignOut});

  final Future<Result<void>> Function()? onSignOut;

  @override
  Future<UserEntity?> build() async => null;

  @override
  Future<Result<void>> signOut() {
    return onSignOut?.call() ?? Future.value(const Success<void>(null));
  }
}

Future<ProviderContainer> _buildContainer({
  Future<Result<void>> Function()? onSignOut,
}) async {
  final container = ProviderContainer(
    overrides: [
      authNotifierProvider.overrideWith(
        () => _FakeAuthNotifier(onSignOut: onSignOut),
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
                await LogoutConfirmationDialogWidget.show(context);
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

  group('LogoutConfirmationDialogWidget', () {
    testWidgets('renders the confirmation message', (tester) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Sair da Conta'), findsOneWidget);
      expect(
        find.text(
          'Tem certeza que deseja encerrar sua sessão no Academic Planner?',
        ),
        findsOneWidget,
      );
    });

    testWidgets('tapping "Cancelar" closes without signing out', (
      tester,
    ) async {
      var signOutCalls = 0;

      final container = await _buildContainer(
        onSignOut: () async {
          signOutCalls++;

          return const Success<void>(null);
        },
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(signOutCalls, 0);
      expect(find.text('Sair da Conta'), findsNothing);
    });

    testWidgets('tapping "Sair" signs out and closes the dialog', (
      tester,
    ) async {
      var signOutCalls = 0;

      final container = await _buildContainer(
        onSignOut: () async {
          signOutCalls++;

          return const Success<void>(null);
        },
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sair'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      expect(signOutCalls, 1);
      expect(find.text('Sair da Conta'), findsNothing);
    });
  });
}
