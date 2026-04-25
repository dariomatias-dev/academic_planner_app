import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:academic_planner/src/core/logging/logger_service.dart';

import 'package:academic_planner/src/shared/widgets/link_opening_failure_dialog_widget.dart';

Future<void> openUrl(
  BuildContext context,
  String url, {
  required LoggerService logger,
}) async {
  try {
    final uri = Uri.parse(url);

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched) {
      logger.warning('openUrl: Could not open link $uri');

      if (context.mounted) {
        LinkOpeningFailureDialogWidget.show(context);
      }
    }
  } catch (err, stackTrace) {
    logger.error(
      'openUrl: Unexpected error while opening link',
      error: err,
      stackTrace: stackTrace,
    );

    if (context.mounted) {
      LinkOpeningFailureDialogWidget.show(context);
    }
  }
}