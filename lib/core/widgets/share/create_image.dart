import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/route_manager.dart';
import 'package:nahawi/core/utils/constants/extensions/svg_extensions.dart';
import 'package:screenshot/screenshot.dart';

import '/core/widgets/widgets.dart';
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
                color: Colors.black.withValues(alpha: 0.15),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF77554C).withValues(alpha: 0.07),
                  const Color(0xFF77554C).withValues(alpha: 0.01)
                ],
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                topRight: Radius.circular(2),
                bottomRight: Radius.circular(2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                )
              ],
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                parts[0],
                style: TextStyle(
                  fontSize: 20.0.sp,
                  fontFamily: 'naskh',
                  color: const Color(0xFF77554C),
                  height: 1.5,
                  fontWeight: FontWeight.w500,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF77554C).withValues(alpha: 0.01),
                    const Color(0xFF77554C).withValues(alpha: 0.07),
                  ],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                  topLeft: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  )
                ],
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  parts[1],
                  style: TextStyle(
                    fontSize: 19.0.sp,
                    fontFamily: 'naskh',
                    color: const Color(0xFF77554C),
                    height: 1.5,
                    fontWeight: FontWeight.w500,
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
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
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
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ]),
        child: Container(
          margin: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
              color: const Color(0xffFFFFFE),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  spreadRadius: 0,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              children: [
                // قسم عنوان الكتاب مع خلفية متدرجة
                // Book title section with gradient background
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      vertical: 6.0, horizontal: 24.0),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                  ),
                  decoration: BoxDecoration(
                      color: const Color(0xFFC39B7B),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]),
                  child: Text(
                    bookName,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).canvasColor,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(20),
                // قسم عرض الأبيات الشعرية
                // Poetry display section
                Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAF6F2),
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        spreadRadius: 0,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // استعراض محتوى البيت الشعري بشكل متناسق
                          // Display poetry content in a consistent format
                          if (firstPoem != null && firstPoem.isNotEmpty)
                            ..._buildPoemLines(firstPoem, context),
                        ],
                      )),
                ),
                const Gap(24),
                // قسم الفوتر مع شعار التطبيق والمعلومات
                // Footer section with app logo and information
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: MediaQuery.sizeOf(context).width,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withValues(alpha: 0.7),
                            Theme.of(context).colorScheme.surface,
                            Theme.of(context)
                                .colorScheme
                                .surface
                                .withValues(alpha: 0.7),
                          ],
                          begin: Alignment.centerRight,
                          end: Alignment.centerLeft,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 16.0),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // شعار التطبيق - App Logo
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFFFE),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    spreadRadius: 0,
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 6.0),
                              child: Row(
                                children: [
                                  RotatedBox(
                                      quarterTurns: 15,
                                      child: customSvg(SvgPath.svgSyntactic,
                                          height: 16)),
                                  const SizedBox(width: 8),
                                  vDivider(context, height: 28),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'تطبيق\nنحــــوي',
                                    style: TextStyle(
                                        fontSize: 13.0,
                                        fontFamily: 'kufi',
                                        color: Color(0xFF77554C),
                                        fontWeight: FontWeight.bold,
                                        height: 1.1),
                                  ),
                                ],
                              ),
                            ),
                            // معلومات الكتاب - Book information
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFFFE),
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    spreadRadius: 0,
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 2.0),
                              child: Row(
                                children: [
                                  vDivider(context, height: 28),
                                  const SizedBox(width: 8),
                                  Text(
                                    chapterTitle,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: 'kufi',
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF77554C),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(width: 8),
                                  vDivider(context, height: 28),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                // Add more widgets as needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
