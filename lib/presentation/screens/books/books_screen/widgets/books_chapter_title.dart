import 'package:flutter/material.dart';

import '../../../../../core/services/services_locator.dart';
import '/presentation/controllers/books_controller.dart';

class BooksChapterTitle extends StatelessWidget {
  final int chapterIndex;
  const BooksChapterTitle({super.key, required this.chapterIndex});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BooksController>();
    final chapter = bookCtrl.currentBook!.pages![chapterIndex];
    return chapter.chapterTitle != null && chapter.chapterTitle!.isNotEmpty
        ? Container(
            alignment: Alignment.center,
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(4))),
            child: Text(
              bookCtrl.currentBook!.pages![chapterIndex].chapterTitle!,
              style: TextStyle(
                fontSize: 17.0,
                fontFamily: 'kufi',
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.secondary,
              ),
              textAlign: TextAlign.center,
            ),
          )
        : const SizedBox.shrink();
  }
}
