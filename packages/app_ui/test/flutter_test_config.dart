import 'dart:async';
import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Loads the bundled typeface under the name the components request, and the
/// Material icon font from the Flutter SDK, so goldens render real glyphs
/// instead of the test font's blocks.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final loader = FontLoader(
    'packages/${AppTypography.package}/${AppTypography.fontFamily}',
  );
  for (final weight in [400, 500, 600, 700, 800]) {
    loader.addFont(rootBundle.load('assets/fonts/PlusJakartaSans-$weight.ttf'));
  }
  await loader.load();

  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  final iconFont = File(
    '$flutterRoot/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  if (flutterRoot != null && iconFont.existsSync()) {
    await (FontLoader('MaterialIcons')..addFont(
          Future.value(ByteData.sublistView(iconFont.readAsBytesSync())),
        ))
        .load();
  }

  await testMain();
}
