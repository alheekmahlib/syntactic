import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_getters.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_storage_getters.dart';
import 'package:path_provider/path_provider.dart';

import '/core/utils/constants/extensions/custom_error_snackBar.dart';
import '../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../../screens/poems_read_view.dart';
import '../../screens/read_view_screen.dart';
import '../books_controller.dart';

extension BooksUi on AllBooksController {
  /// -------- [onTap] --------
  void moveToBookPage(int pageNumber, int bookNumber, {String? type}) {
    if (isBookDownloaded(type!, bookNumber).value) {
      // int initialPage =
      //     await getChapterStartPage(bookNumber, chapterPage, isLocal);
      state.currentPageIndex.value = pageNumber;
      state.bookNumber.value = bookNumber - 1;
      // log('Initial page for chapter $chapterPage: $initialPage');
      Get.to(() => type == 'book' || type == 'explanation'
          ? BookReadView(bookNumber: bookNumber)
          : PoemsReadView(
              chapterNumber: pageNumber,
            ));
    } else {
      Get.context!.showCustomErrorSnackBar('downloadBookFirst'.tr);
    }
  }

  void isTashkilOnTap() {
    state.isTashkil.value = !state.isTashkil.value;
    state.box.write(IS_TASHKIL, state.isTashkil.value);
  }

  Future<void> deleteBook(int bookNumber, String type) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$bookNumber.json');
      if (await file.exists()) {
        await file.delete();
        state.downloadedBooksByType[type]![bookNumber] = false;
        saveDownloadedBooks();
        log('Book $bookNumber deleted successfully.');

        // حذف آخر قراءة خاصة بالكتاب
        state.box.remove('lastRead_$bookNumber');
        state.lastReadPage.remove(bookNumber);
        state.bookTotalPages.remove(bookNumber);
        update();
        Get.context!.showCustomErrorSnackBar('booksDeleted'.tr);
        log('Last read data for book $bookNumber deleted successfully.');
      }
    } catch (e) {
      log('Error deleting book: $e');
    }
  }

  KeyEventResult controlRLByKeyboard(FocusNode node, KeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      state.bPageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      state.bPageController.previousPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void poemSelect(int index) {
    if (state.selectedPoemIndex.value == index) {
      state.selectedPoemIndex.value = index;
    } else if (index == 0 || index.isEven) {
      state.selectedPoemIndex.value = index;
    } else if (index == 1 || index.isOdd) {
      state.selectedPoemIndex.value = index;
    }
  }

  Color colorSelection(BuildContext context, int index) {
    return index == state.selectedPoemIndex.value
        ? Theme.of(context).colorScheme.surface.withOpacity(.2)
        : Colors.transparent;
  }

  Future<void> copyPoem(BuildContext context, String poemTextOne,
      String poemTextTwo, String chapterText, String bookName) async {
    await Clipboard.setData(ClipboardData(
            text: '$bookName\n$chapterText\n\n$poemTextOne\n$poemTextTwo'))
        .then((value) =>
            Get.context!.showCustomErrorSnackBar('copied'.tr, isDone: true));
  }

  // KeyEventResult controlUDByKeyboard(FocusNode node, KeyEvent event) {
  //   if (state.ScrollUpDownBook.hasClients) {
  //     if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
  //       state.ScrollUpDownBook.animateTo(
  //         state.ScrollUpDownBook.offset - 100,
  //         duration: const Duration(milliseconds: 600),
  //         curve: Curves.easeInOut,
  //       );
  //       return KeyEventResult.handled;
  //     } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
  //       state.ScrollUpDownBook.animateTo(
  //         state.ScrollUpDownBook.offset + 100,
  //         duration: const Duration(milliseconds: 600),
  //         curve: Curves.easeInOut,
  //       );
  //       return KeyEventResult.handled;
  //     }
  //   }
  //   return KeyEventResult.ignored;
  // }
}
