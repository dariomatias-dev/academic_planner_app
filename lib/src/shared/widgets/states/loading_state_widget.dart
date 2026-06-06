import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingStateWidget extends StatelessWidget {
  final String message;
  final bool isCentered;

  const LoadingStateWidget({
    super.key,
    this.message = "Obtendo informações...",
    this.isCentered = true,
  });

  TextStyle _textStyle(
    BuildContext context, {
    double size = 14.0,
    Color? color,
    FontWeight weight = FontWeight.w600,
    double? spacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      color: color ?? Theme.of(context).colorScheme.onSurface,
      fontWeight: weight,
      letterSpacing: spacing,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final content = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 32.0),
      child: Column(
        mainAxisAlignment: isCentered
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 32.0,
            height: 32.0,
            child: CircularProgressIndicator(
              strokeWidth: 3.0,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            message,
            textAlign: TextAlign.center,
            style: _textStyle(
              context,
              size: 14.0,
              color: colorScheme.onSurface.withAlpha(180),
              weight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    return isCentered ? Center(child: content) : content;
  }
}
