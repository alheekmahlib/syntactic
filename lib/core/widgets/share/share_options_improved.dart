// import 'package:animated_custom_dropdown/custom_dropdown.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:nahawi/core/utils/constants/extensions/convert_number_extension.dart';

// import '/core/utils/constants/extensions.dart';
// import '/core/utils/constants/extensions/svg_extensions.dart';
// import '../../../presentation/controllers/share_controller.dart';
// import '../../../presentation/screens/all_books/data/models/poem_model.dart';
// import '../../services/services_locator.dart';
// import '../../utils/constants/svg_constants.dart';
// import '../../utils/helpers/logger.dart';
// import '../widgets.dart';
// import 'create_image.dart';

// /// عرض خيارات المشاركة في نافذة منبثقة سفلية
// /// Shows share options in a bottom sheet
// Future<void> showShareOptionsBottomSheet(
//   BuildContext context, {
//   required String bookName,
//   required String chapterTitle,
//   String? firstPoem,
//   String? secondPoem,
//   required String pageText,
//   required int pageNumber,
//   List<Poem>? poemsList, // إضافة قائمة الأبيات الشعرية
// }) async {
//   try {
//     final shareToImage = sl<ShareController>();
//     log('تهيئة خيارات المشاركة', name: 'ShareOptions');

//     // تعيين عدد الأبيات وضبط القيم الافتراضية
//     // Set poem count and default values
//     shareToImage.poemsCount = poemsList?.length ?? 1;

//     // ضبط القيمة الافتراضية لنهاية المدى
//     // Set default value for the end range
//     if (shareToImage.poemsCount! > 0) {
//       shareToImage.toPoemIndex.value = shareToImage.poemsCount! - 1;
//     }

//     Get.bottomSheet(
//       _buildBottomSheetContent(context, shareToImage, bookName, chapterTitle,
//           firstPoem, secondPoem, pageText, pageNumber, poemsList),
//       isScrollControlled: true,
//     );
//   } catch (e) {
//     log('خطأ في إظهار خيارات المشاركة: $e', name: 'ShareOptions');
//   }
// }

// /// إنشاء محتوى النافذة المنبثقة
// /// Build bottom sheet content
// Widget _buildBottomSheetContent(
//   BuildContext context,
//   ShareController shareToImage,
//   String bookName,
//   String chapterTitle,
//   String? firstPoem,
//   String? secondPoem,
//   String pageText,
//   int pageNumber,
//   List<Poem>? poemsList,
// ) {
//   return Container(
//     height: context.customOrientation(MediaQuery.sizeOf(context).height * .7,
//         MediaQuery.sizeOf(context).height),
//     alignment: Alignment.center,
//     decoration: BoxDecoration(
//       color: Theme.of(context).colorScheme.primaryContainer,
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(8.0),
//         topRight: Radius.circular(8.0),
//       ),
//     ),
//     child: SafeArea(
//       child: Stack(
//         children: [
//           _buildHeader(context),
//           Padding(
//             padding: const EdgeInsets.only(top: 70.0),
//             child: ListView(
//               children: [
//                 // إضافة قسم اختيار مدى الأبيات
//                 // Add poem range selector if there's more than one poem
//                 if (poemsList != null && poemsList.length > 1)
//                   _buildPoemRangeSelector(context, shareToImage, poemsList),

//                 _buildShareTextSection(
//                     context,
//                     bookName,
//                     chapterTitle,
//                     firstPoem,
//                     secondPoem,
//                     pageText,
//                     pageNumber,
//                     shareToImage,
//                     poemsList),

//                 hDivider(context, width: MediaQuery.sizeOf(context).width),

//                 _buildShareImageSection(
//                     context,
//                     bookName,
//                     chapterTitle,
//                     firstPoem,
//                     secondPoem,
//                     pageText,
//                     pageNumber,
//                     shareToImage,
//                     poemsList),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

// /// بناء الجزء العلوي (الهيدر) للنافذة
// /// Build header for the dialog
// Widget _buildHeader(BuildContext context) {
//   return Align(
//     alignment: Alignment.topRight,
//     child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             customClose(
//               context,
//               close: () => Get.back(),
//               color:
//                   Theme.of(context).colorScheme.surface.withValues(alpha: .5),
//               color2: Theme.of(context).colorScheme.surface,
//             ),
//             context.customSvg(SvgPath.svgSharing, width: 20.0),
//           ],
//         )),
//   );
// }

// /// بناء قسم اختيار مدى الأبيات (من - إلى)
// /// Build the poem range selector section (from - to)
// Widget _buildPoemRangeSelector(
//     BuildContext context, ShareController shareToImage, List<Poem> poemsList) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'choicePoems'.tr,
//           style: TextStyle(
//               color: Theme.of(context).primaryColorLight,
//               fontSize: 16,
//               fontFamily: 'kufi'),
//         ),
//         const Gap(8),
//         Row(
//           children: [
//             // اختيار البيت الأول (من)
//             // Select first poem (from)
//             Expanded(
//               child: _buildFromDropdown(context, shareToImage),
//             ),
//             const Gap(16),
//             // اختيار البيت الأخير (إلى)
//             // Select last poem (to)
//             Expanded(
//               child: _buildToDropdown(context, shareToImage),
//             ),
//           ],
//         ),
//         const Gap(16),
//         hDivider(context, width: MediaQuery.sizeOf(context).width),
//       ],
//     ),
//   );
// }

// /// بناء قائمة "من" المنسدلة
// /// Build the "from" dropdown list
// Widget _buildFromDropdown(BuildContext context, ShareController shareToImage) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         'from'.tr,
//         style: TextStyle(
//             color: Theme.of(context).primaryColorLight,
//             fontSize: 14,
//             fontFamily: 'kufi'),
//       ),
//       const Gap(4),
//       Obx(() => CustomDropdown<int>(
//             decoration: CustomDropdownDecoration(
//               closedFillColor:
//                   context.theme.colorScheme.surface.withValues(alpha: .3),
//               expandedFillColor: context.theme.colorScheme.surface,
//               closedBorderRadius: const BorderRadius.all(Radius.circular(4)),
//               expandedBorderRadius: const BorderRadius.all(Radius.circular(4)),
//             ),
//             closedHeaderPadding:
//                 const EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
//             excludeSelected: false,
//             hintBuilder: (context, text, select) => Text(
//               '${'couplet'.tr} ${(text + 1).toString()}'.convertNumbers(),
//               style: TextStyle(
//                 color: Theme.of(context).primaryColorLight,
//                 fontSize: 14,
//                 fontFamily: 'kufi',
//               ),
//             ),
//             headerBuilder: (context, text, select) => Text(
//               '${'couplet'.tr} ${(text + 1).toString()}'.convertNumbers(),
//               style: TextStyle(
//                 color: Theme.of(context).primaryColorLight,
//                 fontSize: 14,
//                 fontFamily: 'kufi',
//               ),
//             ),
//             items: List.generate(shareToImage.poemsCount!, (index) => index),
//             listItemBuilder: (context, index, selected, _) => Text(
//               '${'couplet'.tr} ${(index + 1).toString()}'.convertNumbers(),
//               style: TextStyle(
//                 color: !selected
//                     ? context.theme.canvasColor
//                     : context.theme.primaryColorLight,
//                 fontSize: 16,
//                 fontFamily: 'kufi',
//                 fontWeight: selected ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//             initialItem: shareToImage.fromPoemIndex.value,
//             onChanged: (value) {
//               if (value != null) {
//                 shareToImage.fromPoemIndex.value = value;
//                 // تأكد من أن البداية لا تتجاوز النهاية
//                 // Make sure start doesn't exceed end
//                 if (shareToImage.fromPoemIndex.value >
//                     shareToImage.toPoemIndex.value) {
//                   shareToImage.toPoemIndex.value =
//                       shareToImage.fromPoemIndex.value;
//                 }
//               }
//             },
//           )),
//     ],
//   );
// }

// /// بناء قائمة "إلى" المنسدلة
// /// Build the "to" dropdown list
// Widget _buildToDropdown(BuildContext context, ShareController shareToImage) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         'to'.tr,
//         style: TextStyle(
//             color: Theme.of(context).primaryColorLight,
//             fontSize: 14,
//             fontFamily: 'kufi'),
//       ),
//       const Gap(4),
//       Obx(() => CustomDropdown<int>(
//             decoration: CustomDropdownDecoration(
//               closedFillColor:
//                   context.theme.colorScheme.surface.withValues(alpha: .3),
//               expandedFillColor: context.theme.colorScheme.surface,
//               closedBorderRadius: const BorderRadius.all(Radius.circular(4)),
//               expandedBorderRadius: const BorderRadius.all(Radius.circular(4)),
//             ),
//             closedHeaderPadding:
//                 const EdgeInsets.symmetric(vertical: 7.0, horizontal: 8.0),
//             excludeSelected: false,
//             hintBuilder: (context, text, select) => Text(
//               '${'couplet'.tr} ${(text + 1).toString()}'.convertNumbers(),
//               style: TextStyle(
//                 color: Theme.of(context).primaryColorLight,
//                 fontSize: 14,
//                 fontFamily: 'kufi',
//               ),
//             ),
//             headerBuilder: (context, text, select) => Text(
//               '${'couplet'.tr} ${(text + 1).toString()}'.convertNumbers(),
//               style: TextStyle(
//                 color: Theme.of(context).primaryColorLight,
//                 fontSize: 14,
//                 fontFamily: 'kufi',
//               ),
//             ),
//             items: List.generate(shareToImage.poemsCount!, (index) => index),
//             listItemBuilder: (context, index, selected, _) => Text(
//               '${'couplet'.tr} ${(index + 1).toString()}'.convertNumbers(),
//               style: TextStyle(
//                 color: !selected
//                     ? context.theme.canvasColor
//                     : context.theme.primaryColorLight,
//                 fontSize: 16,
//                 fontFamily: 'kufi',
//                 fontWeight: selected ? FontWeight.bold : FontWeight.normal,
//               ),
//             ),
//             initialItem: shareToImage.toPoemIndex.value,
//             onChanged: (value) {
//               if (value != null) {
//                 shareToImage.toPoemIndex.value = value;
//                 // تأكد من أن النهاية لا تقل عن البداية
//                 // Make sure end doesn't go below start
//                 if (shareToImage.toPoemIndex.value <
//                     shareToImage.fromPoemIndex.value) {
//                   shareToImage.fromPoemIndex.value =
//                       shareToImage.toPoemIndex.value;
//                 }
//               }
//             },
//           )),
//     ],
//   );
// }

// /// بناء قسم مشاركة النص
// /// Build text sharing section
// Widget _buildShareTextSection(
//     BuildContext context,
//     String bookName,
//     String chapterTitle,
//     String? firstPoem,
//     String? secondPoem,
//     String pageText,
//     int pageNumber,
//     ShareController shareToImage,
//     List<Poem>? poemsList) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: Text(
//           'shareText'.tr,
//           style: TextStyle(
//               color: Theme.of(context).primaryColorLight,
//               fontSize: 16,
//               fontFamily: 'kufi'),
//         ),
//       ),
//       GestureDetector(
//         child: _buildShareTextPreview(
//             context, shareToImage, poemsList, firstPoem, secondPoem),
//         onTap: () {
//           _handleShareText(bookName, chapterTitle, pageText, firstPoem,
//               secondPoem, pageNumber, shareToImage, poemsList);
//         },
//       ),
//     ],
//   );
// }

// /// بناء معاينة النص المراد مشاركته
// /// Build text preview for sharing
// Widget _buildShareTextPreview(
//     BuildContext context,
//     ShareController shareToImage,
//     List<Poem>? poemsList,
//     String? firstPoem,
//     String? secondPoem) {
//   return Container(
//     width: MediaQuery.sizeOf(context).width,
//     padding: const EdgeInsets.all(16.0),
//     margin:
//         const EdgeInsets.only(top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
//     decoration: BoxDecoration(
//         color: context.theme.colorScheme.surface.withValues(alpha: .3),
//         borderRadius: const BorderRadius.all(Radius.circular(4))),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Expanded(
//           flex: 2,
//           child: Icon(
//             Icons.text_fields,
//             color: Color(0xFF77554C),
//             size: 24,
//           ),
//         ),
//         Expanded(
//           flex: 8,
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Obx(() => Text(
//                       _getFirstPoemText(poemsList, shareToImage, firstPoem),
//                       style: TextStyle(
//                           color: Theme.of(context).primaryColorLight,
//                           fontSize: 16,
//                           fontFamily: 'naskh'),
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.justify,
//                       textDirection: TextDirection.rtl,
//                     )),
//               ),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Obx(() => Text(
//                       _getSecondPoemText(poemsList, shareToImage, secondPoem),
//                       style: TextStyle(
//                           color: Theme.of(context).primaryColorLight,
//                           fontSize: 16,
//                           fontFamily: 'naskh'),
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                       textAlign: TextAlign.justify,
//                       textDirection: TextDirection.rtl,
//                     )),
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }

// /// الحصول على نص البيت الأول للعرض
// /// Get first poem text for display
// String _getFirstPoemText(
//     List<Poem>? poemsList, ShareController shareToImage, String? firstPoem) {
//   if (poemsList != null && poemsList.isNotEmpty) {
//     return poemsList[shareToImage.fromPoemIndex.value].firstPoem ?? '';
//   }
//   return firstPoem ?? '';
// }

// /// الحصول على نص البيت الثاني للعرض
// /// Get second poem text for display
// String _getSecondPoemText(
//     List<Poem>? poemsList, ShareController shareToImage, String? secondPoem) {
//   if (poemsList != null && poemsList.isNotEmpty) {
//     if (shareToImage.fromPoemIndex.value == shareToImage.toPoemIndex.value) {
//       return poemsList[shareToImage.fromPoemIndex.value].secondPoem ?? '';
//     } else {
//       return '${poemsList[shareToImage.fromPoemIndex.value].secondPoem ?? ''} ... ${poemsList[shareToImage.toPoemIndex.value].secondPoem ?? ''}';
//     }
//   }
//   return secondPoem ?? '';
// }

// /// معالجة حدث مشاركة النص
// /// Handle text sharing event
// void _handleShareText(
//     String bookName,
//     String chapterTitle,
//     String pageText,
//     String? firstPoem,
//     String? secondPoem,
//     int pageNumber,
//     ShareController shareToImage,
//     List<Poem>? poemsList) {
//   try {
//     // مشاركة الأبيات المحددة كنص
//     // Share selected poems as text
//     if (poemsList != null && poemsList.isNotEmpty) {
//       String selectedPoems = _buildSelectedPoemsText(poemsList, shareToImage);

//       shareToImage.shareText(
//           bookName,
//           chapterTitle,
//           pageText,
//           '', // نمرر سلسلة فارغة لتجنب التكرار / Pass empty string to avoid duplication
//           selectedPoems,
//           pageNumber);
//     } else {
//       shareToImage.shareText(bookName, chapterTitle, pageText, firstPoem ?? '',
//           secondPoem ?? '', pageNumber);
//     }

//     Get.back();
//     log('تم مشاركة النص بنجاح', name: 'ShareOptions');
//   } catch (e) {
//     log('خطأ عند مشاركة النص: $e', name: 'ShareOptions');
//   }
// }

// /// بناء نص الأبيات المحددة للمشاركة
// /// Build selected poems text for sharing
// String _buildSelectedPoemsText(
//     List<Poem> poemsList, ShareController shareToImage) {
//   String selectedPoems = '';

//   for (int i = shareToImage.fromPoemIndex.value;
//       i <= shareToImage.toPoemIndex.value;
//       i++) {
//     selectedPoems +=
//         '${poemsList[i].firstPoem ?? ''}\n${poemsList[i].secondPoem ?? ''}';

//     if (i < shareToImage.toPoemIndex.value) {
//       selectedPoems += '\n\n';
//     }
//   }

//   return selectedPoems;
// }

// /// بناء قسم مشاركة الصورة
// /// Build image sharing section
// Widget _buildShareImageSection(
//     BuildContext context,
//     String bookName,
//     String chapterTitle,
//     String? firstPoem,
//     String? secondPoem,
//     String pageText,
//     int pageNumber,
//     ShareController shareToImage,
//     List<Poem>? poemsList) {
//   return Column(
//     children: [
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'shareImage'.tr,
//               style: TextStyle(
//                   color: Theme.of(context).primaryColorLight,
//                   fontSize: 16,
//                   fontFamily: 'kufi'),
//             ),
//           ],
//         ),
//       ),
//       GestureDetector(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
//           margin: const EdgeInsets.only(
//               top: 4.0, bottom: 16.0, right: 16.0, left: 16.0),
//           decoration: BoxDecoration(
//               color: context.theme.colorScheme.surface.withValues(alpha: .3),
//               borderRadius: const BorderRadius.all(Radius.circular(4))),
//           child: _buildImagePreview(bookName, chapterTitle, firstPoem,
//               secondPoem, pageText, pageNumber, shareToImage, poemsList),
//         ),
//         onTap: () async {
//           try {
//             await sl<ShareController>().createAndShowVerseImage();
//             shareToImage.shareVerse();
//             Get.back();
//             log('تم مشاركة الصورة بنجاح', name: 'ShareOptions');
//           } catch (e) {
//             log('خطأ عند مشاركة الصورة: $e', name: 'ShareOptions');
//           }
//         },
//       ),
//     ],
//   );
// }

// /// إنشاء معاينة الصورة
// /// Create image preview
// Widget _buildImagePreview(
//     String bookName,
//     String chapterTitle,
//     String? firstPoem,
//     String? secondPoem,
//     String pageText,
//     int pageNumber,
//     ShareController shareToImage,
//     List<Poem>? poemsList) {
//   return Obx(() {
//     try {
//       // إنشاء صورة بناءً على الأبيات المختارة
//       // Create image based on selected poems
//       if (poemsList != null && poemsList.isNotEmpty) {
//         String poemsFormatted = _formatPoemsForImage(poemsList, shareToImage);

//         return VerseImageCreator(
//           bookName: bookName,
//           chapterTitle: chapterTitle,
//           firstPoem: poemsFormatted,
//           secondPoem:
//               '', // نمرر سلسلة فارغة لأن كل الأبيات موجودة في firstPoem / Pass empty string as all poems are in firstPoem
//           pageText: pageText,
//           pageNumber: pageNumber,
//         );
//       } else {
//         return VerseImageCreator(
//           bookName: bookName,
//           chapterTitle: chapterTitle,
//           firstPoem: firstPoem,
//           secondPoem: secondPoem,
//           pageText: pageText,
//           pageNumber: pageNumber,
//         );
//       }
//     } catch (e) {
//       log('خطأ في إنشاء معاينة الصورة: $e', name: 'ShareOptions');
//       return const Center(
//           child: Text('خطأ في إنشاء المعاينة / Error creating preview'));
//     }
//   });
// }

// /// تنسيق الأبيات الشعرية لعرضها في الصورة
// /// Format poems for display in the image
// String _formatPoemsForImage(
//     List<Poem> poemsList, ShareController shareToImage) {
//   String poemsFormatted = '';

//   for (int i = shareToImage.fromPoemIndex.value;
//       i <= shareToImage.toPoemIndex.value;
//       i++) {
//     poemsFormatted +=
//         '${poemsList[i].firstPoem ?? ''}\n${poemsList[i].secondPoem ?? ''}';

//     if (i < shareToImage.toPoemIndex.value) {
//       poemsFormatted += '\n\n';
//     }
//   }

//   return poemsFormatted;
// }
