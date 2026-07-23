import 'package:academic_planner/src/shared/screens/not_found/not_found_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void _pushMissing(GoRouter router) => router.push<void>('/missing');

GoRouter _router() {
  return GoRouter(
    initialLocation: '/missing',
    routes: [
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const Scaffold(body: Text('home screen')),
      ),
      GoRoute(
        path: '/missing',
        builder: (context, state) => const NotFoundScreen(),
      ),
    ],
  );
}

void main() {
  testWidgets('renders the not found message and actions', (tester) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: _router()));
    await tester.pumpAndSettle();

    expect(find.text('Tela não encontrada'), findsOneWidget);
    expect(
      find.text(
        'O caminho que você tentou acessar não existe '
        'ou foi movido temporariamente.',
      ),
      findsOneWidget,
    );
    expect(find.text('Voltar para o Início'), findsOneWidget);
    expect(find.text('Voltar'), findsOneWidget);
  });

  testWidgets('tapping "Voltar para o Início" navigates home', (
    tester,
  ) async {
    await tester.pumpWidget(MaterialApp.router(routerConfig: _router()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Voltar para o Início'));
    await tester.pumpAndSettle();

    expect(find.text('home screen'), findsOneWidget);
    expect(find.text('Tela não encontrada'), findsNothing);
  });

  testWidgets('tapping "Voltar" pops back to the previous screen', (
    tester,
  ) async {
    final router = _router();
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    router.go('/home');
    await tester.pumpAndSettle();

    _pushMissing(router);
    await tester.pumpAndSettle();

    expect(find.text('Tela não encontrada'), findsOneWidget);

    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();

    expect(find.text('home screen'), findsOneWidget);
    expect(find.text('Tela não encontrada'), findsNothing);
  });
}
