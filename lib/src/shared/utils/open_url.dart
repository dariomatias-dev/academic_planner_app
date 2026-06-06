import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:academic_planner/src/shared/widgets/link_opening_failure_dialog_widget.dart';

final _log = Logger('shared.openUrl');

Future<void> openUrl(
  BuildContext context,
  String url,
) async {
  try {
    final uri = Uri.parse(url);

    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched) {
      _log.warning('openUrl: Could not open link $uri');

      if (context.mounted) {
        LinkOpeningFailureDialogWidget.show(context);
      }
    }
  } catch (err, stackTrace) {
    _log.severe('openUrl: Unexpected error while opening link', err, stackTrace);

    if (context.mounted) {
      LinkOpeningFailureDialogWidget.show(context);
    }
  }
}
