import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

import 'package:academic_planner/src/core/services/image_export_service.dart';

import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';

class ImageExport {
  static final _logger = Logger();

  static Future<void> captureAndSave({
    required BuildContext context,
    required GlobalKey containerKey,
    required String fileName,
  }) async {
    if (!context.mounted) return;

    _showLoadingToast();

    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));

      final bytes = await ImageExportService.capture(containerKey);
      final success = await ImageExportService.save(bytes, fileName);

      if (!context.mounted) return;

      if (success) {
        _showSuccessToast();

        _logger.i("Image saved successfully: $fileName");
      } else {
        throw Exception("Gallery save returned an error.");
      }
    } catch (err, stackTrace) {
      _logger.e("Error exporting image", error: err, stackTrace: stackTrace);

      if (!context.mounted) return;

      _showErrorDialog(context);
    }
  }

  static void _showLoadingToast() {
    Fluttertoast.showToast(
      msg: "Gerando arquivo...",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static void _showSuccessToast() {
    Fluttertoast.showToast(
      msg: "Imagem salva com sucesso!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogWidget(
          title: "Erro na exportação",
          message: "Não foi possível salvar a imagem. Tente novamente.",
          icon: Icons.error_outline_rounded,
          actions: ButtonWidget(
            onPressed: () {
              Navigator.pop(context);
            },
            label: 'Ok',
            isFullWidth: true,
          ),
        );
      },
    );
  }
}
