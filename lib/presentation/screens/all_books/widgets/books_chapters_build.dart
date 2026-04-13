import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/presentation/screens/all_books/controller/extensions/books_getters.dart';
import '/presentation/screens/all_books/controller/extensions/books_ui.dart';
import '../../../../core/utils/helpers/app_text_styles.dart';
import '../controller/books_controller.dart';
import '../data/models/part_model.dart';

class BooksChapterBuild extends StatelessWidget {
  final int bookNumber;
  final String bookType;

  BooksChapterBuild(
      {super.key, required this.bookNumber, required this.bookType});

  final booksCtrl = AllBooksController.instance;

  @override
  Widget build(BuildContext context) {
    final parts = booksCtrl.getParts(bookNumber, bookType);
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: .15),
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Column(
              children: [
                Container(
                  height: 32,
                  width: 200,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.all(Radius.circular(4))),
                  child: Text(
                    'chapterBook'.tr,
                    style: AppTextStyles.titleSmall(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    children: List.generate(parts.length, (index) {
                      final part = parts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: booksCtrl.isBookHasPart(parts).value
                            ? dividedIntoParts(context, part)
                            : chapterBuild(context, part),
                      );
                    }),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Widget dividedIntoParts(BuildContext context, Part part) {
    return ExpansionTile(
      collapsedIconColor: Theme.of(context).colorScheme.inversePrimary,
      collapsedBackgroundColor:
          Theme.of(context).colorScheme.surface.withValues(alpha: .1),
      backgroundColor:
          Theme.of(context).colorScheme.surface.withValues(alpha: .1),
      title: Text(
        part.partName,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'kufi',
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
      ),
      children: [chapterBuild(context, part)],
    );
  }

  Widget chapterBuild(BuildContext context, Part part) {
    return Column(
      children: part.chapters
          .map((chapter) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: GestureDetector(
                  onTap: () => booksCtrl.moveToBookPage(
                    chapter.chapterFirstPageNum - 1,
                    bookNumber,
                    type: bookType,
                  ),
                  child: GetBuilder<AllBooksController>(
                    builder: (booksCtrl) => Opacity(
                      opacity:
                          booksCtrl.isBookDownloaded(bookType, bookNumber).value
                              ? 1
                              : .5,
                      child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surface
                                  .withValues(alpha: .6),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.menu,
                                  size: 20,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                              Expanded(
                                  flex: 9,
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 4.0),
                                      child: Text(
                                        chapter.chapterName,
                                        style: AppTextStyles.titleSmall(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                        ),
                                        textAlign: TextAlign.justify,
                                      )))
                            ],
                          )),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}
