import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:group_button/group_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syntactic/presentation/controllers/books_controller.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../screens/home/data/models/time_now.dart';
import '../screens/search/data/models/search_model.dart';
import '../screens/search/data/models/search_result_model.dart';

class SearchControllers extends GetxController {
  List<int> booksSelected = [];
  late GroupButtonController checkboxesController;
  var searchHistory = <SearchItem>[].obs;
  TextEditingController textSearchController = TextEditingController();
  RxList<SearchResult> searchResults = <SearchResult>[].obs;
  final bookCtrl = sl<BooksController>();

  // Future<void> search(String query) async {
  //   if (bookCtrl.booksName.isEmpty || query.isEmpty) {
  //     searchResults.clear();
  //     return;
  //   }
  //
  //   final normalizedQuery = removeDiacritics(query.trim().toLowerCase());
  //
  //   // Clear previous search results
  //   searchResults.clear();
  //
  //   // Iterate over each book
  //   for (int bookIndex = 0;
  //       bookIndex < bookCtrl.booksName.length;
  //       bookIndex++) {
  //     final bookName = bookCtrl.booksName[bookIndex];
  //
  //     // Load the book
  //     bookCtrl.bookNumber.value = bookIndex;
  //     await bookCtrl.loadBook();
  //
  //     // Iterate over chapters in the current book
  //     for (int chapterIndex = 0;
  //         chapterIndex < bookCtrl.book.value!.chapters!.length;
  //         chapterIndex++) {
  //       final chapter = bookCtrl.book.value!.chapters![chapterIndex];
  //
  //       // Check if the chapter contains the query
  //       if (removeDiacritics(chapter.chapterTitle!.toLowerCase())
  //               .contains(normalizedQuery) ||
  //           removeDiacritics(chapter.explanation!.toLowerCase())
  //               .contains(normalizedQuery)) {
  //         // Add search result for the chapter
  //         searchResults.add(SearchResult(
  //           bookName: bookName.name,
  //           chapterIndex: chapterIndex,
  //           chapterTitle: chapter.chapterTitle!,
  //           poemNumber:
  //               -1, // Indicate that it's a chapter result, not a specific poem
  //           explanation: chapter.explanation!,
  //           firstPoem: '', // You can customize these fields as needed
  //           secondPoem: '', // You can customize these fields as needed
  //         ));
  //       }
  //
  //       // Iterate over poems in the current chapter
  //       for (int poemIndex = 0;
  //           poemIndex < chapter.poems!.length;
  //           poemIndex++) {
  //         final poem = chapter.poems![poemIndex];
  //
  //         // Check if the poem contains the query
  //         if (removeDiacritics(poem.firstPoem!.toLowerCase())
  //                 .contains(normalizedQuery) ||
  //             removeDiacritics(poem.secondPoem!.toLowerCase())
  //                 .contains(normalizedQuery) ||
  //             removeDiacritics(chapter.explanation!.toLowerCase())
  //                 .contains(normalizedQuery)) {
  //           // Add search result for the poem
  //           searchResults.add(SearchResult(
  //             bookName: bookName.name,
  //             chapterIndex: chapterIndex,
  //             chapterTitle: chapter.chapterTitle!,
  //             poemNumber: poemIndex,
  //             explanation: chapter.explanation!,
  //             firstPoem: poem.firstPoem!,
  //             secondPoem: poem.secondPoem!,
  //           ));
  //         }
  //       }
  //     }
  //   }
  // }

  void search(String query) {
    if (bookCtrl.book.value == null || query.isEmpty) {
      searchResults.clear();
      return;
    }

    final normalizedQuery = removeDiacritics(query.trim().toLowerCase());

    searchResults.assignAll(
        bookCtrl.book.value!.chapters!.asMap().entries.expand((entry) {
      final chapterIndex = entry.key;
      final chapter = entry.value;

      return chapter.poems!
          .where((poem) =>
              removeDiacritics(poem.firstPoem!.toLowerCase())
                  .contains(normalizedQuery) ||
              removeDiacritics(poem.secondPoem!.toLowerCase())
                  .contains(normalizedQuery) ||
              removeDiacritics(chapter.explanation!.toLowerCase())
                  .contains(normalizedQuery))
          .map((poem) => SearchResult(
              chapterIndex: chapterIndex,
              bookName: bookCtrl.book.value!.bookName!,
              chapterTitle: chapter.chapterTitle!,
              poemNumber: poem.poemNumber!,
              explanation: chapter.explanation!,
              firstPoem: poem.firstPoem!,
              secondPoem: poem.secondPoem!));
    }).toList());
  }

  // void search(String query) {
  //   if (bookCtrl.booksName.isEmpty || query.isEmpty) {
  //     searchResults.clear();
  //     return;
  //   }
  //
  //   final normalizedQuery = removeDiacritics(query.trim().toLowerCase());
  //
  //   searchResults.clear(); // Clear existing results
  //
  //   for (int bookIndex = 0;
  //   bookIndex < bookCtrl.booksName.length;
  //   bookIndex++) {
  //     final currentBookName = bookCtrl.booksName[bookIndex];
  //     final bookNumber = currentBookName.number;
  //
  //     // Check if bookCtrl.bookName.value is not null before calling getBookByName
  //     if (bookCtrl.bookName.value != null) {
  //       final currentBook = bookCtrl.getBookByName(bookCtrl.bookName.value!);
  //
  //       if (currentBook != null) {
  //         for (int chapterIndex = 0;
  //         chapterIndex < currentBook.chapters!.length;
  //         chapterIndex++) {
  //           final chapter = currentBook.chapters![chapterIndex];
  //
  //           final matchingPoems = chapter.poems!.where((poem) =>
  //           removeDiacritics(poem.firstPoem!.toLowerCase())
  //               .contains(normalizedQuery) ||
  //               removeDiacritics(poem.secondPoem!.toLowerCase())
  //                   .contains(normalizedQuery) ||
  //               removeDiacritics(chapter.explanation!.toLowerCase())
  //                   .contains(normalizedQuery));
  //
  //           for (var poem in matchingPoems) {
  //             searchResults.add(SearchResult(
  //               chapterIndex: chapterIndex,
  //               bookName: currentBook.bookName!,
  //               chapterTitle: chapter.chapterTitle!,
  //               poemNumber: poem.poemNumber!,
  //               explanation: chapter.explanation!,
  //               firstPoem: poem.firstPoem!,
  //               secondPoem: poem.secondPoem!,
  //             ));
  //           }
  //         }
  //       }
  //     }
  //   }
  // }

  String removeDiacritics(String input) {
    final diacriticsMap = {
      'أ': 'ا',
      'إ': 'ا',
      'آ': 'ا',
      'إٔ': 'ا',
      'إٕ': 'ا',
      'إٓ': 'ا',
      'أَ': 'ا',
      'إَ': 'ا',
      'آَ': 'ا',
      'إُ': 'ا',
      'إٌ': 'ا',
      'إُ': 'ا',
      'إً': 'ا',
      'ة': 'ه',
      'ً': '',
      'ٌ': '',
      'ٍ': '',
      'َ': '',
      'ُ': '',
      'ِ': '',
      'ّ': '',
      'ْ': '',
      'ـ': '',
    };

    for (var entry in diacriticsMap.entries) {
      input = input.replaceAll(entry.key, entry.value);
    }

    return input;
  }

  @override
  void onInit() {
    super.onInit();
    loadSearchHistory();
  }

  Future<void> loadSearchHistory() async {
    List<Map<String, dynamic>> rawHistory = sl<SharedPreferences>()
            .getStringList(SEARCH_HISTORY)
            ?.map((item) => jsonDecode(item) as Map<String, dynamic>)
            .toList() ??
        [];
    searchHistory.value =
        rawHistory.map((item) => SearchItem.fromMap(item)).toList();
  }

  Future<void> addSearchItem(String query) async {
    TimeNow timeNow = TimeNow();
    final prefs = await SharedPreferences.getInstance();

    SearchItem newItem = SearchItem(query, timeNow.lastTime);
    searchHistory.removeWhere(
        (item) => item.query == query); // Remove duplicate if exists
    searchHistory.insert(0, newItem); // Add to the top
    await prefs.setStringList(SEARCH_HISTORY,
        searchHistory.map((item) => jsonEncode(item.toMap())).toList());
  }

  Future<void> removeSearchItem(SearchItem item) async {
    final prefs = await SharedPreferences.getInstance();

    searchHistory.remove(item);
    await prefs.setStringList(SEARCH_HISTORY,
        searchHistory.map((item) => jsonEncode(item.toMap())).toList());
  }

  void clearList() {
    searchResults.clear();
    textSearchController.clear();
  }
}
