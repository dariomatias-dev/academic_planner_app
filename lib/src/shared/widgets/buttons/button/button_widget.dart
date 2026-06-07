import 'dart:async';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button/button_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppButtonStyle {
  primary,
  secondary,
  neutral,
  outline,
  destructive,
  destructiveSolid,
}

class ButtonWidget extends StatefulWidget {
  const ButtonWidget({
    required this.label,
    required this.onPressed,
    super.key,
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
    final colors = AppButtonStyles.fromStyle(widget.style, theme);

    final isButtonDisabled = widget.onPressed == null || _isLoading;
    final effectiveBackgroundColor = _isLoading
        ? colors.backgroundColor.withAlpha(180)
        : colors.backgroundColor;

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
                  color: colors.backgroundColor.withAlpha(40),
                  blurRadius: 12.0,
                  offset: const Offset(0.0, 4.0),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isButtonDisabled ? null : _handlePressed,
        style:
            ElevatedButton.styleFrom(
              backgroundColor: effectiveBackgroundColor,
              foregroundColor: colors.textColor,
              disabledBackgroundColor: colors.backgroundColor.withAlpha(150),
              disabledForegroundColor: colors.textColor.withAlpha(150),
              elevation: 0.0,
              padding:
                  widget.padding ??
                  const EdgeInsets.symmetric(horizontal: 24.0),
              side: colors.borderColor != null
                  ? BorderSide(
                      color: _isLoading
                          ? colors.borderColor!.withAlpha(100)
                          : colors.borderColor!,
                      width: 1.5,
                    )
                  : BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.pressed)) {
                  return colors.textColor.withAlpha(25);
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
              ? _ButtonLoadingIndicator(color: colors.textColor)
              : _ButtonContent(
                  label: widget.label,
                  icon: widget.icon,
                  trailingIcon: widget.trailingIcon,
                  textColor: colors.textColor,
                  iconBackgroundColor: colors.iconBackgroundColor,
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,
                  isFullWidth: widget.isFullWidth,
                  mainAxisAlignment: widget.mainAxisAlignment,
                ),
        ),
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.trailingIcon,
    required this.textColor,
    required this.fontSize,
    required this.fontWeight,
    required this.isFullWidth,
    required this.mainAxisAlignment,
    this.iconBackgroundColor,
  });

  final String label;
  final IconData? icon;
  final IconData? trailingIcon;
  final Color textColor;
  final Color? iconBackgroundColor;
  final double fontSize;
  final FontWeight fontWeight;
  final bool isFullWidth;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const ValueKey('content'),
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: iconBackgroundColor ?? AppColors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.0, color: textColor),
          ),
          const SizedBox(width: 8.0),
        ],
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
            letterSpacing: -0.2,
          ),
        ),
        if (trailingIcon != null) ...[
          const Spacer(),
          Icon(trailingIcon, size: 18.0, color: textColor),
        ],
      ],
    );
  }
}

class _ButtonLoadingIndicator extends StatelessWidget {
  const _ButtonLoadingIndicator({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey('loading'),
      height: 24.0,
      width: 24.0,
      child: CircularProgressIndicator(
        strokeWidth: 3.0,
        strokeCap: StrokeCap.round,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}
