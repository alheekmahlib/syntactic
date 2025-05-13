import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '/presentation/screens/all_books/controller/extensions/books_getters.dart';
import '/presentation/screens/all_books/controller/extensions/books_ui.dart';
import '../../../../../core/widgets/beige_container.dart';
import '../../controller/audio/audio_controller.dart';
import '../../controller/books_controller.dart';
import 'poem_bookmark_widget.dart';
import 'select_menu.dart';

class PoemsBuild extends StatelessWidget {
  final int chapterNumber;

  PoemsBuild({super.key, required this.chapterNumber});
  final bookCtrl = AllBooksController.instance;
  final audioCtrl = AudioController.instance;

  @override
  Widget build(BuildContext context) {
    final bookNumber =
        bookCtrl.state.booksList[bookCtrl.state.bookNumber.value].bookNumber;
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        children: List.generate(
            bookCtrl.currentPoemBook!.chapters![chapterNumber].poems!.length,
            (index) {
          final poem = bookCtrl.currentPoemBook!.chapters![chapterNumber];
          return Obx(() {
            return SelectMenu(
              index: index,
              poemNumber: poem.poems![index].poemNumber!,
              poem: poem.poems![index],
              chapters: poem,
              poemBook: bookCtrl.currentPoemBook!,
              chapterNumber: chapterNumber,
              myWidget: GestureDetector(
                // onLongPress: () {
                //   audioCtrl.state.poemNumber.value =
                //       poem.poems![index].poemNumber!;
                //   bookCtrl.poemSelect(index);
                // },
                // onTap: () {
                //   audioCtrl.state.poemNumber.value =
                //       poem.poems![index].poemNumber!;
                //   bookCtrl.state.selectedPoemIndex.value = -1;
                // },
                child: BeigeContainer(
                  width: MediaQuery.sizeOf(context).width,
                  color: bookCtrl.colorSelection(context, index),
                  myWidget: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: PoemsBookmarkWidget(
                            poemIndex: poem.poems![index].poemNumber!,
                            bookNumber: bookNumber),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  poem.poems![index].firstPoem!,
                                  style: TextStyle(
                                    fontSize: 22.0.sp,
                                    fontFamily: 'naskh',
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  poem.poems![index].secondPoem!,
                                  style: TextStyle(
                                    fontSize: 22.0.sp,
                                    fontFamily: 'naskh',
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            );
          });
        }),
      ),
    );
  }
}
