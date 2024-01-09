import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syntactic/presentation/controllers/general_controller.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../controllers/books_controller.dart';
import '../../widgets/select_menu.dart';

class PagesBuild extends StatelessWidget {
  final int chapterNumber;

  const PagesBuild({super.key, required this.chapterNumber});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BooksController>();
    final book = bookCtrl.book.value!.pages![chapterNumber];
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: SelectMenu(
        index: book.pageNumber!,
        poem: book,
        chapters: book,
        myWidget: GestureDetector(
          onLongPress: () {
            // audioCtrl.poemNumber.value = book.pageNumber!;
            // bookCtrl.poemSelect(index);
          },
          onTap: () {
            // audioCtrl.poemNumber.value = book.poemNumber!;
            bookCtrl.selectedPoemIndex.value = -1;
          },
          child: beigeContainer(
            context,
            width: MediaQuery.sizeOf(context).width,
            // color: bookCtrl.colorSelection(context, index),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Obx(() {
                  return Text(
                    book.pageText!,
                    style: TextStyle(
                        fontSize: sl<GeneralController>().fontSizeArabic.value,
                        fontFamily: 'naskh',
                        color: Theme.of(context).primaryColorLight,
                        height: 2),
                    textAlign: TextAlign.justify,
                  );
                })),
          ),
        ),
      ),
    );
  }
}
