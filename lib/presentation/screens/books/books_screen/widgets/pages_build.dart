import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/widgets/beige_container.dart';
import '../../../../controllers/books_controller.dart';
import '../../widgets/select_menu.dart';
import '/presentation/controllers/general_controller.dart';

class PagesBuild extends StatelessWidget {
  final int chapterNumber;

  const PagesBuild({super.key, required this.chapterNumber});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BooksController>();
    final book = bookCtrl.currentBook!.pages![chapterNumber];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: SelectMenu(
          index: book.pageNumber!,
          poem: book,
          chapters: book,
          book: bookCtrl.currentBook!,
          myWidget: GestureDetector(
            onLongPress: () {
              // audioCtrl.poemNumber.value = book.pageNumber!;
              // bookCtrl.poemSelect(index);
            },
            onTap: () {
              // audioCtrl.poemNumber.value = book.poemNumber!;
              bookCtrl.selectedPoemIndex.value = -1;
            },
            child: BeigeContainer(
              width: MediaQuery.sizeOf(context).width,
              // color: bookCtrl.colorSelection(context, index),
              myWidget: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 4.0),
                  child: Column(
                    children: [
                      Obx(() {
                        return Text(
                          book.pageText!,
                          style: TextStyle(
                              fontSize:
                                  sl<GeneralController>().fontSizeArabic.value,
                              fontFamily: 'naskh',
                              color: Theme.of(context).primaryColorLight,
                              height: 2),
                          textAlign: TextAlign.justify,
                        );
                      }),
                      Text(
                        sl<GeneralController>()
                            .arabicNumbers
                            .convert(book.pageNumber!),
                        style: TextStyle(
                            fontSize: 24,
                            fontFamily: 'naskh',
                            color: Theme.of(context).primaryColorLight,
                            height: 2),
                        textAlign: TextAlign.justify,
                      )
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
