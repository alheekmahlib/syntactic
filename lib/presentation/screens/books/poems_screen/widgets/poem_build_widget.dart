import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:syntactic/core/widgets/widgets.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/utils/constants/svg_picture.dart';
import '../../../../controllers/books_controller.dart';
import '../screens/details_poem_screen.dart';

class PoemBuildWidget extends StatelessWidget {
  const PoemBuildWidget({super.key});

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
                'poetry'.tr,
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
          return bookCtrl.poemBooks.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Wrap(
                  alignment: WrapAlignment.center,
                  children: List.generate(
                    bookCtrl.poemBooks.length,
                    (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: GestureDetector(
                          onTap: () {
                            bookCtrl.loadPoemBooks = true;
                            bookCtrl.bookNumber.value = index;
                            bookCtrl.loadBook();
                            Get.to(
                                DetailsPoemScreen(
                                  bookNumber: index + 1,
                                  bookName: bookCtrl.poemBooks[index].name,
                                ),
                                transition: Transition.downToUp);
                            bookCtrl.currentBookName.value =
                                bookCtrl.poemBooks[index].name;
                          },
                          child: SizedBox(
                            height: 160.h,
                            width: 100.w,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Hero(
                                    tag:
                                        'book-tag:${bookCtrl.poemBooks[index].name}',
                                    child: book_cover(context,
                                        index: index + 1,
                                        height: 138.h,
                                        width: 176.w)),
                                SizedBox(
                                  height: 90.h,
                                  width: 90.w,
                                  child: Text(
                                    bookCtrl.poemBooks[index].name,
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
