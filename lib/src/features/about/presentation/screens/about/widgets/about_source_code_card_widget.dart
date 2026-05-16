import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:academic_planner/src/core/logging/logger_provider.dart';

import 'package:academic_planner/src/shared/utils/open_url.dart';

const _repoUrl = 'https://github.com/dariomatias-dev/academic_planner_app';

class AboutSourceCodeCardWidget extends ConsumerStatefulWidget {
  const AboutSourceCodeCardWidget({super.key});

  @override
  ConsumerState<AboutSourceCodeCardWidget> createState() =>
      _SourceCodeCardWidgetState();
}

class _SourceCodeCardWidgetState extends ConsumerState<AboutSourceCodeCardWidget> {
  bool _copied = false;
  Timer? _resetTimer;

  void _copyLink() {
    Clipboard.setData(const ClipboardData(text: _repoUrl));
    Fluttertoast.showToast(msg: 'Link copiado');

    setState(() => _copied = true);

    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w500,
  }) {
    return GoogleFonts.plusJakartaSans(
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontSize: size,
      fontWeight: weight,
    );
  }

  @override
  void dispose() {
    _resetTimer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.transparent,
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 12.0, 20.0),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Icon(
                    Icons.code_rounded,
                    color: colorScheme.primary,
                    size: 24.0,
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Código-fonte",
                        style: _textStyle(
                          context,
                          size: 15.0,
                          weight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3.0),
                      Text(
                        "Projeto open source no GitHub",
                        style: _textStyle(
                          context,
                          size: 12.0,
                          color: colorScheme.onSurface.withAlpha(120),
                          weight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: IconButton(
                    key: ValueKey<bool>(_copied),
                    icon: Icon(
                      _copied ? Icons.check_rounded : Icons.copy_rounded,
                      color: _copied
                          ? colorScheme.primary
                          : colorScheme.onSurface.withAlpha(100),
                      size: 20.0,
                    ),
                    onPressed: _copyLink,
                    tooltip: _copied ? "Copiado!" : "Copiar link",
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1.0, color: theme.dividerTheme.color),
          InkWell(
            onTap: () {
              openUrl(context, _repoUrl, logger: ref.read(loggerProvider));
            },
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(24.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 14.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.open_in_new_rounded,
                    color: colorScheme.primary,
                    size: 16.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    "Abrir no GitHub",
                    style: _textStyle(
                      context,
                      size: 13.0,
                      color: colorScheme.primary,
                      weight: FontWeight.w700,
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
