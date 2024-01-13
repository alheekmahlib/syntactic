import 'dart:convert' show json, jsonDecode;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/widgets/widgets.dart';
import '../screens/books/books_screen/models/books_model.dart';
import '../screens/books/poems_screen/models/poem_model.dart';

class BooksController extends GetxController {
  RxInt selectedPoemIndex = (-1).obs;
  final selectedPair = <int, bool>{}.obs;
  RxList<BookName> allBooksNames = <BookName>[].obs;
  RxList<BookName> books = <BookName>[].obs;
  RxList<BookName> poemBooks = <BookName>[].obs;
  int pairStartIndex = -1;
  RxInt selectedIndex = (-1).obs;
  RxInt chapterNumber = 1.obs;
  RxString currentBookName = ''.obs;
  RxInt bookNumber = 0.obs;
  List<BookName> loadedBooksNames = [];
  bool loadPoemBooks = true;
  final scrollController = ScrollController();

  List<int> get poemBookNumbers =>
      poemBooks.map((book) => book.number - 1).toList();
  List<int> get otherBookNumbers =>
      books.map((book) => book.number - 1).toList();
  List<PoemBook> loadedPoems = [];
  List<BooksModel> loadedBooks = [];

  // void jumpToPoemIndex() {
  //   scrollController.jumpTo(sl<AudioController>().poemNumber.value.toDouble());
  // }

  // BookName? get currentBookNameCollection => loadedBooksNames
  //     .firstWhereOrNull((book) => book.number == bookNumber.value);

  void separateBooksByTypes() {
    for (var b in allBooksNames) {
      b.bookType == 'book' ? books.add(b) : poemBooks.add(b);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadBooksName().then((_) => _loadBooks());
  }

  BooksModel? get currentBook => loadedBooks
      .firstWhereOrNull((book) => book.bookName == currentBookName.value);
  PoemBook? get currentPoemBook => loadedPoems
      .firstWhereOrNull((book) => book.bookName == currentBookName.value);

  dynamic get detailsCtrl => loadPoemBooks ? currentPoemBook : currentBook;

  Future<void> _loadBooksName() async {
    try {
      String data = await rootBundle.loadString('assets/json/bookName.json');
      List<dynamic> booksData = json.decode(data)['books'];
      List<BookName> bookList =
          booksData.map((json) => BookName.fromJson(json)).toList();
      allBooksNames.assignAll(bookList);
      separateBooksByTypes();
      print('poemBooks: ${poemBooks.length}');
      print('books: ${books.length}');
    } catch (e) {
      // Handle errors
      print("Error loading books: $e");
    }
  }

  Future<void> _loadBooks() async {
    try {
      for (int poemBookNumber in poemBookNumbers) {
        String jsonData = await rootBundle
            .loadString('assets/json/poems/$poemBookNumber.json', cache: false);
        var decodedData = jsonDecode(jsonData);
        loadedPoems.add(PoemBook.fromJson(decodedData));
        print(loadedPoems.length);
      }
      // } else {
      for (int otherBookNumber in otherBookNumbers) {
        String jsonData = await rootBundle.loadString(
            'assets/json/books/$otherBookNumber.json',
            cache: false);
        var decodedData = jsonDecode(jsonData);
        loadedBooks.add(BooksModel.fromJson(decodedData));
      }

      // Check if loadedBooks is not empty before accessing an index
      // if (loadedBooks.isNotEmpty || loadedPoems.isNotEmpty) {
      //   // Ensure that bookNumber.value is a valid index
      //   // if (bookNumber.value >= 0 &&
      //   //     bookNumber.value < loadedPoems.length &&
      //   //     bookNumber.value < loadedBooks.length) {
      //   if (loadPoemBooks) {
      //     _currentPoemBook.value = loadedPoems[bookNumber.value];
      //     print(loadedPoems[bookNumber.value].bookName);
      //   } else {
      //     _currentBook.value = loadedBooks[bookNumber.value];
      //     print(loadedBooks[bookNumber.value].bookName);
      //   }

      // } else {
      //   print('Invalid bookNumber.value: ${bookNumber.value}');
      // }
      // } else {
      //   print('Loaded books list is empty');
      // }
    } catch (e) {
      print('Error loading books: $e');
    }
  }

  void poemSelect(int index) {
    if (selectedPoemIndex.value == index) {
      selectedPoemIndex.value = index;
    } else if (index == 0 || index.isEven) {
      selectedPoemIndex.value = index;
    } else if (index == 1 || index.isOdd) {
      selectedPoemIndex.value = index;
    }
  }

  Color colorSelection(BuildContext context, int index) {
    return index == selectedPoemIndex.value
        ? Theme.of(context).colorScheme.surface.withOpacity(.2)
        : Colors.transparent;
  }

  Future<void> copyPoem(BuildContext context, String poemTextOne,
      String poemTextTwo, String chapterText, String bookName) async {
    await Clipboard.setData(ClipboardData(
            text: '$bookName\n$chapterText\n\n$poemTextOne\n$poemTextTwo'))
        .then((value) => customSnackBar(context, 'copied'.tr));
  }

  Future<void> copyBook(BuildContext context, String bookName,
      String chapterText, String pageText, String pageNumber) async {
    await Clipboard.setData(ClipboardData(
            text:
                '$bookName\n$chapterText\n\n$pageText\n${'page'.tr}: $pageNumber'))
        .then((value) => customSnackBar(context, 'copied'.tr));
  }
}
