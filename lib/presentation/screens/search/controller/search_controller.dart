import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '/core/utils/constants/extensions/highlight_extension.dart';
import '/presentation/screens/all_books/controller/books_controller.dart';
import '/presentation/screens/all_books/controller/extensions/books_getters.dart';
import '/presentation/screens/search/controller/extensions/search_ui.dart';
import '../../all_books/data/models/books_model.dart';
import '../../all_books/data/models/page_model.dart';
import '../data/models/search_result_model.dart';
import 'search_state.dart';

class SearchControllers extends GetxController
    with GetTickerProviderStateMixin {
  static SearchControllers get instance => Get.isRegistered<SearchControllers>()
      ? Get.find<SearchControllers>()
      : Get.put(SearchControllers());
  final booksCtrl = AllBooksController.instance;
  SearchState state = SearchState();

  @override
  void onInit() {
    state.pagingController = PagingController<int, PageContent>(
      firstPageKey: 0,
    );
    state.pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
    state.tabController = TabController(length: 3, vsync: this);
    state.tabController.addListener(() {
      if (state.tabController.index == 0) {
        state.bookType.value = 'poemBooks';
        if (state.searchController.text.isNotEmpty) {
          searchPoems(state.searchController.text);
        }
      } else if (state.tabController.index == 1) {
        state.bookType.value = 'book';
        if (state.searchController.text.isNotEmpty) {
          searchBooks(state.searchController.text, false);
        }
      } else if (state.tabController.index == 2) {
        state.bookType.value = 'explanation';
        if (state.searchController.text.isNotEmpty) {
          searchBooks(state.searchController.text, false);
        }
      }
    });
    loadSearchHistory();
    super.onInit();
  }

  @override
  void onClose() {
    state.tabController.dispose();
    super.onClose();
  }

  void searchBooks(String query, bool isSingleBook) {
    log('search Books start');
    // إعادة تعيين المؤشرات والبحث الحالي
    state.currentBookIndex = 0;
    state.currentPageIndex = 0;
    state.currentQuery.value = query;
    state.isSingleBook.value = isSingleBook;
    state.pagingController.refresh();
    update();
  }

  void fetchPage(int pageKey) async {
    log('fetchPage called with pageKey: $pageKey');
    try {
      final newItems = await processNextBatch(5);
      final isLastPage = newItems.length < 5;

      if (isLastPage) {
        state.pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1; // التحديث بناءً على الصفحة التالية
        state.pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error, stackTrace) {
      log('Error in fetchPage: $error');
      log('Stack trace: $stackTrace');
      state.pagingController.error = error;
    }
  }

  Future<List<PageContent>> processNextBatch(int limit) async {
    List<PageContent> newItems = [];
    String query = state.currentQuery.value;

    if (query.isEmpty) {
      return newItems;
    }
    String queryWithoutDiacritics = query.removeDiacritics(query);
    List<String> queryWords = queryWithoutDiacritics.split(' ');

    List<Book> booksToSearch;
    if (state.isSingleBook.value) {
      booksToSearch = booksCtrl.state.booksList
          .where((book) =>
              book.bookType == state.bookType.value &&
              book.bookNumber == state.bookNumber)
          .toList();
    } else {
      booksToSearch = booksCtrl.state.booksList
          .where((book) => state.bookType.value == book.bookType)
          .toList();
    }

    log('Books to search after filtering: ${booksToSearch.length}');

    while (newItems.length < limit &&
        state.currentBookIndex < booksToSearch.length) {
      var book = booksToSearch[state.currentBookIndex];
      final pages = await booksCtrl.getPages(
        book.bookNumber,
        booksCtrl.getLocalBooks(book.bookNumber).value ? true : false,
      );
      log('Pages in current book: ${pages.length}');

      while (newItems.length < limit && state.currentPageIndex < pages.length) {
        var page = pages[state.currentPageIndex];

        log('Fetched page number: ${page.pageNumber}'); // تسجيل رقم الصفحة

        String contentWithoutDiacritics =
            page.content.removeDiacritics(page.content);
        String titleWithoutDiacritics = page.title.removeDiacritics(page.title);

        if (queryWords.any((word) =>
            contentWithoutDiacritics.contains(word) ||
            titleWithoutDiacritics.contains(word))) {
          List<String> words = contentWithoutDiacritics.split(' ');
          int queryIndex =
              words.indexWhere((word) => word.contains(queryWords[0]));

          if (queryIndex != -1) {
            int start = (queryIndex - 5).clamp(0, words.length);
            int end = (queryIndex + 5).clamp(0, words.length);

            List<String> snippet = words.sublist(start, end);
            String snippetText = snippet.join(' ');

            PageContent snippetPage = PageContent(
              title: page.title,
              pageNumber: page.pageNumber,
              pageNumberInBook: page.pageNumberInBook,
              content: snippetText,
              footnotes: page.footnotes,
              bookTitle: page.bookTitle,
              bookNumber: book.bookNumber,
              author: page.author,
            );

            newItems.add(snippetPage);
          }
        }

        state.currentPageIndex++;
      }

      if (state.currentPageIndex >= pages.length) {
        state.currentPageIndex = 0;
        state.currentBookIndex++;
      }
    }

    log('Batch completed. New items: ${newItems.length}');

    return newItems;
  }

  void searchPoems(String query) {
    if (booksCtrl.state.loadedPoems.isEmpty || query.isEmpty) {
      state.searchResults.clear();
      return;
    }

    final normalizedQuery = query.removeDiacritics(query.trim().toLowerCase());
    final List<SearchResult> tempSearchResults = [];
    for (final poemBook in booksCtrl.state.loadedPoems) {
      tempSearchResults
          .addAll(poemBook.chapters!.asMap().entries.expand((entry) {
        final chapterIndex = entry.key;
        final chapter = entry.value;

        return chapter.poems!
            .where((poem) =>
                poem.firstPoem!
                    .removeDiacritics(poem.firstPoem!.toLowerCase())
                    .contains(normalizedQuery) ||
                poem.secondPoem!
                    .removeDiacritics(poem.secondPoem!.toLowerCase())
                    .contains(normalizedQuery) ||
                chapter.explanation!
                    .removeDiacritics(chapter.explanation!.toLowerCase())
                    .contains(normalizedQuery))
            .map((poem) => SearchResult(
                  chapterIndex: chapterIndex,
                  bookName: poemBook.bookName!,
                  chapterTitle: chapter.chapterTitle!,
                  poemNumber: poem.poemNumber!,
                  explanation: chapter.explanation!,
                  firstPoem: poem.firstPoem!,
                  secondPoem: poem.secondPoem!,
                  bookType: poemBook.bookType!,
                  bookNumber: poemBook.bookNumber!,
                ));
      }).toList());
    }
    state.searchResults.assignAll(tempSearchResults);
  }
}
