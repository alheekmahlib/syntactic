import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '/core/utils/constants/extensions/convert_number_extension.dart';
import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '/core/utils/constants/extensions/extensions.dart';
import '/core/utils/constants/extensions/font_size_extension.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/presentation/screens/all_books/controller/extensions/books_getters.dart';
import '/presentation/screens/all_books/controller/extensions/books_ui.dart';
import '../../../../core/utils/constants/svg_constants.dart';
import '../../../controllers/bookmarks_controller.dart';
import '../controller/books_controller.dart';
import '../data/models/page_model.dart';

class BooksTopTitleWidget extends StatelessWidget {
  final int bookNumber;
  final int index;
  final List<PageContent> pages;
  final booksCtrl = AllBooksController.instance;
  final bookmarkCtrl = BookmarksController.instance;

  BooksTopTitleWidget(
      {super.key,
      required this.bookNumber,
      required this.index,
      required this.pages});

  @override
  Widget build(BuildContext context) {
    final page = pages[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Wrap(
            children: [
              Text(
                page.bookTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'kufi',
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              context.vDivider(height: 20),
              Obx(() => Text(
                    booksCtrl
                        .getPartByPageNumber(bookNumber,
                            booksCtrl.state.currentPageIndex.value + 1)
                        .partNumber,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'kufi',
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  )),
              context.vDivider(height: 20),
              Text(
                booksCtrl
                    .getChaptersByPage(
                        bookNumber, booksCtrl.state.currentPageIndex.value + 1)
                    .chapterName,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'kufi',
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Container(
          height: 40,
          width: Get.width,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.3),
                  offset: const Offset(0, 5),
                  blurRadius: 70,
                  spreadRadius: 0,
                )
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 7,
                child: Text(
                  (booksCtrl.state.currentPageIndex.value + 1)
                      .toString()
                      .convertNumbers(),
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'kufi',
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GetX<AllBooksController>(
                builder: (booksCtrl) {
                  return GestureDetector(
                    onTap: () => booksCtrl.isTashkilOnTap(),
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8),
                          ),
                          border: Border.all(
                            width: 1,
                            color: Theme.of(context).colorScheme.surface,
                          )),
                      child: customSvgWithColor(
                        SvgPath.svgTashkil,
                        height: 30.0,
                        color: booksCtrl.state.isTashkil.value
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                },
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        border: Border.all(
                          width: 1,
                          color: Theme.of(context).colorScheme.surface,
                        )),
                  ),
                  fontSizeDropDown(
                    height: 30.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              // const Gap(11),
              GestureDetector(
                onTap: () => bookmarkCtrl
                        .isBookmarked(bookNumber, page.pageNumber)
                        .value
                    ? bookmarkCtrl.removeBookmark(bookNumber, page.pageNumber)
                    : bookmarkCtrl
                        .addBookmark(
                          booksCtrl.state.booksList[bookNumber - 1].bookName,
                          page.title,
                          page.content,
                          page.pageNumber,
                          bookNumber,
                          booksCtrl.state.booksList[bookNumber - 1].bookType,
                          -1,
                        )
                        .then((_) => context.showCustomErrorSnackBar(
                            'addBookmark'.tr,
                            isDone: true)),
                child: Container(
                  height: 30,
                  width: 30,
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.surface,
                      )),
                  child: GetBuilder<BookmarksController>(
                    builder: (bookmarkCtrl) => customSvgWithColor(
                        bookmarkCtrl
                                .isBookmarked(bookNumber, page.pageNumber)
                                .value
                            ? SvgPath.svgBookmarked
                            : SvgPath.svgBookmark,
                        height: 22,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
              const Gap(11),
            ],
          ),
        ),
      ],
    );
  }
}
