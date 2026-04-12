import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:academic_planner/src/core/routes/app_router.dart';
import 'package:academic_planner/src/core/theme/app_theme.dart';
import 'package:academic_planner/src/core/theme/theme_notifier.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.read<ThemeNotifier>();

    return ListenableBuilder(
      listenable: themeNotifier,
      builder: (context, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Academic Planner',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            FlutterQuillLocalizations.delegate,
          ],
          themeMode: themeNotifier.themeMode,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
