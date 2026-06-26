import 'dart:async';

import 'package:academic_planner/src/core/result/failure.dart';
import 'package:academic_planner/src/core/result/result.dart';
import 'package:academic_planner/src/core/routes/route_names.dart';
import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/auth/domain/entities/login_entity.dart';
import 'package:academic_planner/src/features/auth/presentation/providers/auth_notifier.dart';
import 'package:academic_planner/src/features/auth/presentation/screens/forgot_password/forgot_password_screen.dart';
import 'package:academic_planner/src/features/auth/presentation/screens/login/login_screen.dart';
import 'package:academic_planner/src/features/auth/presentation/screens/register/register_screen.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

UserEntity _fakeUser() => UserEntity(
  id: 'u1',
  email: 'user@email.com',
  name: 'User',
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);

class _FakeAuthNotifier extends AuthNotifier {
  _FakeAuthNotifier({this.onSignIn, this.onSignInWithGoogle});

  final Future<Result<void>> Function(LoginEntity entity)? onSignIn;
  final Future<Result<void>> Function()? onSignInWithGoogle;

  @override
  Future<UserEntity?> build() async => null;

  @override
  Future<Result<void>> signIn(LoginEntity entity) async {
    state = const AsyncLoading();

    final result = onSignIn != null
        ? await onSignIn!(entity)
        : const Success<void>(null);

    state = result.fold(
      onSuccess: (_) => AsyncData(_fakeUser()),
      onFailure: (f) => AsyncError(f, StackTrace.current),
    );

    return result;
  }

  @override
  Future<Result<void>> signInWithGoogle() async {
    state = const AsyncLoading();

    final result = onSignInWithGoogle != null
        ? await onSignInWithGoogle!()
        : const Success<void>(null);

    state = result.fold(
      onSuccess: (_) => AsyncData(_fakeUser()),
      onFailure: (f) => AsyncError(f, StackTrace.current),
    );

    return result;
  }
}

Future<ProviderContainer> _buildContainer({
  Future<Result<void>> Function(LoginEntity entity)? onSignIn,
  Future<Result<void>> Function()? onSignInWithGoogle,
}) async {
  final container = ProviderContainer(
    overrides: [
      authNotifierProvider.overrideWith(
        () => _FakeAuthNotifier(
          onSignIn: onSignIn,
          onSignInWithGoogle: onSignInWithGoogle,
        ),
      ),
    ],
  );

  await container.read(authNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container) {
  final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/',
        name: RouteNames.home,
        builder: (_, _) => const Text('HOME_SCREEN'),
      ),
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
      GoRoute(
        path: '/forgot-password',
        name: RouteNames.forgotPassword,
        builder: (_, _) => const ForgotPasswordScreen(),
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

  group('LoginScreen', () {
    testWidgets('renders the form fields and the actions', (tester) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Academic Planner'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('Continuar com Google'), findsOneWidget);
      expect(find.text('Esqueceu sua senha?'), findsOneWidget);
      expect(find.text('Cadastre-se'), findsOneWidget);
    });

    testWidgets('empty submit → shows validation errors', (tester) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();

      expect(find.text('Este campo é obrigatório'), findsOneWidget);
      expect(find.text('A senha é obrigatória'), findsOneWidget);
    });

    testWidgets('signIn pending → shows the loading state', (tester) async {
      final completer = Completer<Result<void>>();

      final container = await _buildContainer(
        onSignIn: (_) => completer.future,
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'user@email.com',
      );
      await tester.enterText(find.byType(TextFormField).last, '12345678');
      await tester.tap(find.text('Entrar'));
      await tester.pump();

      expect(find.text('Entrando...'), findsOneWidget);

      completer.complete(const Success<void>(null));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('signIn success → shows a toast and navigates home', (
      tester,
    ) async {
      final container = await _buildContainer(
        onSignIn: (_) async => const Success<void>(null),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'user@email.com',
      );
      await tester.enterText(find.byType(TextFormField).last, '12345678');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('HOME_SCREEN'), findsOneWidget);
    });

    testWidgets('signIn failure → stays on the login form', (tester) async {
      final container = await _buildContainer(
        onSignIn: (_) async =>
            const Failure<void>(UnknownFailure('Credenciais inválidas')),
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byType(TextFormField).first,
        'user@email.com',
      );
      await tester.enterText(find.byType(TextFormField).last, '12345678');
      await tester.tap(find.text('Entrar'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('HOME_SCREEN'), findsNothing);
    });

    testWidgets('tapping the Google button calls signInWithGoogle', (
      tester,
    ) async {
      var googleCalls = 0;

      final container = await _buildContainer(
        onSignInWithGoogle: () async {
          googleCalls++;

          return const Success<void>(null);
        },
      );
      addTearDown(container.dispose);

      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Continuar com Google'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));

      expect(googleCalls, 1);
    });

    testWidgets('tapping "Esqueceu sua senha?" opens ForgotPasswordScreen', (
      tester,
    ) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Esqueceu sua senha?'));
      await tester.pumpAndSettle();

      expect(find.text('Recuperar Senha'), findsOneWidget);
    });

    testWidgets('tapping "Cadastre-se" opens RegisterScreen', (tester) async {
      final container = await _buildContainer();
      addTearDown(container.dispose);

      await tester.binding.setSurfaceSize(const Size(800, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cadastre-se'));
      await tester.pumpAndSettle();

      expect(find.text('Criar Conta'), findsOneWidget);
    });
  });
}
