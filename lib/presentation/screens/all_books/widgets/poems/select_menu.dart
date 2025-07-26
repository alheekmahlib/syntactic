import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_menu/pie_menu.dart';

import '/core/utils/constants/extensions/svg_extensions.dart';
import '/presentation/screens/all_books/controller/extensions/books_ui.dart';
import '../../../../../core/utils/constants/extensions/custom_error_snack_bar.dart';
import '../../../../../core/utils/constants/svg_constants.dart';
import '../../../../../core/widgets/share/share_options.dart';
import '../../../../controllers/bookmarks_controller.dart';
import '../../controller/audio/audio_controller.dart';
import '../../controller/books_controller.dart';
import '../../data/models/poem_model.dart';

class SelectMenu extends StatelessWidget {
  final int index;
  final int poemNumber;
  final Poem poem;
  final Chapter chapters;
  final PoemBook poemBook;
  final int chapterNumber;
  final Widget myWidget;
  SelectMenu(
      {super.key,
      required this.index,
      required this.poemNumber,
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
        longPressDuration: const Duration(milliseconds: 500),
        hoverDuration: const Duration(milliseconds: 500),

        longPressShowsMenu: true,
        regularPressShowsMenu: false,
        radius: 50,
        buttonSize: 45,
        customAngle: 90,
        overlayColor:
            Theme.of(context).colorScheme.secondary.withValues(alpha: .8),
        buttonThemeHovered: PieButtonTheme(
            backgroundColor:
                Theme.of(context).colorScheme.surface.withValues(alpha: .8),
            iconColor: Colors.transparent),
        pointerColor: Theme.of(context).colorScheme.surface,
        // overlayColor: Colors.transparent,
        rightClickShowsMenu: false,
      ),
      onPressed: () {
        bookCtrl.state.selectedPoemIndex.value = poemNumber;
        bookCtrl.state.selectedPoemIndex.value = -1;
      },
      onToggle: (menu) {
        bookCtrl.state.selectedPoemIndex.value = poemNumber;
        bookCtrl.poemSelect(index);
      },
      actions: [
        _customPieAction(context, onSelect: () async {
          bookCtrl.state.selectedPoemIndex.value = -1;
          await showShareOptionsBottomSheet(
            context,
            bookName: book.bookName,
            chapterTitle: chapters.chapterTitle!,
            firstPoem: poem.firstPoem!,
            secondPoem: poem.secondPoem!,
            pageText: '',
            pageNumber: 1,
            poemsList: chapters.poems, // إضافة قائمة الأبيات الشعرية كاملة
          );
        }, svgPath: SvgPath.svgShareAndCopy, height: 25),
        _customPieAction(context, onSelect: () {
          bookCtrl.state.selectedPoemIndex.value = -1;

          bookCtrl.copyPoem(
            context,
            poem.firstPoem!,
            poem.secondPoem!,
            chapters.chapterTitle!,
            book.bookName,
          );
        }, svgPath: SvgPath.svgCopy),
        _customPieAction(context, onSelect: () {
          bookCtrl.state.selectedPoemIndex.value = -1;
          bookmarkCtrl.isPoemBookmarked(book.bookNumber, poem.poemNumber!).value
              ? bookmarkCtrl.removeBookmark(book.bookNumber, chapterNumber)
              : bookmarkCtrl
                  .addBookmark(
                    book.bookName,
                    chapters.chapterTitle!,
                    poem.firstPoem!,
                    chapterNumber,
                    book.bookNumber,
                    book.bookType,
                    poemNumber,
                  )
                  .then((value) => context
                      .showCustomErrorSnackBar('addBookmark'.tr, isDone: true));
          log('bookCtrl.bookNumber.value ${book.bookNumber}');
          bookmarkCtrl.update();
        }, svgPath: SvgPath.svgBookmark),
        _customPieAction(context, onSelect: () async {
          // if (ConnectivityService.instance.noConnection.value) {
          //   Get.context!.showCustomErrorSnackBar('noInternet'.tr);
          // } else {
          audioCtrl.state.poemNumber.value = poem.poemNumber!;
          // audioCtrl.createPlayList();
          audioCtrl.state.audioWidgetPosition.value = 0.0;

          await audioCtrl.changeAudioSource();
          await audioCtrl.togglePlayPause();
          // }
          // bookCtrl.state.selectedPoemIndex.value = -1;
        }, svgPath: SvgPath.svgPlay),
      ],
      child: myWidget,
    );
  }

  PieAction _customPieAction(BuildContext context,
      {required Function() onSelect, required String svgPath, double? height}) {
    return PieAction(
      buttonTheme: PieButtonTheme(
          backgroundColor: Theme.of(context).colorScheme.surface,
          iconColor: Colors.transparent),
      tooltip: const Text(''),
      onSelect: onSelect,
      child: customSvgWithColor(svgPath,
          height: height ?? 22, color: Theme.of(context).colorScheme.secondary),
    );
  }
}
