import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

extension ShareAppExtension on void {
  Future<void> shareApp(BuildContext context) async {
    try {
      final ByteData bytes =
          await rootBundle.load('assets/images/nahawi_banner.png');
      final Uint8List list = bytes.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/nahawi_banner.png').create();
      await file.writeAsBytes(list);

      final box = context.findRenderObject() as RenderBox?;
      if (box == null) {
        debugPrint(
            'RenderBox is null, cannot determine share position origin.');
        return;
      }

      await Share.shareXFiles(
        [XFile(file.path)],
        text:
            'تطبيق "نحويّ : النحو العربي" تطبيق يحتوي على العديد من كتب النحو العربي.\n\nللتحميل:\nalheekmahlib.com/#/download/app/2',
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );
    } catch (e) {
      debugPrint('حدث خطأ أثناء مشاركة التطبيق: $e');
    }
  }
}
