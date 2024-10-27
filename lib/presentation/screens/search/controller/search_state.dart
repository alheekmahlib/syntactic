import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../all_books/data/models/books_model.dart';
import '../../all_books/data/models/page_model.dart';
import '../data/models/search_model.dart';
import '../data/models/search_result_model.dart';

class SearchState {
  /// -------- [Variables] ----------
  RxList<SearchResult> searchResults = <SearchResult>[].obs;
  RxList<SearchItem> searchHistory = <SearchItem>[].obs;
  int currentBookIndex = 0;
  int currentPageIndex = 0;
  RxString currentQuery = ''.obs;
  int? bookNumber;
  RxString bookType = 'poemBooks'.obs;
  RxBool isSingleBook = false.obs;
  var isLoading = true.obs;
  late final PagingController<int, PageContent> pagingController;
  final TextEditingController searchController = TextEditingController();
  late TabController tabController;
  GetStorage box = GetStorage();
  late final Book book;
}
