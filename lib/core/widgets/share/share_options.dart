import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/convert_number_extension.dart';
import 'package:nahawi/core/utils/constants/extensions/extensions.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../presentation/controllers/share_controller.dart';
import '../../../presentation/screens/all_books/data/models/poem_model.dart';
import '../../services/services_locator.dart';
import '../../utils/constants/svg_constants.dart';
import '../widgets.dart';
import 'create_image.dart';

/// ShareOptionsService - خدمة مسؤولة عن خيارات المشاركة
/// ShareOptionsService - Service responsible for share options
class ShareOptionsService {
  /// تنسيق الأبيات المختارة كنص
  /// Format selected poems as text
  static String formatSelectedPoems(
      List<Poem> poemsList, int fromIndex, int toIndex) {
    String selectedPoems = '';
    for (int i = fromIndex; i <= toIndex; i++) {
      selectedPoems +=
          '${poemsList[i].firstPoem}\n${poemsList[i].secondPoem}\n';
      if (i < toIndex) {
        selectedPoems += '\n';
      }
    }
    return selectedPoems;
  }

  /// تنسيق الأبيات المختارة للصورة
  /// Format selected poems for image
  static String formatPoemsForImage(
      List<Poem> poemsList, int fromIndex, int toIndex) {
    String poemsFormatted = '';

    for (int i = fromIndex; i <= toIndex; i++) {
      poemsFormatted += '${poemsList[i].firstPoem}\n${poemsList[i].secondPoem}';

      if (i < toIndex) {
        poemsFormatted += '\n\n';
      }
    }

    return poemsFormatted;
  }
}

/// تهيئة بيانات المشاركة
/// Initialize share data
void _initShareData(ShareController shareController, List<Poem>? poemsList) {
  shareController.poemsCount = poemsList?.length ?? 1;

  // ضبط القيمة الافتراضية لنهاية المدى
  // Set default value for range end
  if (shareController.poemsCount! > 0) {
    shareController.toPoemIndex.value = shareController.poemsCount! - 1;
  }
}

/// عرض خيارات المشاركة كـ Bottom Sheet
/// Display share options as Bottom Sheet
Future<void> showShareOptionsBottomSheet(
  BuildContext context, {
  required String bookName,
  required String chapterTitle,
  String? firstPoem,
  String? secondPoem,
  required String pageText,
  required int pageNumber,
  List<Poem>? poemsList, // إضافة قائمة الأبيات الشعرية
}) async {
  final shareToImage = sl<ShareController>();
  // shareToImage.changeTafseer(context, verseUQNumber);

  /// تهيئة بيانات المشاركة
  /// Initialize share data
  _initShareData(shareToImage, poemsList);

  Get.bottomSheet(
    Container(
      height: context.customOrientation(MediaQuery.sizeOf(context).height * .89,
          MediaQuery.sizeOf(context).height),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(context),
          Flexible(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 8.0),
              children: [
                // إضافة قسم اختيار مدى الأبيات
                if (poemsList != null && poemsList.length > 1)
                  _buildPoemRangeSelector(context, shareToImage, poemsList),

                _buildCopySection(
                  context: context,
                  shareController: shareToImage,
                  bookName: bookName,
                  chapterTitle: chapterTitle,
                  pageText: pageText,
                  pageNumber: pageNumber,
                  poemsList: poemsList,
                  firstPoem: firstPoem,
                  secondPoem: secondPoem,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Theme.of(context).primaryColor.withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                _buildTextShareSection(
                  context: context,
                  shareController: shareToImage,
                  bookName: bookName,
                  chapterTitle: chapterTitle,
                  pageText: pageText,
                  pageNumber: pageNumber,
                  poemsList: poemsList,
                  firstPoem: firstPoem,
                  secondPoem: secondPoem,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Theme.of(context).primaryColor.withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                _buildImageShareSection(
                  context: context,
                  shareController: shareToImage,
                  bookName: bookName,
                  chapterTitle: chapterTitle,
                  pageText: pageText,
                  pageNumber: pageNumber,
                  poemsList: poemsList,
                  firstPoem: firstPoem,
                  secondPoem: secondPoem,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

/// بناء رأس الصفحة مع زر الإغلاق وأيقونة المشاركة
/// Build header with close button and share icon
Widget _buildHeader(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Theme.of(context).colorScheme.primaryContainer,
          Theme.of(context)
              .colorScheme
              .primaryContainer
              .withValues(alpha: 0.95),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          offset: const Offset(0, 3),
          blurRadius: 6,
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Material(
            borderRadius: BorderRadius.circular(30),
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: .3),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.close,
                  color: Theme.of(context).primaryColorLight,
                  size: 20,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                'shareOptions'.tr,
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 18,
                  fontFamily: 'kufi',
                  fontWeight: FontWeight.bold,
                  height: 1.7,
                ),
              ),
              const Gap(12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: .2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: context.customSvg(SvgPath.svgSharing, width: 20.0),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

/// بناء منتقي مدى الأبيات (من-إلى)
/// Build poem range selector (from-to)
Widget _buildPoemRangeSelector(BuildContext context,
    ShareController shareController, List<Poem> poemsList) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                width: 2.0,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.format_quote_rounded,
                color:
                    Theme.of(context).primaryColorLight.withValues(alpha: 0.7),
                size: 20,
              ),
              const Gap(8),
              Text(
                'choicePoems'.tr,
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'kufi',
                ),
              ),
            ],
          ),
        ),
        const Gap(12),
        Row(
          children: [
            // اختيار البيت الأول (من) - Select first poem (from)
            Expanded(
              child: _buildPoemDropdown(
                context: context,
                shareController: shareController,
                isFromSelector: true,
                labelText: 'from'.tr,
              ),
            ),
            const Gap(16),
            // اختيار البيت الأخير (إلى) - Select last poem (to)
            Expanded(
              child: _buildPoemDropdown(
                context: context,
                shareController: shareController,
                isFromSelector: false,
                labelText: 'to'.tr,
              ),
            ),
          ],
        ),
        const Gap(16),
        hDivider(context, width: MediaQuery.sizeOf(context).width),
      ],
    ),
  );
}

/// بناء قائمة منسدلة لاختيار البيت الشعري
/// Build dropdown for poem selection
Widget _buildPoemDropdown({
  required BuildContext context,
  required ShareController shareController,
  required bool isFromSelector,
  required String labelText,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        labelText,
        style: TextStyle(
            color: Theme.of(context).primaryColorLight,
            fontSize: 14,
            fontFamily: 'kufi'),
      ),
      const Gap(4),
      Obx(() => CustomDropdown<int>(
            decoration: CustomDropdownDecoration(
              closedFillColor:
                  context.theme.colorScheme.surface.withValues(alpha: .3),
              expandedFillColor: context.theme.colorScheme.surface,
              closedBorderRadius: const BorderRadius.all(Radius.circular(12)),
              expandedBorderRadius: const BorderRadius.all(Radius.circular(12)),
              closedBorder: Border.all(
                color: context.theme.primaryColor.withValues(alpha: 0.2),
                width: 1.5,
              ),
              expandedBorder: Border.all(
                color: context.theme.primaryColor.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            closedHeaderPadding:
                const EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
            excludeSelected: false,
            hintBuilder: (context, text, select) => Text(
              '${'couplet'.tr} $text'.convertNumbers(),
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 14,
                fontFamily: 'kufi',
              ),
            ),
            headerBuilder: (context, index, select) => Text(
              '${'couplet'.tr} ${index + 1}'.convertNumbers(),
              style: TextStyle(
                color: Theme.of(context).primaryColorLight,
                fontSize: 14,
                fontFamily: 'kufi',
              ),
            ),
            items: List.generate(shareController.poemsCount!, (index) => index),
            listItemBuilder: (context, index, selected, _) => Text(
              '${'couplet'.tr} ${index + 1}'.convertNumbers(),
              style: TextStyle(
                color: !selected
                    ? context.theme.canvasColor
                    : context.theme.primaryColorLight,
                fontSize: 16,
                fontFamily: 'kufi',
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            initialItem: isFromSelector
                ? shareController.fromPoemIndex.value
                : shareController.toPoemIndex.value,
            onChanged: (value) {
              if (isFromSelector) {
                shareController.fromPoemIndex.value = value!;
                // تأكد من أن البداية لا تتجاوز النهاية
                // Ensure start doesn't exceed end
                if (shareController.fromPoemIndex.value >
                    shareController.toPoemIndex.value) {
                  shareController.toPoemIndex.value =
                      shareController.fromPoemIndex.value;
                }
              } else {
                shareController.toPoemIndex.value = value!;
                // تأكد من أن النهاية لا تقل عن البداية
                // Ensure end isn't less than start
                if (shareController.toPoemIndex.value <
                    shareController.fromPoemIndex.value) {
                  shareController.fromPoemIndex.value =
                      shareController.toPoemIndex.value;
                }
              }
            },
          )),
    ],
  );
}

/// بناء قسم مشاركة النص
/// Build text share section
Widget _buildTextShareSection({
  required BuildContext context,
  required ShareController shareController,
  required String bookName,
  required String chapterTitle,
  required String pageText,
  required int pageNumber,
  required List<Poem>? poemsList,
  required String? firstPoem,
  required String? secondPoem,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                width: 2.0,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.text_fields_rounded,
                color:
                    Theme.of(context).primaryColorLight.withValues(alpha: 0.7),
                size: 20,
              ),
              const Gap(8),
              Text(
                'shareText'.tr,
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'kufi',
                ),
              ),
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: () => _handleTextShare(
          shareController: shareController,
          poemsList: poemsList,
          bookName: bookName,
          chapterTitle: chapterTitle,
          pageText: pageText,
          firstPoem: firstPoem,
          secondPoem: secondPoem,
          pageNumber: pageNumber,
        ),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(
              top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
          decoration: BoxDecoration(
              color: context.theme.colorScheme.surface.withValues(alpha: .3),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.text_fields,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Obx(() => Text(
                            poemsList != null && poemsList.isNotEmpty
                                ? poemsList[shareController.fromPoemIndex.value]
                                    .firstPoem!
                                : firstPoem ?? '',
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: 16,
                                fontFamily: 'naskh'),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                          )),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Obx(() => Text(
                            poemsList != null && poemsList.isNotEmpty
                                ? (shareController.fromPoemIndex.value ==
                                        shareController.toPoemIndex.value
                                    ? poemsList[
                                            shareController.fromPoemIndex.value]
                                        .secondPoem!
                                    : '${poemsList[shareController.fromPoemIndex.value].secondPoem!} ... ${poemsList[shareController.toPoemIndex.value].secondPoem!}')
                                : secondPoem ?? '',
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: 16,
                                fontFamily: 'naskh'),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

/// التعامل مع مشاركة النص
/// Handle text sharing
void _handleTextShare({
  required ShareController shareController,
  required List<Poem>? poemsList,
  required String bookName,
  required String chapterTitle,
  required String pageText,
  required String? firstPoem,
  required String? secondPoem,
  required int pageNumber,
}) {
  if (poemsList != null && poemsList.isNotEmpty) {
    final selectedPoems = ShareOptionsService.formatSelectedPoems(poemsList,
        shareController.fromPoemIndex.value, shareController.toPoemIndex.value);

    shareController.shareText(
        bookName, chapterTitle, pageText, '', selectedPoems, pageNumber);
  } else {
    shareController.shareText(
        bookName, chapterTitle, pageText, firstPoem!, secondPoem!, pageNumber);
  }
  Get.back();
}

/// بناء قسم مشاركة الصورة
/// Build image share section
Widget _buildImageShareSection({
  required BuildContext context,
  required ShareController shareController,
  required String bookName,
  required String chapterTitle,
  required String pageText,
  required int pageNumber,
  required List<Poem>? poemsList,
  required String? firstPoem,
  required String? secondPoem,
}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                width: 2.0,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.image_outlined,
                color:
                    Theme.of(context).primaryColorLight.withValues(alpha: 0.7),
                size: 20,
              ),
              const Gap(8),
              Text(
                'shareImage'.tr,
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'kufi',
                ),
              ),
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: () => _handleImageShare(shareController),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          margin: const EdgeInsets.only(
              top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
          decoration: BoxDecoration(
              color: context.theme.colorScheme.surface.withValues(alpha: .3),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ]),
          child: Obx(() {
            return _buildVerseImageCreator(
              shareController: shareController,
              poemsList: poemsList,
              bookName: bookName,
              chapterTitle: chapterTitle,
              firstPoem: firstPoem,
              secondPoem: secondPoem,
              pageText: pageText,
              pageNumber: pageNumber,
            );
          }),
        ),
      ),
    ],
  );
}

/// بناء منشئ صورة البيت الشعري
/// Build verse image creator
Widget _buildVerseImageCreator({
  required ShareController shareController,
  required List<Poem>? poemsList,
  required String bookName,
  required String chapterTitle,
  required String? firstPoem,
  required String? secondPoem,
  required String pageText,
  required int pageNumber,
}) {
  if (poemsList != null && poemsList.isNotEmpty) {
    final poemsFormatted = ShareOptionsService.formatPoemsForImage(poemsList,
        shareController.fromPoemIndex.value, shareController.toPoemIndex.value);

    return VerseImageCreator(
      bookName: bookName,
      chapterTitle: chapterTitle,
      firstPoem: poemsFormatted,
      secondPoem: '', // نمرر سلسلة فارغة لأن كل الأبيات موجودة في firstPoem
      pageText: pageText,
      pageNumber: pageNumber,
    );
  } else {
    return VerseImageCreator(
      bookName: bookName,
      chapterTitle: chapterTitle,
      firstPoem: firstPoem,
      secondPoem: secondPoem,
      pageText: pageText,
      pageNumber: pageNumber,
    );
  }
}

/// بناء قسم النسخ
/// Build copy section
Widget _buildCopySection({
  required BuildContext context,
  required ShareController shareController,
  required String bookName,
  required String chapterTitle,
  required String pageText,
  required int pageNumber,
  required List<Poem>? poemsList,
  required String? firstPoem,
  required String? secondPoem,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          padding: const EdgeInsets.only(bottom: 8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                width: 2.0,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.content_copy_rounded,
                color:
                    Theme.of(context).primaryColorLight.withValues(alpha: 0.7),
                size: 20,
              ),
              const Gap(8),
              Text(
                'copyText'.tr,
                style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'kufi',
                ),
              ),
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: () => _handleCopyText(
          shareController: shareController,
          poemsList: poemsList,
          bookName: bookName,
          chapterTitle: chapterTitle,
          pageText: pageText,
          firstPoem: firstPoem,
          secondPoem: secondPoem,
          pageNumber: pageNumber,
        ),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(
              top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
          decoration: BoxDecoration(
              color: context.theme.colorScheme.surface.withValues(alpha: .3),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.content_copy,
                    color: Theme.of(context).primaryColor,
                    size: 24,
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Obx(() => Text(
                            poemsList != null && poemsList.isNotEmpty
                                ? poemsList[shareController.fromPoemIndex.value]
                                    .firstPoem!
                                : firstPoem ?? '',
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: 16,
                                fontFamily: 'naskh'),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                          )),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Obx(() => Text(
                            poemsList != null && poemsList.isNotEmpty
                                ? (shareController.fromPoemIndex.value ==
                                        shareController.toPoemIndex.value
                                    ? poemsList[
                                            shareController.fromPoemIndex.value]
                                        .secondPoem!
                                    : '${poemsList[shareController.fromPoemIndex.value].secondPoem!} ... ${poemsList[shareController.toPoemIndex.value].secondPoem!}')
                                : secondPoem ?? '',
                            style: TextStyle(
                                color: Theme.of(context).primaryColorLight,
                                fontSize: 16,
                                fontFamily: 'naskh'),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

/// التعامل مع نسخ النص
/// Handle text copy
void _handleCopyText({
  required ShareController shareController,
  required List<Poem>? poemsList,
  required String bookName,
  required String chapterTitle,
  required String pageText,
  required String? firstPoem,
  required String? secondPoem,
  required int pageNumber,
}) {
  if (poemsList != null && poemsList.isNotEmpty) {
    final selectedPoems = ShareOptionsService.formatSelectedPoems(poemsList,
        shareController.fromPoemIndex.value, shareController.toPoemIndex.value);

    shareController.copyText(
        bookName, chapterTitle, pageText, '', selectedPoems, pageNumber);
  } else {
    shareController.copyText(
        bookName, chapterTitle, pageText, firstPoem!, secondPoem!, pageNumber);
  }
  Get.back();
}

/// التعامل مع مشاركة الصورة
/// Handle image sharing
Future<void> _handleImageShare(ShareController shareController) async {
  await sl<ShareController>().createAndShowVerseImage();
  shareController.shareVerse();
  Get.back();
}
