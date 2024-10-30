import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_menu/pie_menu.dart';

import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '/core/utils/constants/extensions/svg_extensions.dart';
import '/presentation/screens/all_books/controller/extensions/books_ui.dart';
import '../../../../../core/services/connectivity_service.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../../core/widgets/share/share_options.dart';
import '../../../../controllers/bookmarks_controller.dart';
import '../../controller/audio/audio_controller.dart';
import '../../controller/books_controller.dart';
import '../../data/models/poem_model.dart';

class SelectMenu extends StatelessWidget {
  final int index;
  final Poem poem;
  final Chapter chapters;
  final PoemBook poemBook;
  final int chapterNumber;
  final Widget myWidget;
  SelectMenu(
      {super.key,
      required this.index,
      required this.poem,
      required this.chapters,
      required this.poemBook,
      required this.myWidget,
      required this.chapterNumber});
  final bookCtrl = AllBooksController.instance;
  final audioCtrl = AudioController.instance;
  final bookmarkCtrl = BookmarksController.instance;

  @override
  Widget build(BuildContext context) {
    final book = bookCtrl.state.booksList[bookCtrl.state.bookNumber.value];
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
            bookCtrl.state.selectedPoemIndex.value = -1;
            await showShareOptionsBottomSheet(
              context,
              bookName: book.bookName,
              chapterTitle: chapters.chapterTitle!,
              firstPoem: poem.firstPoem!,
              secondPoem: poem.secondPoem!,
              pageText: '',
              pageNumber: 1,
            );
          },
          child: customSvgWithColor(SvgPath.svgShare,
              height: 22, color: Theme.of(context).colorScheme.secondary),
        ),
        PieAction(
          buttonTheme: PieButtonTheme(
              backgroundColor: Theme.of(context).colorScheme.surface,
              iconColor: Colors.transparent),
          tooltip: const Text(''),
          onSelect: () {
            bookCtrl.state.selectedPoemIndex.value = -1;

            bookCtrl.copyPoem(
              context,
              poem.firstPoem!,
              poem.secondPoem!,
              chapters.chapterTitle!,
              book.bookName,
            );
          },
          child: customSvgWithColor(SvgPath.svgCopy,
              height: 22, color: Theme.of(context).colorScheme.secondary),
        ),
        PieAction(
          buttonTheme: PieButtonTheme(
              backgroundColor: Theme.of(context).colorScheme.surface,
              iconColor: Colors.transparent),
          tooltip: const Text(''),
          onSelect: () {
            bookCtrl.state.selectedPoemIndex.value = -1;
            bookmarkCtrl
                    .isPoemBookmarked(book.bookNumber, poem.poemNumber!)
                    .value
                ? bookmarkCtrl.removeBookmark(book.bookNumber, chapterNumber)
                : bookmarkCtrl
                    .addBookmark(
                      book.bookName,
                      chapters.chapterTitle!,
                      poem.firstPoem!,
                      chapterNumber,
                      book.bookNumber,
                      book.bookType,
                      index,
                    )
                    .then((value) => context.showCustomErrorSnackBar(
                        'addBookmark'.tr,
                        isDone: true));
            print('bookCtrl.bookNumber.value ${book.bookNumber}');
            bookmarkCtrl.update();
          },
          child: customSvgWithColor(SvgPath.svgBookmark,
              height: 22, color: Theme.of(context).colorScheme.secondary),
        ),
        PieAction(
          buttonTheme: PieButtonTheme(
              backgroundColor: Theme.of(context).colorScheme.surface,
              iconColor: Colors.transparent),
          tooltip: const Text(''),
          onSelect: () async {
            if (ConnectivityService.instance.noConnection.value) {
              Get.context!.showCustomErrorSnackBar('noInternet'.tr);
            } else {
              audioCtrl.state.poemNumber.value = poem.poemNumber!;
              // audioCtrl.createPlayList();
              audioCtrl.state.audioWidgetPosition.value = 0.0;

              await audioCtrl
                  .changeAudioSource()
                  .then((_) async => await audioCtrl.state.audioPlayer.play());
            }
            // bookCtrl.state.selectedPoemIndex.value = -1;
          },
          child: customSvgWithColor(SvgPath.svgPlay,
              height: 22, color: Theme.of(context).colorScheme.secondary),
        ),
      ],
      child: myWidget,
    );
  }
}
