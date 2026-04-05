import 'dart:async';
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

class ButtonWidget extends StatefulWidget {
  final String label;
  final FutureOr<void> Function()? onPressed;
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
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool _isLoading = false;

  Future<void> _handlePressed() async {
    if (widget.onPressed == null || _isLoading) return;

    setState(() => _isLoading = true);

    try {
      await widget.onPressed!();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    late Color backgroundColor;
    late Color textColor;
    Color? borderColor;
    Color? iconBackgroundColor;

    switch (widget.style) {
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

    final isButtonDisabled = widget.onPressed == null || _isLoading;
    final effectiveBackgroundColor = _isLoading
        ? backgroundColor.withAlpha(180)
        : backgroundColor;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: widget.isFullWidth ? double.infinity : null,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: widget.style == AppButtonStyle.primary && !_isLoading
            ? [
                BoxShadow(
                  color: backgroundColor.withAlpha(40),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isButtonDisabled ? null : _handlePressed,
        style:
            ElevatedButton.styleFrom(
              backgroundColor: effectiveBackgroundColor,
              foregroundColor: textColor,
              disabledBackgroundColor: backgroundColor.withAlpha(150),
              disabledForegroundColor: textColor.withAlpha(150),
              elevation: 0.0,
              padding:
                  widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 24.0),
              side: borderColor != null
                  ? BorderSide(
                      color: _isLoading
                          ? borderColor.withAlpha(100)
                          : borderColor,
                      width: 1.5,
                    )
                  : BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.pressed)) {
                  return textColor.withAlpha(25);
                }
                return null;
              }),
            ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            );
          },
          child: _isLoading
              ? SizedBox(
                  key: const ValueKey('loading'),
                  height: 24.0,
                  width: 24.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    strokeCap: StrokeCap.round,
                    valueColor: AlwaysStoppedAnimation<Color>(textColor),
                  ),
                )
              : Row(
                  key: const ValueKey('content'),
                  mainAxisSize: widget.isFullWidth
                      ? MainAxisSize.max
                      : MainAxisSize.min,
                  mainAxisAlignment: widget.mainAxisAlignment,
                  children: <Widget>[
                    if (widget.icon != null) ...<Widget>[
                      Container(
                        padding: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          color: iconBackgroundColor ?? AppColors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(widget.icon, size: 18.0, color: textColor),
                      ),
                      const SizedBox(width: 8.0),
                    ],
                    Text(
                      widget.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: widget.fontSize,
                        fontWeight: widget.fontWeight,
                        color: textColor,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (widget.trailingIcon != null) ...<Widget>[
                      const Spacer(),
                      Icon(widget.trailingIcon, size: 18.0, color: textColor),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
