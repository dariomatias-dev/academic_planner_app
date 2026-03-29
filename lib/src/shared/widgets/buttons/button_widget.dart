import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

enum AppButtonStyle {
  primary,
  secondary,
  neutral,
  outline,
  destructive,
  destructiveSolid,
}

class ButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final AppButtonStyle style;
  final bool isFullWidth;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment mainAxisAlignment;

  const ButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.trailingIcon,
    this.style = AppButtonStyle.primary,
    this.isFullWidth = false,
    this.height = 56.0,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.w700,
    this.borderRadius = 24.0,
    this.padding,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    late Color backgroundColor;
    late Color textColor;
    Color? borderColor;
    Color? iconBackgroundColor;

    switch (style) {
      case AppButtonStyle.primary:
        backgroundColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        break;
      case AppButtonStyle.secondary:
        backgroundColor = colorScheme.primary.withAlpha(25);
        textColor = colorScheme.primary;
        break;
      case AppButtonStyle.neutral:
        backgroundColor = theme.scaffoldBackgroundColor;
        textColor = colorScheme.onSurface;
        borderColor = theme.dividerTheme.color;
        break;
      case AppButtonStyle.outline:
        backgroundColor = AppColors.transparent;
        textColor = colorScheme.primary;
        borderColor = colorScheme.primary;
        break;
      case AppButtonStyle.destructive:
        backgroundColor = colorScheme.errorContainer;
        textColor = colorScheme.error;
        iconBackgroundColor = colorScheme.error.withAlpha(40);
        break;
      case AppButtonStyle.destructiveSolid:
        backgroundColor = colorScheme.error;
        textColor = colorScheme.onError;
        break;
    }

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style:
            ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: textColor,
              elevation: 0.0,
              shadowColor: backgroundColor.withAlpha(50),
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
              side: borderColor != null
                  ? BorderSide(color: borderColor, width: 1.5)
                  : BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.pressed)) {
                  return textColor.withAlpha(20);
                }
                return null;
              }),
            ),
        child: Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: mainAxisAlignment,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: iconBackgroundColor ?? AppColors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20.0, color: textColor),
              ),
              const SizedBox(width: 12.0),
            ],
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: textColor,
              ),
            ),
            if (trailingIcon != null) ...<Widget>[
              const Spacer(),
              Icon(trailingIcon, size: 20.0, color: textColor),
            ],
          ],
        ),
      ),
    );
  }
}
