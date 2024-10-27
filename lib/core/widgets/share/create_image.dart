import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
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

  const VerseImageCreator({
    super.key,
    required this.bookName,
    required this.chapterTitle,
    this.firstPoem,
    this.secondPoem,
    required this.pageText,
    required this.pageNumber,
  });

  @override
  Widget build(BuildContext context) {
    final ayahToImage = sl<ShareController>();
    return Column(
      children: [
        Screenshot(
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
      ],
    );
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
        decoration: const BoxDecoration(
            color: Color(0xFFC39B7B),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: const BoxDecoration(
              color: Color(0xffFFFFFE),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 16.0),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                  ),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    bookName,
                    style: TextStyle(
                      fontSize: 17.0,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(16),
                SizedBox(
                  width: 1248.0,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 32.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              firstPoem!,
                              style: TextStyle(
                                fontSize: 18.0.sp,
                                fontFamily: 'naskh',
                                color: const Color(0xFF77554C),
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              secondPoem!,
                              style: TextStyle(
                                fontSize: 18.0.sp,
                                fontFamily: 'naskh',
                                color: const Color(0xFF77554C),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                const Gap(24),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 45,
                      width: MediaQuery.sizeOf(context).width,
                      alignment: Alignment.center,
                      color: Theme.of(context).colorScheme.surface,
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16.0),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              color: const Color(0xffFFFFFE),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 5.0),
                              child: Row(
                                children: [
                                  RotatedBox(
                                      quarterTurns: 15,
                                      child: customSvg(SvgPath.svgSyntactic,
                                          height: 15)),
                                  vDivider(context, height: 25),
                                  const Text(
                                    'تطبيق\nنحــــوي',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'kufi',
                                        color: Color(0xFF77554C),
                                        height: 1),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                vDivider(context,
                                    height: 25, color: const Color(0xffFFFFFE)),
                                Column(
                                  children: [
                                    Text(
                                      chapterTitle,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'kufi',
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const Gap(4),
                                  ],
                                ),
                                vDivider(context,
                                    height: 25, color: const Color(0xffFFFFFE)),
                              ],
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
