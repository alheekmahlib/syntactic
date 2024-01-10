import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/beige_container.dart';
import '../../../../core/widgets/white_container.dart';
import '../../../controllers/books_controller.dart';
import '../poems_screen/screens/poems_read_view.dart';

class ChaptersBuild extends StatelessWidget {
  const ChaptersBuild({super.key});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BooksController>();
    return Obx(() {
      return Stack(
        children: [
          BeigeContainer(
              color: Theme.of(context).colorScheme.surface.withOpacity(.15),
              myWidget: Column(
                children: [
                  Container(
                    height: 32,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(4))),
                    child: Text(
                      'chapterBook'.tr,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'kufi',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      children: List.generate(
                          bookCtrl.poem.value!.chapters!.length, (index) {
                        final chapter = bookCtrl.poem.value!.chapters![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              bookCtrl.chapterNumber.value = index;
                              Get.to(() => PoemsReadView(
                                    chapterNumber: index,
                                  ));
                            },
                            child: BeigeContainer(
                                color: Theme.of(context).colorScheme.surface,
                                myWidget: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.menu,
                                        size: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                    Expanded(
                                        flex: 9,
                                        child: WhiteContainer(
                                            myWidget: Text(
                                          chapter.chapterTitle!,
                                          style: TextStyle(
                                            fontSize: 18.0.sp,
                                            fontFamily: 'naskh',
                                            fontWeight: FontWeight.w500,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        )))
                                  ],
                                )),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              )),
        ],
      );
    });
  }
}
