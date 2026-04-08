import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart';

import 'package:academic_planner/src/shared/widgets/link_opening_failure_dialog_widget.dart';

final _logger = Logger();

Future<void> openUrl(BuildContext context, String url) async {
  try {
    final uri = Uri.parse(url);

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched) {
      _logger.w('openUrl: Could not open link $uri');

      if (context.mounted) {
        LinkOpeningFailureDialogWidget.show(context);
      }
    }
  } catch (err, stackTrace) {
    _logger.e(
      'openUrl: Unexpected error while opening link',
      error: err,
      stackTrace: stackTrace,
    );

    if (context.mounted) {
      LinkOpeningFailureDialogWidget.show(context);
    }
  }
}
