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

  RxBool isBookDownloaded(String type, int bookNumber) {
    return (state.downloadedBooksByType[type]?[bookNumber] ?? false).obs;
  }

  RxBool collapsedHeight(int bookNumber, String type) =>
      getParts(bookNumber, type).length < 4 ? true.obs : false.obs;

  Book? get currentBook => state.books.firstWhereOrNull(
      (book) => book.bookNumber == state.currentPageIndex.value);

  poem_model.PoemBook? get currentPoemBook =>
      state.loadedPoems.firstWhereOrNull(
          (book) => book.bookNumber == state.bookNumber.value - 1);

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

  /// التأكد من أن القائمة تحتوي على أكثر من جزء (للتحقق من وجود أجزاء متعددة)
  /// Ensure the list has more than one part (to check for multiple parts)
  RxBool isBookHasPart(List<Part> parts) {
    return parts.length > 1 ? true.obs : false.obs;
  }

  /// الحصول على الجزء المناسب بناءً على رقم الصفحة والكتاب مع معالجة تجاوز آخر صفحة
  /// Get the correct part based on page number and book number, handle if page exceeds last page
  Part getPartByPageNumber(int bookNumber, int pageNumber) {
    final book = state.booksList[bookNumber - 1];
    final parts = getParts(bookNumber, book.bookType);

    // إذا تجاوز رقم الصفحة آخر صفحة في الكتاب، أرجع الجزء الأخير مباشرة
    // If page number exceeds last page, return last part directly
    if (parts.isNotEmpty && pageNumber > (book.pageTotal ?? 0)) {
      log('رقم الصفحة $pageNumber تجاوز آخر صفحة في الكتاب $bookNumber، سيتم إرجاع الجزء الأخير',
          name: 'BooksGetters');
      return parts.last;
    }

    final partIndex = parts.indexWhere((p) {
      final firstPNum = p.partFirstPageNum;
      final lastPNum = p.partLastPageNum;
      return pageNumber >= firstPNum && pageNumber <= lastPNum;
    });

    if (partIndex == -1) {
      log('لم يتم العثور على جزء مناسب لرقم الصفحة $pageNumber في الكتاب $bookNumber',
          name: 'BooksGetters');
      // إذا لم يتم العثور على جزء مناسب، أرجع الجزء الأخير إذا الصفحة بعد النهاية، أو الأول إذا قبل البداية
      // If not found, return last part if after end, or first part if before start
      if (parts.isEmpty) {
        throw Exception(
            'No part found for page $pageNumber in book $bookNumber');
      }
      if (pageNumber > parts.last.partLastPageNum) {
        return parts.last;
      }
      if (pageNumber < parts.first.partFirstPageNum) {
        return parts.first;
      }
      return parts.first;
    }
    return parts[partIndex];
  }

  /// الحصول على الفصل المناسب بناءً على رقم الصفحة والكتاب مع معالجة تجاوز آخر صفحة
  /// Get the correct chapter based on page and book number, handle if page exceeds last page
  Chapter getChaptersByPage(int bookNumber, int pageNumber) {
    final part = getPartByPageNumber(bookNumber, pageNumber);
    final chapters = part.chapters;
    final chapterIndex = chapters.indexWhere((c) {
      return pageNumber >= c.chapterFirstPageNum &&
          pageNumber <= c.chapterEndPageNum;
    });

    if (chapterIndex == -1) {
      log('لم يتم العثور على فصل مناسب لرقم الصفحة $pageNumber في الكتاب $bookNumber',
          name: 'BooksGetters');
      if (chapters.isEmpty) {
        throw Exception(
            'No chapter found for page $pageNumber in book $bookNumber');
      }
      // إذا تجاوز رقم الصفحة نهاية آخر فصل، أرجع الفصل الأخير
      // If page number exceeds last chapter, return last chapter
      if (pageNumber > chapters.last.chapterEndPageNum) {
        return chapters.last;
      }
      // إذا كان قبل أول فصل، أرجع الأول
      // If before first chapter, return first
      if (pageNumber < chapters.first.chapterFirstPageNum) {
        return chapters.first;
      }
      return chapters.first;
    }
    return chapters[chapterIndex];
  }
}
