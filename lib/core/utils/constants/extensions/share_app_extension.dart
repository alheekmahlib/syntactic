import 'dart:developer' show log;
import 'dart:io' show File;

import 'package:flutter/material.dart' show RenderBox, BuildContext;
import 'package:flutter/services.dart'
    show rootBundle, ByteData, Uint8List, Offset;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:share_plus/share_plus.dart';

extension ShareAppExtension on void {
  Future<void> shareApp(BuildContext context) async {
    try {
      // تحميل صورة البانر وتحويلها إلى Uint8List - Load banner image and convert to Uint8List
      final ByteData bytes =
          await rootBundle.load('assets/images/nahawi_banner.png');
      final Uint8List list = bytes.buffer.asUint8List();

      // إنشاء ملف مؤقت لحفظ الصورة - Create temporary file to save the image
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/nahawi_banner.png').create();
      await file.writeAsBytes(list);

      // التأكد من وجود الملف - Ensure file exists
      if (!await file.exists()) {
        log('فشل في إنشاء ملف الصورة المؤقت', name: 'ShareAppExtension');
        return;
      }

      // الحصول على معلومات موقع المشاركة - Get share position information
      final box = context.findRenderObject() as RenderBox?;
      if (box == null) {
        log('RenderBox is null, cannot determine share position origin.',
            name: 'ShareAppExtension');
        return;
      }

      // نص وصورة للمشاركة - Text and image for sharing
      final shareText =
          'تطبيق "نحويّ : النحو العربي" تطبيق يحتوي على العديد من كتب النحو العربي.\n\nللتحميل:\nalheekmahlib.com/#/download/app/2';
      final xFile = XFile(file.path);

      log('محاولة مشاركة الملف: ${file.path}', name: 'ShareAppExtension');
      log('هل الملف موجود: ${await file.exists()}', name: 'ShareAppExtension');

      // إعداد معلمات المشاركة - Setup share parameters
      final params = ShareParams(
        text: shareText,
        files: [xFile],
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
      );

      // مشاركة المحتوى - Share content
      await SharePlus.instance.share(params);
    } catch (e) {
      log('حدث خطأ أثناء مشاركة التطبيق: $e', name: 'ShareAppExtension');

      // محاولة بديلة للمشاركة - Alternative sharing attempt
      try {
        // مشاركة النص فقط إذا فشلت مشاركة الصورة - Share only text if image sharing fails
        await SharePlus.instance.share(ShareParams(
          text:
              'تطبيق "نحويّ : النحو العربي" تطبيق يحتوي على العديد من كتب النحو العربي.\n\nللتحميل:\nalheekmahlib.com/#/download/app/2',
          subject: 'مشاركة تطبيق نحويّ',
        ));
      } catch (e2) {
        log('فشلت محاولة المشاركة البديلة: $e2', name: 'ShareAppExtension');
      }
    }
  }
}
