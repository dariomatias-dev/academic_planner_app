import 'dart:async';

import 'package:academic_planner/src/core/routes/app_routes.dart';
import 'package:academic_planner/src/features/auth/di/auth_providers.dart';
import 'package:academic_planner/src/features/categories/di/category_providers.dart';
import 'package:academic_planner/src/features/tags/di/tag_providers.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/error_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  double _opacity = 0.0;
  double _scale = 0.8;
  double _yOffset = 20.0;

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
          _scale = 1.0;
          _yOffset = 0.0;
        });
      }
    });
  }

  Future<void> _initializeResources() async {
    await _loadAppData();

    if (mounted) {
      AppRoutes.goToHome(context);
    }
  }

  Future<void> _loadAppData() async {
    try {
      await Future.wait([
        ref.read(authNotifierProvider.future),
        ref.read(userNotifierProvider.future),
        ref.read(categoryNotifierProvider.future),
        ref.read(tagNotifierProvider.future),
        GoogleFonts.pendingFonts([
          GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w500),
          GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600),
          GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
          GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800),
          GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900),
        ]),
      ]);
    } on Exception {
      if (mounted) {
        await ErrorDialogWidget.show(
          context,
          message:
              'Não foi possível sincronizar seus dados. '
              'Verifique sua conexão e tente novamente.',
          onClose: _initializeResources,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    _startAnimation();
    unawaited(_initializeResources());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: -50.0,
            left: -50.0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              opacity: _opacity * 0.15,
              child: Container(
                width: 250.0,
                height: 250.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withAlpha(0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100.0,
            right: -80.0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 2000),
              opacity: _opacity * 0.1,
              child: Container(
                width: 300.0,
                height: 300.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colorScheme.primary,
                      colorScheme.primary.withAlpha(0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 1400),
                  scale: _scale,
                  curve: Curves.elasticOut,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: _opacity,
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(30.0),
                        border: Border.all(
                          color: colorScheme.primary.withAlpha(40),
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.auto_stories_rounded,
                        size: 48.0,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 48.0),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutQuart,
                  transform: Matrix4.translationValues(0.0, _yOffset, 0.0),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 1000),
                    opacity: _opacity,
                    child: Column(
                      children: [
                        Text(
                          'ACADEMIC',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w800,
                            color: colorScheme.primary,
                            letterSpacing: 10.0,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          'Planner',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 46.0,
                            fontWeight: FontWeight.w900,
                            color: colorScheme.onSurface,
                            letterSpacing: -2.0,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 1.5,
                              width: 20.0,
                              color: colorScheme.primary.withAlpha(80),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                              ),
                              child: Icon(
                                Icons.circle,
                                size: 6.0,
                                color: colorScheme.primary,
                              ),
                            ),
                            Container(
                              height: 1.5,
                              width: 20.0,
                              color: colorScheme.primary.withAlpha(80),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 60.0,
            left: 48.0,
            right: 48.0,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 1200),
              opacity: _opacity,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: LinearProgressIndicator(
                      minHeight: 3.0,
                      backgroundColor: colorScheme.onSurface.withAlpha(15),
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Sincronizando seus dados...',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface.withAlpha(100),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
