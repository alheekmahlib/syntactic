import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/helpers/app_text_styles.dart';
import 'package:screenshot/screenshot.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '../../../presentation/controllers/share_controller.dart';
import '../../services/services_locator.dart';
import '../../utils/constants/svg_constants.dart';

class VerseImageCreator extends StatelessWidget {
  final String bookName;
  final String chapterTitle;
  final String? firstPoem;
  final String? secondPoem;
  final String pageText;
  final int pageNumber;

  VerseImageCreator({
    super.key,
    required this.bookName,
    required this.chapterTitle,
    this.firstPoem,
    this.secondPoem,
    required this.pageText,
    required this.pageNumber,
  });
  final ayahToImage = sl<ShareController>();

  @override
  Widget build(BuildContext context) {
    // إضافة تأثير للصورة عند التوليد
    // Add animation effect when generating the image
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            boxShadow: [
              BoxShadow(
                color:
                    context.theme.colorScheme.surface.withValues(alpha: 0.15),
                spreadRadius: 1,
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Screenshot(
            controller: ayahToImage.ayahScreenController,
            child: buildVerseImageWidget(
                context: context,
                bookName: bookName,
                chapterTitle: chapterTitle,
                firstPoem: firstPoem,
                secondPoem: secondPoem,
                pageText: pageText,
                pageNumber: pageNumber),
          ),
        ),
      ],
    );
  }

  // دالة لبناء الأبيات الشعرية - كل شطر أول على اليمين والشطر الثاني تحته على اليسار
  // Function to build poetry lines - each first part on right, second part below it on left
  List<Widget> _buildPoemLines(String poemText, BuildContext context) {
    if (poemText.isEmpty) return [];

    // قسم النص إلى أبيات شعرية منفصلة
    // Split text into separate poetry verses
    final List<String> verses = poemText.split('\n\n');
    List<Widget> poemWidgets = [];

    for (String verse in verses) {
      // تقسيم البيت إلى شطرين (الأول والثاني)
      // Split the verse into two parts (first and second)
      final List<String> parts = verse.split('\n');
      if (parts.isNotEmpty) {
        // إضافة الشطر الأول (على اليمين)
        // Add first part (on the right)
        poemWidgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                parts[0],
                style: AppTextStyles.titleMedium(
                  fontSize: 16.0.sp,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        );

        // إضافة مساحة صغيرة بين الشطرين
        // Add small space between the two parts
        poemWidgets.add(const SizedBox(height: 6));

        // إضافة الشطر الثاني (على اليسار) إذا كان موجود
        // Add second part (on the left) if exists
        if (parts.length >= 2) {
          poemWidgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  parts[1],
                  style: AppTextStyles.titleMedium(
                    fontSize: 16.0.sp,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          );
        }

        // إضافة مساحة بين الأبيات مع فاصل جمالي
        // Add space between verses with aesthetic divider
        if (verses.indexOf(verse) < verses.length - 1) {
          poemWidgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF77554C).withValues(alpha: 0.0),
                          const Color(0xFF77554C).withValues(alpha: 0.3),
                          const Color(0xFF77554C).withValues(alpha: 0.0),
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFFFE),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF77554C).withValues(alpha: 0.2),
                        width: 0.5,
                      ),
                    ),
                    width: 8,
                    height: 8,
                  ),
                ],
              ),
            ),
          );
        }
      }
    }

    return poemWidgets;
  }

  Widget buildVerseImageWidget({
    required BuildContext context,
    required String bookName,
    required String chapterTitle,
    String? firstPoem,
    String? secondPoem,
    required String pageText,
    required int pageNumber,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 1280.0,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFC39B7B),
                const Color(0xFFBE9171),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ]),
        child: Column(
          children: [
            const Gap(4),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RotatedBox(
                    quarterTurns: 1,
                    child: customSvgWithColor(SvgPath.svgSyntactic,
                        height: 16, color: context.theme.canvasColor),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            bookName,
                            style: AppTextStyles.titleSmall(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            chapterTitle,
                            style: AppTextStyles.titleSmall(
                                color: context.theme.canvasColor),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                  RotatedBox(
                    quarterTurns: 3,
                    child: customSvgWithColor(SvgPath.svgSyntactic,
                        height: 16, color: context.theme.canvasColor),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                  color: context.theme.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]),
              child: Column(
                children: [
                  const Gap(16),
                  // قسم عرض الأبيات الشعرية
                  // Poetry display section
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // استعراض محتوى البيت الشعري بشكل متناسق
                          // Display poetry content in a consistent format
                          if (firstPoem != null && firstPoem.isNotEmpty)
                            ..._buildPoemLines(firstPoem, context),
                        ],
                      )),
                  const Gap(16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
