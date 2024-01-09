import 'package:flutter/material.dart';
import 'package:pie_menu/pie_menu.dart';

import '../../../../core/services/services_locator.dart';
import '../../../controllers/bookmarks_controller.dart';
import '/core/utils/constants/svg_picture.dart';
import '/presentation/controllers/audio_controller.dart';
import '/presentation/controllers/books_controller.dart';

class SelectMenu extends StatelessWidget {
  final int index;
  var poem;
  var chapters;
  final Widget myWidget;
  SelectMenu(
      {super.key,
      required this.index,
      required this.poem,
      required this.chapters,
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
          onSelect: () {
            bookCtrl.selectedPoemIndex.value = -1;
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
            bookCtrl.copy(context, poem.firstPoem!, poem.secondPoem!,
                chapters.chapterTitle!);
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
            bookmarkCtrl.addBookmark(
                bookCtrl.currentBookName.value,
                chapters.chapterTitle!,
                poem.firstPoem!,
                bookCtrl.chapterNumber.value);
            bookmarkCtrl.update();
          },
          child: bookmark_logo(context,
              height: 22, color: Theme.of(context).colorScheme.secondary),
        ),
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
            audioCtrl.audioWidgetPosition.value = 30.0;
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
