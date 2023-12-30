import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/constants/svg_picture.dart';
import '../../../../core/widgets/text_overflow_detector.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/books_controller.dart';

class BookDetails extends StatelessWidget {
  final int bookNumber;
  final String bookName;
  const BookDetails(
      {super.key, required this.bookName, required this.bookNumber});

  @override
  Widget build(BuildContext context) {
    var book = sl<BooksController>().book.value;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        beigeContainer(
          context,
          // height: 290,
          width: 380,
          color: Theme.of(context).colorScheme.surface.withOpacity(.15),
          Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 32,
                  width: 107,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    'aboutBook'.tr,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Gap(35.h),
              Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                  child: ReadMoreLess(
                    text: book!.aboutBook!,
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'naskh',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.justify,
                    readMoreText: 'readMore'.tr,
                    readLessText: 'readLess'.tr,
                    buttonTextStyle: TextStyle(
                      fontSize: 12,
                      fontFamily: 'kufi',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    iconColor: Theme.of(context).colorScheme.primary,
                  )),
            ],
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -120),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Hero(
                        tag: 'book-tag',
                        child: book_cover(context,
                            index: bookNumber, height: 138.h, width: 176.w)),
                    Transform.translate(
                      offset: const Offset(2, 30),
                      child: SizedBox(
                        height: 150,
                        width: 90,
                        child: Text(
                          bookName,
                          style: TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'kufi',
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                              height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    'scienceSyntax'.tr,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
