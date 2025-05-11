import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/svg_extensions.dart';

import '/core/utils/constants/extensions.dart';
import '../../../presentation/controllers/share_controller.dart';
import '../../services/services_locator.dart';
import '../../utils/constants/svg_constants.dart';
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
  // shareToImage.changeTafseer(context, verseUQNumber);

  Get.bottomSheet(
    Container(
      height: context.customOrientation(MediaQuery.sizeOf(context).height * .7,
          MediaQuery.sizeOf(context).height),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
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
                              .withValues(alpha: .5),
                          color2: Theme.of(context).colorScheme.surface),
                      context.customSvg(SvgPath.svgSharing, width: 20.0),
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
                          color: const Color(0xFFC39B7B).withValues(alpha: .3),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Icon(
                              Icons.text_fields,
                              color: Color(0xFF77554C),
                              size: 24,
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    firstPoem!,
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontSize: 16,
                                        fontFamily: 'naskh'),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.justify,
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '$secondPoem',
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        fontSize: 16,
                                        fontFamily: 'naskh'),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.justify,
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      shareToImage.shareText(bookName, chapterTitle, pageText,
                          firstPoem, secondPoem!, pageNumber);
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
                                  color: const Color(0xFFC39B7B)
                                      .withValues(alpha: .3),
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
