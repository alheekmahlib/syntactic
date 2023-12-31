import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:syntactic/presentation/controllers/audio_controller.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../controllers/books_controller.dart';
import '../../widgets/select_menu.dart';

class PoemsBuild extends StatelessWidget {
  final int chapterNumber;

  const PoemsBuild({super.key, required this.chapterNumber});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BooksController>();
    final audioCtrl = sl<AudioController>();
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Obx(() {
        return Column(
          children: List.generate(
              bookCtrl.poem.value!.chapters![chapterNumber].poems!.length,
              (index) {
            final poem = bookCtrl.poem.value!.chapters![chapterNumber];
            return SelectMenu(
              index: poem.poems![index].poemNumber!,
              poem: poem.poems![index],
              chapters: poem,
              myWidget: GestureDetector(
                onLongPress: () {
                  audioCtrl.poemNumber.value = poem.poems![index].poemNumber!;
                  bookCtrl.poemSelect(index);
                },
                onTap: () {
                  audioCtrl.poemNumber.value = poem.poems![index].poemNumber!;
                  bookCtrl.selectedPoemIndex.value = -1;
                },
                child: Obx(() {
                  return beigeContainer(
                    context,
                    width: MediaQuery.sizeOf(context).width,
                    color: bookCtrl.colorSelection(context, index),
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
                  );
                }),
              ),
            );
          }),
        );
      }),
    );
  }
}
