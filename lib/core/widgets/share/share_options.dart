import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syntactic/core/utils/constants/svg_picture.dart';

import '../../../presentation/controllers/books_controller.dart';
import '../../../presentation/controllers/share_controller.dart';
import '../../services/services_locator.dart';
import '../widgets.dart';
import 'create_image.dart';

Future<void> showShareOptionsBottomSheet(
  BuildContext context, {
  required String bookName,
  required String chapterTitle,
  String? firstPoem,
  String? secondPoem,
  required String pageText,
  required int pageNumber,
}) async {
  final shareToImage = sl<ShareController>();
  final bookCtrl = sl<BooksController>();
  // shareToImage.changeTafseer(context, verseUQNumber);

  Get.bottomSheet(
    Container(
      height: orientation(context, MediaQuery.sizeOf(context).height * .7,
          MediaQuery.sizeOf(context).height),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      customClose(context,
                          close: () => Get.back(),
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withOpacity(.5),
                          color2: Theme.of(context).colorScheme.surface),
                      sharing(context, width: 50.0),
                    ],
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'shareText'.tr,
                      style: TextStyle(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 16,
                          fontFamily: 'kufi'),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      // height: 60,
                      width: MediaQuery.sizeOf(context).width,
                      padding: const EdgeInsets.all(16.0),
                      margin: const EdgeInsets.only(
                          top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
                      decoration: BoxDecoration(
                          color: const Color(0xFFC39B7B).withOpacity(.3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Icon(
                            Icons.text_fields,
                            color: Color(0xFF77554C),
                            size: 24,
                          ),
                          SizedBox(
                            width: orientation(
                                context,
                                MediaQuery.sizeOf(context).width * .7,
                                MediaQuery.sizeOf(context).width / 1 / 3),
                            child: Text(
                              bookCtrl.loadPoemBooks
                                  ? '$firstPoem\n$secondPoem'
                                  : pageText,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorLight,
                                  fontSize: 16,
                                  fontFamily: 'naskh'),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      shareToImage.shareText(bookName, chapterTitle, pageText,
                          firstPoem!, secondPoem!, pageNumber);
                      Get.back();
                    },
                  ),
                  hDivider(context, width: MediaQuery.sizeOf(context).width),
                  Column(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'shareImage'.tr,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).primaryColorLight,
                                      fontSize: 16,
                                      fontFamily: 'kufi'),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            child: Container(
                              // width: MediaQuery.sizeOf(context).width * .4,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 8.0),
                              margin: const EdgeInsets.only(
                                  top: 4.0,
                                  bottom: 16.0,
                                  right: 16.0,
                                  left: 16.0),
                              decoration: BoxDecoration(
                                  color:
                                      const Color(0xFFC39B7B).withOpacity(.3),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(4))),
                              child: VerseImageCreator(
                                bookName: bookName,
                                chapterTitle: chapterTitle,
                                firstPoem: firstPoem,
                                secondPoem: secondPoem,
                                pageText: pageText,
                                pageNumber: pageNumber,
                              ),
                            ),
                            onTap: () async {
                              await sl<ShareController>()
                                  .createAndShowVerseImage();
                              shareToImage.shareVerse();
                              // shareVerse(
                              //     context, verseNumber, surahNumber, verseText);
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}
