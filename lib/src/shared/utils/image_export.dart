import 'package:academic_planner/src/core/services/image_export_service.dart';
import 'package:academic_planner/src/shared/widgets/buttons/button/button_widget.dart';
import 'package:academic_planner/src/shared/widgets/dialogs/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';

class ImageExport {
  static final _log = Logger('shared.ImageExport');

  static Future<void> captureAndSave({
    required BuildContext context,
    required GlobalKey containerKey,
    required String fileName,
  }) async {
    if (!context.mounted) return;

    await _showLoadingToast();

    try {
      await Future<void>.delayed(const Duration(milliseconds: 200));

      final bytes = await ImageExportService.capture(containerKey);
      final success = await ImageExportService.save(bytes, fileName);

      if (!context.mounted) return;

      if (success) {
        await _showSuccessToast();

        _log.info('Image saved successfully: $fileName');
      } else {
        throw Exception('Gallery save returned an error.');
      }
    } on Exception catch (err, stackTrace) {
      _log.severe('Error exporting image', err, stackTrace);

      if (!context.mounted) return;

      await _showErrorDialog(context);
    }
  }

  static Future<void> _showLoadingToast() async {
    await Fluttertoast.showToast(
      msg: 'Gerando arquivo...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Future<void> _showSuccessToast() async {
    await Fluttertoast.showToast(
      msg: 'Imagem salva com sucesso!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  static Future<void> _showErrorDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return DialogWidget(
          title: 'Erro na exportação',
          message: 'Não foi possível salvar a imagem. Tente novamente.',
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
