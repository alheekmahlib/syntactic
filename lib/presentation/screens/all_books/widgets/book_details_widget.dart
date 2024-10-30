import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/html_text_span_extension.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_getters.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_ui.dart';

import '../../../../core/utils/constants/svg_picture.dart';
import '../../../../core/widgets/read_more_less/read_more_less.dart';
import '../controller/books_controller.dart';

class BookDetails extends StatelessWidget {
  final int bookNumber;
  final String bookName;
  final String bookType;
  final String aboutBook;

  BookDetails({
    super.key,
    required this.bookName,
    required this.bookNumber,
    required this.bookType,
    required this.aboutBook,
  });

  final booksCtrl = AllBooksController.instance;

  @override
  Widget build(BuildContext context) {
    // OverlayTooltipScaffold.of(context)?.controller.start(3);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          // height: 290,
          width: 380,
          margin: const EdgeInsets.only(top: 120, right: 16.0, left: 16.0),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface.withOpacity(.15),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 32,
                // width: 107,
                padding:
                    const EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
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
              Gap(35.h),
              Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                  child: Obx(() => ReadMoreLess(
                        text: aboutBook.buildTextSpansFromHtml(),
                        maxLines: 1,
                        collapsedHeight: booksCtrl
                                .collapsedHeight(bookNumber, bookType)
                                .value
                            ? 130
                            : 30,
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontFamily: 'naskh',
                          color: Theme.of(context).primaryColorLight,
                        ),
                        textAlign: TextAlign.justify,
                        readMoreText: 'readMore'.tr,
                        readLessText: 'readLess'.tr,
                        buttonTextStyle: TextStyle(
                          fontSize: 12,
                          fontFamily: 'kufi',
                          color: Theme.of(context).primaryColorLight,
                        ),
                        iconColor: Theme.of(context).primaryColorLight,
                      ))),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Hero(
                      tag: 'book-tag:$bookNumber',
                      child: book_cover(context,
                          index: booksCtrl.state.bookNumber.value + 1,
                          height: 138.h,
                          width: 176.w)),
                  Transform.translate(
                    offset: const Offset(2, 20),
                    child: SizedBox(
                      height: 150,
                      width: 90,
                      child: Text(
                        bookName,
                        style: TextStyle(
                            fontSize: 18.0,
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
              booksCtrl.getLocalBooks(bookNumber).value
                  ? SizedBox.shrink()
                  : Align(
                      alignment: Alignment.center,
                      child: Center(
                        child: GetBuilder<AllBooksController>(
                          builder: (booksCtrl) => booksCtrl
                                  .isBookDownloaded(bookType, bookNumber)
                                  .value
                              ? GestureDetector(
                                  child: Icon(
                                    Icons.delete,
                                    size: 28,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                                  onTap: () async => await booksCtrl.deleteBook(
                                      bookNumber, bookType),
                                )
                              : Row(
                                  children: [
                                    booksCtrl.state.downloading[bookNumber] ==
                                            true
                                        ? Container(
                                            width: 150,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .surface,
                                              ),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(4)),
                                            ),
                                            child: Obx(() =>
                                                LinearProgressIndicator(
                                                  minHeight: 10,
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(4)),
                                                  value: booksCtrl.state
                                                              .downloadProgress[
                                                          bookNumber] ??
                                                      0,
                                                  //(daysRemaining / 1000).toDouble(),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .canvasColor,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .surface,
                                                )),
                                          )
                                        : const SizedBox.shrink(),
                                    booksCtrl.state.downloading[bookNumber] ==
                                            true
                                        ? const SizedBox.shrink()
                                        : GestureDetector(
                                            child: Icon(
                                              Icons.download,
                                              size: 24,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            onTap: () async =>
                                                await booksCtrl.downloadBook(
                                                    bookNumber, bookType),
                                          ),
                                  ],
                                ),
                        ),
                      ),
                    ),
            ],
          ),
        )
      ],
    );
  }
}
