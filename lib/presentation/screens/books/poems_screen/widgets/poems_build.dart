import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syntactic/presentation/controllers/audio_controller.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/widgets/beige_container.dart';
import '../../../../controllers/books_controller.dart';
import '../../widgets/select_menu.dart';
import 'poem_bookmark_widget.dart';

class PoemsBuild extends StatelessWidget {
  final int chapterNumber;

  const PoemsBuild({super.key, required this.chapterNumber});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BooksController>();
    final audioCtrl = sl<AudioController>();
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        children: List.generate(
            bookCtrl.currentPoemBook!.chapters![chapterNumber].poems!.length,
            (index) {
          final poem = bookCtrl.currentPoemBook!.chapters![chapterNumber];
          return Obx(() {
            return SelectMenu(
              index: poem.poems![index].poemNumber!,
              poem: poem.poems![index],
              chapters: poem,
              poemBook: bookCtrl.currentPoemBook!,
              myWidget: GestureDetector(
                onLongPress: () {
                  audioCtrl.poemNumber.value = poem.poems![index].poemNumber!;
                  bookCtrl.poemSelect(index);
                },
                onTap: () {
                  audioCtrl.poemNumber.value = poem.poems![index].poemNumber!;
                  bookCtrl.selectedPoemIndex.value = -1;
                },
                child: BeigeContainer(
                  width: MediaQuery.sizeOf(context).width,
                  color: bookCtrl.colorSelection(context, index),
                  myWidget: Stack(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: PoemsBookmarkWidget(
                            poemIndex: poem.poems![index].poemNumber! - 1,
                            bookType: bookCtrl.currentPoemBook!.bookType!),
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
