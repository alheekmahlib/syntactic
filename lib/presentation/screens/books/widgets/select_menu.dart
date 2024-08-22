import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahawi/core/widgets/widgets.dart';
import 'package:pie_menu/pie_menu.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/share/share_options.dart';
import '../../../controllers/bookmarks_controller.dart';
import '../poems_screen/models/poem_model.dart';
import '/core/utils/constants/svg_picture.dart';
import '/presentation/controllers/audio_controller.dart';
import '/presentation/controllers/books_controller.dart';
import '/presentation/screens/books/books_screen/models/books_model.dart';

class SelectMenu extends StatelessWidget {
  final int index;
  var poem;
  var chapters;
  final BooksModel? book;
  final PoemBook? poemBook;
  final Widget myWidget;
  SelectMenu(
      {super.key,
      required this.index,
      required this.poem,
      required this.chapters,
      this.book,
      this.poemBook,
      required this.myWidget});

  @override
  Widget build(BuildContext context) {
    final bookCtrl = sl<BooksController>();
    final audioCtrl = sl<AudioController>();
    final bookmarkCtrl = sl<BookmarksController>();

    return PieMenu(
      theme: PieTheme(
        delayDuration: const Duration(milliseconds: 500),
        hoverDuration: const Duration(milliseconds: 0),
        radius: 50,
        buttonSize: 45,
        customAngle: 90,
        overlayColor: Theme.of(context).colorScheme.secondary.withOpacity(.8),
        buttonThemeHovered: PieButtonTheme(
            backgroundColor:
                Theme.of(context).colorScheme.surface.withOpacity(.8),
            iconColor: Colors.transparent),
        pointerColor: Theme.of(context).colorScheme.surface,
        // overlayColor: Colors.transparent,
        rightClickShowsMenu: false,
      ),
      actions: [
        PieAction(
          buttonTheme: PieButtonTheme(
              backgroundColor: Theme.of(context).colorScheme.surface,
              iconColor: Colors.transparent),
          tooltip: const Text(''),
          onSelect: () async {
            bookCtrl.selectedPoemIndex.value = -1;
            await showShareOptionsBottomSheet(
              context,
              bookName: bookCtrl.loadPoemBooks
                  ? poemBook!.bookName!
                  : book!.bookName!,
              chapterTitle: chapters.chapterTitle!,
              firstPoem: bookCtrl.loadPoemBooks ? poem.firstPoem! : '',
              secondPoem: bookCtrl.loadPoemBooks ? poem.secondPoem! : '',
              pageText: bookCtrl.loadPoemBooks ? '' : poem.pageText!,
              pageNumber: bookCtrl.loadPoemBooks ? 1 : poem.pageNumber!,
            );
          },
          child: share(context,
              height: 22, color: Theme.of(context).colorScheme.secondary),
        ),
        PieAction(
          buttonTheme: PieButtonTheme(
              backgroundColor: Theme.of(context).colorScheme.surface,
              iconColor: Colors.transparent),
          tooltip: const Text(''),
          onSelect: () {
            bookCtrl.selectedPoemIndex.value = -1;

            bookCtrl.loadPoemBooks
                ? bookCtrl.copyPoem(
                    context,
                    poem.firstPoem!,
                    poem.secondPoem!,
                    chapters.chapterTitle!,
                    poemBook!.bookName!,
                  )
                : bookCtrl.copyBook(
                    context,
                    book!.bookName!,
                    chapters.chapterTitle!,
                    poem.pageText!,
                    poem.pageNumber!.toString());
          },
          child: copy(context,
              height: 22, color: Theme.of(context).colorScheme.secondary),
        ),
        PieAction(
          buttonTheme: PieButtonTheme(
              backgroundColor: Theme.of(context).colorScheme.surface,
              iconColor: Colors.transparent),
          tooltip: const Text(''),
          onSelect: () {
            bookCtrl.selectedPoemIndex.value = -1;
            bookmarkCtrl
                .addBookmark(
                  bookCtrl.currentBookName.value,
                  chapters.chapterTitle!,
                  bookCtrl.loadPoemBooks ? poem.firstPoem! : poem.pageText!,
                  bookCtrl.loadPoemBooks ? bookCtrl.chapterNumber.value : index,
                  bookCtrl.bookNumber.value,
                  bookCtrl.loadPoemBooks
                      ? poemBook!.bookType!
                      : book!.bookType!,
                  bookCtrl.loadPoemBooks ? index : index,
                )
                .then((value) => customSnackBar(context, 'bookmarkAdded'.tr));
            print('bookCtrl.bookNumber.value ${bookCtrl.bookNumber.value}');
            bookmarkCtrl.update();
          },
          child: bookmark_logo(context,
              height: 22, color: Theme.of(context).colorScheme.secondary),
        ),
        if (bookCtrl.loadPoemBooks)
          PieAction(
            buttonTheme: PieButtonTheme(
                backgroundColor: Theme.of(context).colorScheme.surface,
                iconColor: Colors.transparent),
            tooltip: const Text(''),
            onSelect: () {
              audioCtrl.poemNumber.value = poem.poemNumber!;
              // audioCtrl.createPlayList();
              audioCtrl.changeAudioSource(
                  bookCtrl.chapterNumber.value, audioCtrl.poemNumber.value);
              audioCtrl.audioWidgetPosition.value = 0.0;
              // bookCtrl.selectedPoemIndex.value = -1;
            },
            child: play_logo(context,
                height: 22, color: Theme.of(context).colorScheme.secondary),
          ),
      ],
      child: myWidget,
    );
  }
}
