import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
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
    // final bookCtrl = AllBooksController.instance;
    Share.share(
        '$bookName\n'
        '$chapterTitle\n\n'
        '${'$firstPoem\n$secondPoem\n'}\n'
        '',
        subject: bookName);
  }

  Future<void> shareVerse() async {
    final directory = await getTemporaryDirectory();
    final imagePath = await File('${directory.path}/verse_image.png').create();
    await imagePath.writeAsBytes(ayahToImageBytes!);
    await Share.shareXFiles([XFile((imagePath.path))], text: 'appName'.tr);
  }
}
