import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/presentation/screens/all_books/controller/books_controller.dart';
import '/presentation/screens/all_books/controller/extensions/books_ui.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/beige_container.dart';

class LastRead extends StatelessWidget {
  LastRead({super.key});
  final bookCtrl = sl<AllBooksController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: BeigeContainer(
        // height: 125,
        width: Get.width,
        color: Theme.of(context).colorScheme.surface.withValues(alpha: .15),
        myWidget: Row(
          children: [
            Expanded(
              flex: 1,
              child: RotatedBox(
                quarterTurns: 1,
                child: Container(
                  height: 32,
                  width: 130,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    'lastRead'.tr,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'kufi',
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Obx(() {
                var lastReadBooks = bookCtrl.state.booksList.where((book) {
                  return bookCtrl.state.lastReadPage
                      .containsKey(book.bookNumber);
                }).toList();
                return lastReadBooks.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
                            width: Get.width,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: lastReadBooks.length,
                              itemBuilder: (context, index) {
                                var book = lastReadBooks[index];
                                var currentPage = bookCtrl
                                        .state.lastReadPage[book.bookNumber] ??
                                    0;
                                var totalPages = bookCtrl.state
                                        .bookTotalPages[book.bookNumber] ??
                                    1;
                                var progress = currentPage / totalPages;

                                return GestureDetector(
                                  onTap: () => bookCtrl.moveToBookPage(
                                    currentPage,
                                    book.bookNumber,
                                    type: book.bookType,
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    width: 70,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withValues(alpha: .15),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Text(
                                          book.bookName,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            fontFamily: 'kufi',
                                            color: Theme.of(context).hintColor,
                                            height: 1.5,
                                          ),
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.rtl,
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: LinearProgressIndicator(
                                            minHeight: 10,
                                            value: progress,
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              bottomRight: Radius.circular(8),
                                            ),
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .primary
                                                .withValues(alpha: .15),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface
                                                .withValues(alpha: .5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'notAvailable'.tr,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: 'kufi',
                          color: Theme.of(context).hintColor,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                      );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
