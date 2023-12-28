import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../controllers/books_controller.dart';
import '../screen/read_view.dart';

class ChaptersBuild extends StatelessWidget {
  const ChaptersBuild({super.key});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BooksController>();
    return Stack(
      children: [
        beigeContainer(
            context,
            color: Theme.of(context).colorScheme.surface.withOpacity(.15),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Column(
                children: List.generate(bookCtrl.book.value!.chapters!.length,
                    (index) {
                  final chapter = bookCtrl.book.value!.chapters![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        bookCtrl.chapterNumber.value = index;
                        Get.to(ReadView(
                          chapterNumber: index,
                        ));
                      },
                      child: beigeContainer(
                          context,
                          color: Theme.of(context).colorScheme.surface,
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.menu,
                                  size: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                              Expanded(
                                  flex: 9,
                                  child: whiteContainer(
                                      context,
                                      Text(
                                        chapter.chapterTitle!,
                                        style: TextStyle(
                                          fontSize: 18.0,
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
            )),
        Transform.translate(
          offset: const Offset(-60, -15),
          child: Container(
            height: 32,
            width: 200,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: Text(
              'أبواب الكتاب'.tr,
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'kufi',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
