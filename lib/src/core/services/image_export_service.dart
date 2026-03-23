import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';

class ImageExportService {
  static Future<Uint8List> capture(GlobalKey key) async {
    final boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) {
      throw Exception("Falha ao localizar o componente para captura.");
    }

    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData == null) {
      throw Exception("Falha ao processar dados da imagem.");
    }

    return byteData.buffer.asUint8List();
  }

  static Future<bool> save(Uint8List bytes, String fileName) async {
    final result = await ImageGallerySaverPlus.saveImage(
      bytes,
      quality: 100,
      name: fileName,
    );

    return result != null && result['isSuccess'] == true;
  }
}
