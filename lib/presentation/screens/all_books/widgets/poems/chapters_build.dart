import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_getters.dart';

import '../../../../../core/widgets/beige_container.dart';
import '../../../../../core/widgets/white_container.dart';
import '../../controller/books_controller.dart';
import '../../screens/poems_read_view.dart';

class ChaptersBuild extends StatelessWidget {
  final int bookNumber;
  const ChaptersBuild({super.key, required this.bookNumber});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = AllBooksController.instance;
    return Obx(() {
      return Stack(
        children: [
          BeigeContainer(
              color:
                  Theme.of(context).colorScheme.surface.withValues(alpha: .15),
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
                          bookCtrl.currentPoemBook!.chapters!.length, (index) {
                        final chapter =
                            bookCtrl.currentPoemBook!.chapters![index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          child: GestureDetector(
                            onTap: () {
                              bookCtrl.state.chapterNumber.value = index;
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
                                            fontSize: 22.0,
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
