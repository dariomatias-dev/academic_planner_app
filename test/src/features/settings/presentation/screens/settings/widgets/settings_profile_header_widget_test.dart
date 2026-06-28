import 'package:academic_planner/src/core/routes/route_names.dart';
import 'package:academic_planner/src/features/settings/presentation/screens/settings/widgets/settings_profile_header_widget.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/presentation/providers/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

class _FakeUserNotifier extends UserNotifier {
  _FakeUserNotifier(this._user);

  final UserEntity? _user;

  @override
  Future<UserEntity?> build() async => _user;
}

UserEntity _user({UserRole role = UserRole.student}) => UserEntity(
  id: 'u1',
  email: 'user@email.com',
  name: 'Dario Matias',
  role: role,
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);

Future<ProviderContainer> _buildContainer(UserEntity? user) async {
  final container = ProviderContainer(
    overrides: [
      userNotifierProvider.overrideWith(() => _FakeUserNotifier(user)),
    ],
  );

  await container.read(userNotifierProvider.future);

  return container;
}

Widget _harness(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(
      home: Scaffold(body: SettingsProfileHeaderWidget()),
    ),
  );
}

void main() {
  group('SettingsProfileHeaderWidget', () {
    testWidgets('no user → shows the login prompt', (tester) async {
      final container = await _buildContainer(null);
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Entre na sua conta'), findsOneWidget);
      expect(find.text('Acesse seus dados acadêmicos'), findsOneWidget);
    });

    testWidgets('logged in → shows the name, email and role badge', (
      tester,
    ) async {
      final container = await _buildContainer(_user());
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Dario Matias'), findsOneWidget);
      expect(find.text('user@email.com'), findsOneWidget);
      expect(find.text('ALUNO'), findsOneWidget);
      expect(find.text('Entre na sua conta'), findsNothing);
    });

    testWidgets('logged in → shows the static institution card', (
      tester,
    ) async {
      final container = await _buildContainer(_user());
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(
        find.text('Análise e Desenvolvimento de Sistemas'),
        findsOneWidget,
      );
      expect(find.text('IFPB Campus Esperança'), findsOneWidget);
    });

    testWidgets('no user → tapping the prompt navigates to login', (
      tester,
    ) async {
      final container = await _buildContainer(null);
      addTearDown(container.dispose);

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, _) => const Scaffold(
              body: SettingsProfileHeaderWidget(),
            ),
          ),
          GoRoute(
            path: '/login',
            name: RouteNames.login,
            builder: (_, _) => const Text('LOGIN_SCREEN'),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Entre na sua conta'));
      await tester.pumpAndSettle();

      expect(find.text('LOGIN_SCREEN'), findsOneWidget);
    });
  });
}
