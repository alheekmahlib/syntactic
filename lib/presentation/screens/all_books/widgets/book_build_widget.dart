import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/utils/constants/svg_picture.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/general_controller.dart';
import '../controller/books_controller.dart';
import '../data/models/books_model.dart';
import '../screens/chapters_screen.dart';

class BookBuildWidget extends StatelessWidget {
  final String title;
  final List<Book> booksList;
  final bool showAllBooks;
  final int section;
  final bool isFirst;
  BookBuildWidget(
      {super.key,
      required this.title,
      required this.booksList,
      required this.showAllBooks,
      required this.section,
      required this.isFirst});

  final bookCtrl = AllBooksController.instance;
  final generalCtrl = GeneralController.instance;

  @override
  Widget build(BuildContext context) {
    // final bookCtrl = sl<BooksController>();
    return Column(
      children: [
        isFirst ? const Gap(32) : const Gap(0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    title.tr,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Expanded(
                  flex: 6,
                  child: hDivider(context,
                      width: MediaQuery.sizeOf(context).width * .5)),
              showAllBooks
                  ? SizedBox.shrink()
                  : Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () => generalCtrl.controller
                            .animateToPage(1,
                                duration: Duration(milliseconds: 400),
                                curve: Curves.easeIn)
                            .then((_) => bookCtrl.state.tabBarController
                                .animateTo(section,
                                    duration: Duration(milliseconds: 400),
                                    curve: Curves.easeIn)),
                        child: Text(
                          'showAll'.tr,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'kufi',
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.surface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ],
          ),
        ),
        Obx(() {
          if (bookCtrl.state.isLoading.value) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return Wrap(
            alignment: WrapAlignment.center,
            children: List.generate(
              showAllBooks ? booksList.length : 2,
              (index) {
                final book = booksList[index];
                return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: GestureDetector(
                      onTap: () {
                        bookCtrl.state.bookNumber.value = index;
                        Get.to(
                            () => ChaptersPage(
                                  bookNumber: book.bookNumber,
                                  bookName: book.bookName,
                                  bookType: book.bookType,
                                  aboutBook: book.aboutBook,
                                ),
                            transition: Transition.downToUp);
                        // bookCtrl.currentBookName.value =
                        //     bookCtrl.books[index].name;
                      },
                      child: SizedBox(
                        height: 160.h,
                        width: 100.w,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Hero(
                                tag: 'book-tag:${book.bookNumber}',
                                child: book_cover(context,
                                    index: index + 1,
                                    height: 138.h,
                                    width: 176.w)),
                            SizedBox(
                              height: 90,
                              width: 90,
                              child: Text(
                                book.bookName,
                                style: TextStyle(
                                    fontSize: 16.0.sp,
                                    fontFamily: 'kufi',
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    height: 1.5),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            ),
          );
        }),
      ],
    );
  }
}
