import 'dart:convert' show json, jsonDecode, utf8;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/widgets/widgets.dart';
import '../screens/books/books_screen/models/books_model.dart';
import '../screens/books/poems_screen/models/poem_model.dart';

class BooksController extends GetxController {
  var poem = Rxn<Book>();
  var book = Rxn<BooksModel>();
  RxInt selectedPoemIndex = (-1).obs;
  final selectedPair = <int, bool>{}.obs;
  RxList<BookName> booksName = <BookName>[].obs;
  RxList<BookName> books = <BookName>[].obs;
  RxList<BookName> poemBooks = <BookName>[].obs;
  int pairStartIndex = -1;
  RxInt selectedIndex = (-1).obs;
  RxInt chapterNumber = 1.obs;
  RxString currentBookName = ''.obs;
  RxInt bookNumber = 0.obs;
  List<BookName> loadedBooks = [];
  bool loadPoemBooks = true;

  void separateBooksByTypes() {
    for (var b in booksName) {
      b.bookType == 'book' ? books.add(b) : poemBooks.add(b);
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadBooksName();
    loadBook();
  }

  get detailsCtrl => loadPoemBooks ? poem.value : book.value;

  Future<void> loadBooksName() async {
    try {
      String data = await rootBundle.loadString('assets/json/bookName.json');
      List<dynamic> booksData = json.decode(data)['books'];
      List<BookName> bookList =
          booksData.map((json) => BookName.fromJson(json)).toList();
      booksName.assignAll(bookList);
      separateBooksByTypes();
      print('poemBooks: ${poemBooks.length}');
      print('books: ${books.length}');
    } catch (e) {
      // Handle errors
      print("Error loading books: $e");
    }
  }

  Future<void> loadBook() async {
    List<int> poemBookNumbers =
        poemBooks.map((book) => book.number - 1).toList();
    List<int> otherBookNumbers = books.map((book) => book.number - 1).toList();
    List<Book> loadedPoems = [];
    List<BooksModel> loadedBooks = [];

    try {
      if (loadPoemBooks) {
        for (int poemBookNumber in poemBookNumbers) {
          String jsonData = await rootBundle.loadString(
              'assets/json/poems/$poemBookNumber.json',
              cache: false);
          var decodedData = jsonDecode(jsonData);
          loadedPoems.add(Book.fromJson(decodedData));
          print(loadedPoems.length);
        }
      } else {
        for (int otherBookNumber in otherBookNumbers) {
          String jsonData = await rootBundle.loadString(
              'assets/json/books/$otherBookNumber.json',
              cache: false);
          var decodedData = jsonDecode(jsonData);
          loadedBooks.add(BooksModel.fromJson(decodedData));
        }
      }

      // Check if loadedBooks is not empty before accessing an index
      if (loadedBooks.isNotEmpty || loadedPoems.isNotEmpty) {
        // Ensure that bookNumber.value is a valid index
        // if (bookNumber.value >= 0 &&
        //     bookNumber.value < loadedPoems.length &&
        //     bookNumber.value < loadedBooks.length) {
        if (loadPoemBooks) {
          poem.value = loadedPoems[bookNumber.value];
          print(loadedPoems[bookNumber.value].bookName);
        } else {
          book.value = loadedBooks[bookNumber.value];
          print(loadedBooks[bookNumber.value].bookName);
        }

        // } else {
        //   print('Invalid bookNumber.value: ${bookNumber.value}');
        // }
      } else {
        print('Loaded books list is empty');
      }
    } catch (e) {
      print('Error loading books: $e');
    }
  }

  // Future<void> loadBooks() async {
  //   try {
  //     String bookNamesData =
  //     await rootBundle.loadString('assets/json/bookName.json');
  //     List<dynamic> booksData = json.decode(bookNamesData)['books'];
  //     List<BookName> bookList =
  //     booksData.map((json) => BookName.fromJson(json)).toList();
  //     booksName.assignAll(bookList);
  //
  //     for (var bookJson in booksData) {
  //       // Ensure 'number' is not null before attempting to load the JSON file
  //       if (bookJson['number'] != null) {
  //         String jsonData = await rootBundle.loadString(
  //             'assets/json/${bookJson['number']}.json',
  //             cache: false);
  //         var decodedData = jsonDecode(jsonData);
  //         // book.value = Book.fromJson(decodedData);
  //         books.add(Rxn<Book>(Book.fromJson(decodedData)));
  //         print('booksData: $booksData');
  //       }
  //     }
  //   } catch (e) {
  //     print('Error loading books: $e');
  //   }
  // }

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

  Future<void> copy(BuildContext context, String poemTextOne,
      String poemTextTwo, String chapterText) async {
    await Clipboard.setData(
            ClipboardData(text: '$chapterText\n\n$poemTextOne\n$poemTextTwo'))
        .then((value) => customSnackBar(context, 'copied'.tr));
  }
}
