import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../data/models/books_model.dart';
import '../data/models/poem_model.dart';

class BooksState {
  /// -------- [Variables] ----------
  final box = GetStorage();
  var booksList = <Book>[].obs;
  RxList<Book> books = <Book>[].obs;
  RxList<Book> explanationBooks = <Book>[].obs;
  RxList<Book> poemBooks = <Book>[].obs;
  var isLoading = true.obs;
  var downloading = <int, bool>{}.obs;
  var downloadedBooksByType = <String, Map<int, bool>>{
    'poemBooks': {2: true, 3: true},
    'book': {1: true, 4: true},
  }.obs;
  var downloadProgress = <int, double>{}.obs;
  RxBool isDownloaded = false.obs;
  PageController bPageController = PageController();
  final FocusNode bookRLFocusNode = FocusNode();
  // final FocusNode bookUDFocusNode = FocusNode();
  // final ScrollController ScrollUpDownBook = ScrollController();
  RxInt currentPageIndex = 0.obs;
  var lastReadPage = <int, int>{}.obs;
  var lastBookType = <int, int>{}.obs;
  Map<int, int> bookTotalPages = {};
  RxBool isTashkil = true.obs;
  List<int> localBooks = [1, 2, 3, 4];
  RxInt chapterNumber = 1.obs;
  List<PoemBook> loadedPoems = [];
  RxInt selectedPoemIndex = (-1).obs;
  RxInt bookNumber = 0.obs;
  dynamic bookJsonList;
  late TabController tabBarController;
  PageController pPageController = PageController();
  // Rx<Part> currentPart = Part.empty().obs;
  // Rx<ch.Chapter> currentChapter = ch.Chapter.empty().obs;
}
