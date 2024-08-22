import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../controllers/books_controller.dart';
import '../screens/details_books_screen.dart';

class BookBuildWidget extends StatelessWidget {
  const BookBuildWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BooksController>();
    return Column(
      children: [
        const Gap(32),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.all(Radius.circular(4))),
              child: Text(
                'books'.tr,
                style: TextStyle(
                  fontSize: 14.0,
                  fontFamily: 'kufi',
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            hDivider(context, width: MediaQuery.sizeOf(context).width * .5)
          ],
        ),
        Obx(() {
          return bookCtrl.books.isEmpty
              ? const Center(child: CircularProgressIndicator.adaptive())
              : Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    bookCtrl.books.length,
                    (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: GestureDetector(
                          onTap: () {
                            bookCtrl.loadPoemBooks = false;
                            bookCtrl.currentBookName.value =
                                bookCtrl.books[index].name;
                            Get.to(
                                () => DetailsBooksScreen(
                                      bookNumber: index + 1,
                                      bookName: bookCtrl.books[index].name,
                                    ),
                                transition: Transition.downToUp);
                            bookCtrl.currentBookName.value =
                                bookCtrl.books[index].name;
                          },
                          child: SizedBox(
                            height: 160.h,
                            width: 100.w,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Hero(
                                    tag:
                                        'book-tag:${bookCtrl.books[index].name}',
                                    child: book_cover(context,
                                        index: index + 1,
                                        height: 138.h,
                                        width: 176.w)),
                                SizedBox(
                                  height: 90,
                                  width: 90,
                                  child: Text(
                                    bookCtrl.books[index].name,
                                    style: TextStyle(
                                        fontSize: 16.0.sp,
                                        fontFamily: 'kufi',
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        height: 1.5),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                );
        }),
      ],
    );
  }
}
