import 'package:academic_planner/src/core/di/theme_provider.dart';
import 'package:academic_planner/src/core/theme/theme_notifier.dart';
import 'package:academic_planner/src/features/settings/presentation/screens/settings/settings_screen.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/presentation/providers/user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeUserNotifier extends UserNotifier {
  _FakeUserNotifier(this._user);

  final UserEntity? _user;

  @override
  Future<UserEntity?> build() async => _user;
}

class _FakeThemeNotifier extends ThemeNotifier {
  _FakeThemeNotifier(this._mode);

  final ThemeMode _mode;
  ThemeMode? lastSetMode;

  @override
  ThemeMode build() => _mode;

  @override
  Future<void> setThemeMode(ThemeMode mode) async {
    lastSetMode = mode;
    state = mode;
  }
}

UserEntity _user() => UserEntity(
  id: 'u1',
  email: 'user@email.com',
  name: 'Dario Matias',
  createdAt: DateTime(2025),
  updatedAt: DateTime(2025),
);

ProviderContainer _buildContainer({
  UserEntity? user,
  ThemeMode themeMode = ThemeMode.system,
}) {
  return ProviderContainer(
    overrides: [
      userNotifierProvider.overrideWith(() => _FakeUserNotifier(user)),
      themeNotifierProvider.overrideWith(() => _FakeThemeNotifier(themeMode)),
    ],
  );
}

Widget _harness(ProviderContainer container) {
  return UncontrolledProviderScope(
    container: container,
    child: const MaterialApp(home: SettingsScreen()),
  );
}

void main() {
  group('SettingsScreen', () {
    testWidgets('no user → hides account-related sections', (tester) async {
      final container = _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('MINHA CONTA'), findsNothing);
      expect(find.text('SESSÃO E SEGURANÇA'), findsNothing);
      expect(find.text('INFORMAÇÕES DO CURSO'), findsOneWidget);
      expect(find.text('ORGANIZAÇÃO'), findsOneWidget);
      expect(find.text('PREFERÊNCIAS'), findsOneWidget);
      expect(find.text('SUPORTE'), findsOneWidget);
    });

    testWidgets('logged in → shows account-related sections', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = _buildContainer(user: _user());
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('MINHA CONTA'), findsOneWidget);
      expect(find.text('Editar Perfil'), findsOneWidget);
      expect(find.text('SESSÃO E SEGURANÇA'), findsOneWidget);
      expect(find.text('Sair da Conta'), findsOneWidget);
      expect(find.text('Excluir Conta'), findsOneWidget);
    });

    testWidgets('shows the current theme label on the theme tile', (
      tester,
    ) async {
      final container = _buildContainer(themeMode: ThemeMode.dark);
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      expect(find.text('Escuro'), findsOneWidget);
    });

    testWidgets('selecting a theme updates the theme notifier and closes '
        'the sheet', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = _buildContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Tema do Aplicativo'));
      await tester.pumpAndSettle();

      expect(find.text('Escolha o tema'), findsOneWidget);

      await tester.tap(find.text('Modo Escuro'));
      await tester.pumpAndSettle();

      expect(find.text('Escolha o tema'), findsNothing);
      expect(container.read(themeNotifierProvider), ThemeMode.dark);
    });

    testWidgets('tapping "Sair da Conta" opens the logout confirmation', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = _buildContainer(user: _user());
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sair da Conta'));
      await tester.pumpAndSettle();

      expect(find.text('Sair da Conta'), findsWidgets);
      expect(
        find.text(
          'Tem certeza que deseja encerrar sua sessão no Academic Planner?',
        ),
        findsOneWidget,
      );
    });

    testWidgets('tapping "Excluir Conta" opens the delete confirmation', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final container = _buildContainer(user: _user());
      addTearDown(container.dispose);

      await tester.pumpWidget(_harness(container));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Excluir Conta'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('Esta ação é irreversível'),
        findsOneWidget,
      );
    });
  });
}
