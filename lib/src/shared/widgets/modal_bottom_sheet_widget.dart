import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class ModalBottomSheetWidget extends StatelessWidget {
  final String? title;
  final Widget child;

  const ModalBottomSheetWidget({super.key, this.title, required this.child});

  static Future<T?> show<T>({
    required BuildContext context,
    String? title,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppColors.transparent,
      isScrollControlled: true,
      builder: (context) => ModalBottomSheetWidget(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24.0, 16.0, 24.0, 24.0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.0)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 40.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: AppColors.borderMedium,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          if (title != null) ...<Widget>[
            const SizedBox(height: 24.0),
            Text(
              title!,
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textMain,
                fontSize: 18.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
          const SizedBox(height: 20.0),
          Flexible(child: child),
        ],
      ),
    );
  }
}
