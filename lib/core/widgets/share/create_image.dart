import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:screenshot/screenshot.dart';
import 'package:syntactic/core/widgets/widgets.dart';
import 'package:syntactic/presentation/controllers/general_controller.dart';

import '../../../presentation/controllers/books_controller.dart';
import '../../../presentation/controllers/share_controller.dart';
import '../../services/services_locator.dart';
import '../../utils/constants/svg_picture.dart';

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
    final bookCtrl = sl<BooksController>();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 960.0,
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
                    chapterTitle,
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
                  width: 928.0,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 16.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              bookCtrl.loadPoemBooks ? firstPoem! : pageText,
                              style: TextStyle(
                                fontSize: 20.0.sp,
                                fontFamily: 'naskh',
                                color: Theme.of(context).primaryColorLight,
                              ),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              secondPoem!,
                              style: TextStyle(
                                fontSize: 20.0.sp,
                                fontFamily: 'naskh',
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
                const Gap(24),
                Container(
                  alignment: Alignment.center,
                  color: Theme.of(context).colorScheme.surface,
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          RotatedBox(
                              quarterTurns: 15,
                              child: syntactic_logo(context, height: 15)),
                          vDivider(context, height: 25),
                          Text(
                            'تطبيق\nنحــــوي',
                            style: TextStyle(
                                fontSize: 14.0,
                                fontFamily: 'kufi',
                                color: Theme.of(context).primaryColorLight,
                                height: 1),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            bookName,
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: 'kufi',
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(4),
                          bookCtrl.loadPoemBooks
                              ? const SizedBox.shrink()
                              : Text(
                                  'الصفحة: ${sl<GeneralController>().arabicNumbers.convert(pageNumber)}',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontFamily: 'kufi',
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ],
                      ),
                    ],
                  ),
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
