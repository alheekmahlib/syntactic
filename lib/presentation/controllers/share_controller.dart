import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareController extends GetxController {
  final ScreenshotController hadithScreenController = ScreenshotController();
  final ScreenshotController translateScreenController = ScreenshotController();
  Uint8List? hadithToImageBytes;
  Uint8List? translateToImageBytes;
  RxString? translateName;
  RxString currentTranslate = 'Nothing'.obs;
  RxString? textTafseer;
  RxBool isTranslate = false.obs;
  RxInt shareTransValue = 0.obs;
  RxString trans = 'en'.obs;

  Future<void> createAndShowHadithImage() async {
    try {
      final Uint8List? imageBytes = await hadithScreenController.capture();
      hadithToImageBytes = imageBytes;
      update();
    } catch (e) {
      debugPrint('Error capturing hadith image: $e');
    }
  }

  Future<void> createAndShowTafseerImage() async {
    try {
      final Uint8List? imageBytes = await translateScreenController.capture();
      translateToImageBytes = imageBytes;
      update();
    } catch (e) {
      debugPrint('Error capturing hadith image: $e');
    }
  }

  shareText(String hadithText, hadithName, int hadithNumber) {
    Share.share(
        '﴿$hadithText﴾ '
        '[$hadithName-'
        '$hadithNumber]',
        subject: '$hadithName');
  }

  Future<void> shareHadithWithTranslate() async {
    /// FIXME: can't be null!
    if (translateToImageBytes! != null) {
      final directory = await getTemporaryDirectory();
      final imagePath =
          await File('${directory.path}/hadith_tafseer_image.png').create();
      await imagePath.writeAsBytes(translateToImageBytes!);
      await Share.shareXFiles([XFile((imagePath.path))], text: 'appName'.tr);
    }
  }

  Future<void> shareVerse(BuildContext context) async {
    /// FIXME: can't be null!
    if (hadithToImageBytes! != null) {
      final directory = await getTemporaryDirectory();
      final imagePath =
          await File('${directory.path}/hadith_image.png').create();
      await imagePath.writeAsBytes(hadithToImageBytes!);
      await Share.shareXFiles([XFile((imagePath.path))], text: 'appName'.tr);
    }
  }
}
