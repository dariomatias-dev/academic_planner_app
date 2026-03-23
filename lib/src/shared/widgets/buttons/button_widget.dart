import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class ButtonStyles {
  final Color backgroundColor;
  final Color textColor;
  final Color? borderColor;
  final double elevation;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  const ButtonStyles({
    required this.backgroundColor,
    required this.textColor,
    this.borderColor,
    this.elevation = 0.0,
    this.iconColor,
    this.iconBackgroundColor,
  });

  static const primary = ButtonStyles(
    backgroundColor: AppColors.primary,
    textColor: AppColors.white,
    iconColor: AppColors.white,
  );

  static final secondary = ButtonStyles(
    backgroundColor: AppColors.primary.withAlpha(25),
    textColor: AppColors.primary,
    iconColor: AppColors.primary,
  );

  static const neutral = ButtonStyles(
    backgroundColor: AppColors.bg,
    textColor: AppColors.textMain,
    borderColor: AppColors.borderMedium,
  );

  static const outline = ButtonStyles(
    backgroundColor: Colors.transparent,
    textColor: AppColors.primary,
    borderColor: AppColors.primary,
  );

  static const destructive = ButtonStyles(
    backgroundColor: Color(0xFFFEE2E2),
    textColor: Color(0xFFDC2626),
    iconColor: Color(0xFFDC2626),
    iconBackgroundColor: Color(0xFFFECACA),
  );

  static const destructiveSolid = ButtonStyles(
    backgroundColor: Color(0xFFDC2626),
    textColor: AppColors.white,
    iconColor: AppColors.white,
  );
}

class ButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final ButtonStyles style;
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
    this.style = ButtonStyles.primary,
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
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style:
            ElevatedButton.styleFrom(
              backgroundColor: style.backgroundColor,
              foregroundColor: style.textColor,
              elevation: style.elevation,
              shadowColor: style.backgroundColor.withAlpha(50),
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
              side: style.borderColor != null
                  ? BorderSide(color: style.borderColor!, width: 1.5)
                  : BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
                if (states.contains(WidgetState.pressed)) {
                  return style.textColor.withAlpha(20);
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
                  color: style.iconBackgroundColor ?? Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 20.0,
                  color: style.iconColor ?? style.textColor,
                ),
              ),
              const SizedBox(width: 12.0),
            ],
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: fontSize,
                fontWeight: fontWeight,
                color: style.textColor,
              ),
            ),
            if (trailingIcon != null) ...<Widget>[
              const Spacer(),
              Icon(
                trailingIcon,
                size: 20.0,
                color: style.iconColor ?? style.textColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
