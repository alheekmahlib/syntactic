import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syntactic/presentation/controllers/books_controller.dart';

import '../../core/services/services_locator.dart';
import '../../core/utils/constants/shared_preferences_constants.dart';
import '../screens/home/data/models/time_now.dart';
import '../screens/search/data/models/search_model.dart';
import '../screens/search/data/models/search_result_model.dart';

class SearchControllers extends GetxController {
  List<int> booksSelected = [];
  var searchHistory = <SearchItem>[].obs;
  TextEditingController textSearchController = TextEditingController();
  RxList<SearchResult> searchResults = <SearchResult>[].obs;
  final bookCtrl = sl<BooksController>();

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
