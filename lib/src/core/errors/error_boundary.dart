import 'package:academic_planner/src/core/errors/error_reporter.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Wires the app's global error boundary: Flutter framework errors,
/// uncaught async/platform errors, and — in release builds only — what
/// renders in place of a widget that failed to build, instead of the
/// default red error screen (which stays in debug, where it's useful).
///
/// Every error still reaches [reporter], regardless of where it came from.
void configureErrorBoundary(ErrorReporter reporter) {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);

    reporter.report(
      details.exception,
      details.stack ?? StackTrace.current,
      reason: details.context?.toString(),
    );
  };

  PlatformDispatcher.instance.onError = (error, stackTrace) {
    reporter.report(error, stackTrace);

    return true;
  };

  if (kReleaseMode) {
    ErrorWidget.builder = (details) {
      return const Material(
        type: MaterialType.transparency,
        child: ErrorStateWidget(
          title: 'Ops! Algo deu errado',
          actionLabel: 'Tentar novamente',
          description: 'Algo deu errado. Tente reiniciar o aplicativo.',
        ),
      );
    };
  }
}
