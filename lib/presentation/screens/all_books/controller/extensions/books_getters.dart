import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/books_model.dart';
import '../../data/models/chapter_model.dart';
import '../../data/models/part_model.dart';
import '../../data/models/poem_model.dart' as poem_model;
import '../books_controller.dart';

extension BooksGetters on AllBooksController {
  /// -------- [Getter] ----------

  PageController get bookPageController {
    return state.bPageController = PageController(
        initialPage: state.currentPageIndex.value, keepPage: true);
  }

  PageController get poemPageController => state.pPageController =
      PageController(initialPage: state.chapterNumber.value);

  bool isBookDownloaded(String type, int bookNumber) {
    return state.downloadedBooksByType[type]?[bookNumber] ?? false;
  }

  RxBool collapsedHeight(int bookNumber, String type) =>
      getParts(bookNumber, type).length < 4 ? true.obs : false.obs;

  Book? get currentBook => state.books.firstWhereOrNull(
      (book) => book.bookNumber == state.currentPageIndex.value);
  poem_model.PoemBook? get currentPoemBook => state.loadedPoems
      .firstWhereOrNull((book) => book.bookNumber == state.bookNumber.value);

  List<int> get poemBookNumbers =>
      state.poemBooks.map((book) => book.bookNumber).toList();

  RxBool get downloadedBooks {
    for (final book in state.booksList) {
      if (state.downloadedBooksByType['explanation']?[book.bookNumber] ==
          true) {
        return true.obs;
      }
    }
    return false.obs;
  }

  RxBool getLocalBooks(int bookNumber) {
    return state.localBooks.contains(bookNumber) ? true.obs : false.obs;
  }

  RxBool isBookHasPart(List<Part> parts) {
    return parts.length > 1 ? true.obs : false.obs;
  }

  // Chapter getCurrentChapter(
  //         int bookNumber, String partNumber, int pageNumber) =>
  //     state.booksList[bookNumber].parts
  //         .where((p) => p.partNumber == partNumber)
  //         .chapters
  //         .firstWhere((c) => c.chapterNumber == pageNumber);

  // String? getChapterNameByPageNumber(int bookNumber, int pageNumber) {
  //   if (bookNumber >= 0 && bookNumber < state.booksList.length) {
  //     Book book = state.booksList[bookNumber - 1];
  //     int currentPage = 1;
  //
  //     for (Part part in book.parts) {
  //       for (Chapter chapter in part.chapters) {
  //         if (pageNumber >= currentPage) {
  //           return chapter.chapterName;
  //         }
  //         currentPage += chapter.pageTotal;
  //       }
  //     }
  //   }
  //   return null;
  // }

  // String? getPartNameByPageNumber(int bookNumber, int pageNumber) {
  //   if (bookNumber >= 0 && bookNumber < state.booksList.length) {
  //     Book book = state.booksList[bookNumber - 1];
  //     int currentPage = 1;
  //
  //     for (Part part in book.parts) {
  //       if (pageNumber >= currentPage) {
  //         return part.partNumber;
  //       }
  //       // currentPage += part.pageTotal;
  //     }
  //   }
  //   return null;
  // }

  Part getPartByPageNumber(int bookNumber, int pageNumber) {
    final book = state.booksList[bookNumber - 1];
    final parts = getParts(bookNumber, book.bookType);

    final partIndex = parts.indexWhere((p) {
      final firstPNum = p.partFirstPageNum;
      final lastPNum = p.partLastPageNum;
      return pageNumber >= firstPNum && pageNumber <= lastPNum;
    });
    if (-1 == partIndex) {
      log('*' * 60);
    }
    // pageNumber >
    //     p.chapters[p.chapters.indexOf(p.chapters.last) - 1].chapterPage);

    // final partI = parts.indexWhere((p) => p.chapters.any(
    //     (c) => c.chapterPage == pageNumber || pageNumber <= c.chapterPage));

    // final partIndex = partI.chapters.indexWhere((c) =>
    //     c.chapterPage == pageNumber + 1 || pageNumber + 1 <= c.chapterPage);

    // log('partIndex: ${parts[partIndex].partNumber}');

    // state.currentPart.value = parts[partIndex];
    //     .firstWhere(
    //   (part) {
    //     return part.chapters.any((chapter) {
    //       return pageNumber <= chapter.chapterPage;
    //     });
    //   },
    //   orElse: () => state.currentPart.value,
    // );
    return parts[partIndex];
  }

  Chapter getChaptersByPage(int bookNumber, int pageNumber) {
    final chapterIndex =
        getPartByPageNumber(bookNumber, pageNumber).chapters.indexWhere((c) {
      return pageNumber >= c.chapterFirstPageNum &&
          pageNumber <= c.chapterEndPageNum;
    });

    // state.currentChapter.value =
    //     getPartByChapterName(bookNumber, pageNumber).chapters[chapterIndex + 1];
    // .firstWhere((c) => pageNumber == c.chapterPage,
    //     orElse: () => state.currentChapter.value);
    // return chapterIndex;
    return getPartByPageNumber(bookNumber, pageNumber).chapters[chapterIndex];
  }
}
