import 'dart:async';

import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/core/routes/route_names.dart';
import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/auth/domain/entities/register_entity.dart';
import 'package:academic_planner/src/features/auth/presentation/providers/auth_notifier.dart';
import 'package:academic_planner/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:academic_planner/src/features/auth/presentation/screens/register/register_screen.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier({this.onRegister});

  final Future<Result<void>> Function(RegisterEntity entity)? onRegister;

  @override
  Future<UserEntity?> build() async => null;

  @override
  Future<Result<void>> register(RegisterEntity entity) async {
    state = const AsyncLoading();

    final result = onRegister != null
        ? await onRegister!(entity)
        : const Success<void>(null);

    state = result.fold(
      onSuccess: (_) => const AsyncData(null),
      onFailure: (f) => AsyncError(f, StackTrace.current),
    );

    return result;
  }
}

Future<ProviderContainer> _buildContainer({
  Future<Result<void>> Function(RegisterEntity entity)? onRegister,
}) async {
  final container = ProviderContainer(
    overrides: [
      authNotifierProvider.overrideWith(
        () => _FakeAuthNotifier(onRegister: onRegister),
      ),
    ],
  );

  await container.read(authNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container) {
  final router = GoRouter(
    initialLocation: '/register',
    routes: [
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (_, _) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: RouteNames.register,
        builder: (_, _) => const RegisterScreen(),
      ),
    ],
  );

  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp.router(routerConfig: router),
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

  group('RegisterScreen', () {
    testWidgets('renders the form fields', (tester) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Criar Conta'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4));
      expect(find.text('Cadastrar agora'), findsOneWidget);
    });

    testWidgets('empty submit → shows validation errors', (tester) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cadastrar agora'));
      await tester.pumpAndSettle();

      expect(find.text('Este campo é obrigatório'), findsNWidgets(3));
    });

    testWidgets('password and confirmation mismatch → shows the compare '
        'error', (tester) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Dario Matias');
      await tester.enterText(fields.at(1), 'dario@email.com');
      await tester.enterText(fields.at(2), '12345678');
      await tester.enterText(fields.at(3), 'different');

      await tester.tap(find.text('Cadastrar agora'));
      await tester.pumpAndSettle();

      expect(find.text('As senhas não conferem'), findsOneWidget);
    });

    testWidgets('register pending → shows the loading state', (
      tester,
    ) async {
      final completer = Completer<Result<void>>();

      final container = await _buildContainer(
        onRegister: (_) => completer.future,
      );
      addTearDown(container.dispose);

      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Dario Matias');
      await tester.enterText(fields.at(1), 'dario@email.com');
      await tester.enterText(fields.at(2), '12345678');
      await tester.enterText(fields.at(3), '12345678');

      await tester.tap(find.text('Cadastrar agora'));
      await tester.pump();

      expect(find.text('Criando conta...'), findsOneWidget);

      completer.complete(const Success<void>(null));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('register success → shows a toast and navigates to login', (
      tester,
    ) async {
      final container = await _buildContainer(
        onRegister: (_) async => const Success<void>(null),
      );
      addTearDown(container.dispose);

      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Dario Matias');
      await tester.enterText(fields.at(1), 'dario@email.com');
      await tester.enterText(fields.at(2), '12345678');
      await tester.enterText(fields.at(3), '12345678');

      await tester.tap(find.text('Cadastrar agora'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('Criar Conta'), findsNothing);
    });

    testWidgets('register failure → stays on the register form', (
      tester,
    ) async {
      final container = await _buildContainer(
        onRegister: (_) async =>
            const Failure<void>(UnknownFailure('E-mail já cadastrado')),
      );
      addTearDown(container.dispose);

      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(0), 'Dario Matias');
      await tester.enterText(fields.at(1), 'dario@email.com');
      await tester.enterText(fields.at(2), '12345678');
      await tester.enterText(fields.at(3), '12345678');

      await tester.tap(find.text('Cadastrar agora'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Criar Conta'), findsOneWidget);
    });

    testWidgets('tapping "Fazer Login" opens LoginScreen', (tester) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Fazer Login'));
      await tester.pumpAndSettle();

      expect(find.text('Academic Planner'), findsOneWidget);
    });
  });
}
