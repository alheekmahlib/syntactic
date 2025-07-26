import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/custom_error_snack_bar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareController extends GetxController {
  final ScreenshotController ayahScreenController = ScreenshotController();
  final ScreenshotController tafseerScreenController = ScreenshotController();
  Uint8List? ayahToImageBytes;
  RxString? translateName;
  RxString currentTranslate = 'Nothing'.obs;
  RxString? textTafseer;
  RxBool isTranslate = false.obs;
  RxInt shareTransValue = 0.obs;
  RxString trans = 'en'.obs;
  // إضافة متغيرات للتحكم في قوائم الاختيار
  RxInt fromPoemIndex = 0.obs;
  RxInt toPoemIndex = 0.obs;

  // حساب العدد الإجمالي للأبيات المتوفرة
  int? poemsCount;

  Future<void> createAndShowVerseImage() async {
    try {
      final Uint8List? imageBytes = await ayahScreenController.capture();
      ayahToImageBytes = imageBytes;
      update();
    } catch (e) {
      log('Error capturing verse image: $e');
    }
  }

  shareText(String bookName, String chapterTitle, String pageText,
      String firstPoem, String secondPoem, int pageNumber) {
    // دالة مشاركة النص - تدعم مشاركة بيت واحد أو مجموعة من الأبيات
    // Share text function - supports sharing a single verse or multiple verses

    // إنشاء نص المشاركة - تجنب تكرار البيت الأول
    String shareContent = '$bookName\n$chapterTitle\n\n';

    // إذا كان هناك نص في الوسيط الأول، نستخدمه (حالة البيت الواحد)
    if (firstPoem.isNotEmpty) {
      shareContent += '$firstPoem\n$secondPoem\n';
    } else {
      // وإلا نستخدم فقط الوسيط الثاني الذي يحتوي على جميع الأبيات
      shareContent += secondPoem;
    }

    SharePlus.instance
        .share(ShareParams(text: shareContent, subject: bookName));
  }

  Future<void> shareVerse() async {
    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/verse_image.png').create();
    await imagePath.writeAsBytes(ayahToImageBytes!);
    await SharePlus.instance.share(
        ShareParams(files: [XFile((imagePath.path))], text: 'appName'.tr));
  }

  /// نسخ النص إلى الحافظة
  /// Copy text to clipboard
  Future<void> copyText(String bookName, String chapterTitle, String pageText,
      String firstPoem, String secondPoem, int pageNumber) async {
    // إنشاء نص للنسخ - تنسيق مشابه لمشاركة النص
    // Create text for copying - similar format to text sharing
    String copyContent = '$bookName\n$chapterTitle\n\n';

    // إذا كان هناك نص في الوسيط الأول، نستخدمه (حالة البيت الواحد)
    if (firstPoem.isNotEmpty) {
      copyContent += '$firstPoem\n$secondPoem\n';
    } else {
      // وإلا نستخدم فقط الوسيط الثاني الذي يحتوي على جميع الأبيات
      copyContent += secondPoem;
    }

    await Clipboard.setData(ClipboardData(text: copyContent)).then((value) =>
        Get.context!.showCustomErrorSnackBar('copied'.tr, isDone: true));
  }
}
