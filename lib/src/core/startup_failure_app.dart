import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// Shown in place of the app when startup fails (Firebase or the local
/// database couldn't be reached), instead of a blank or crashed screen.
/// [onRetry] re-runs the bootstrap sequence.
class StartupFailureApp extends StatelessWidget {
  const StartupFailureApp({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: ErrorStateWidget(
            actionLabel: 'Tentar novamente',
            title: 'Não foi possível iniciar o app',
            description:
                'Ocorreu um erro ao carregar os dados do aplicativo. '
                'Verifique sua conexão e tente novamente.',
            onActionPressed: onRetry,
          ),
        ),
      ),
    );
  }
}
