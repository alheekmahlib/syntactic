import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/services/services_locator.dart';
import '../../../../../core/widgets/beige_container.dart';
import '../../../../../core/widgets/white_container.dart';
import '../../../../controllers/books_controller.dart';
import '../screens/books_read_view.dart';

class BooksChapterBuild extends StatelessWidget {
  const BooksChapterBuild({super.key});

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
                          bookCtrl.currentBook!.pages!.length, (index) {
                        final chapter = bookCtrl.currentBook!.pages![index];
                        if (chapter.chapterTitle != null &&
                            chapter.chapterTitle!.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 4.0),
                            child: GestureDetector(
                              onTap: () {
                                bookCtrl.chapterNumber.value = index;
                                Get.to(() => BooksReadView(
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
                        } else {
                          return const SizedBox.shrink();
                        }
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
