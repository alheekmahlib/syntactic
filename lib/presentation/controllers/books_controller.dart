import 'dart:convert' show json, jsonDecode, utf8;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../core/widgets/widgets.dart';
import '../screens/books/modals/chapter_model.dart';

class BooksController extends GetxController {
  var book = Rxn<Book>();
  RxInt selectedPoemIndex = (-1).obs;
  final selectedPair = <int, bool>{}.obs;
  RxList<BookName> booksName = <BookName>[].obs;
  int pairStartIndex = -1;
  RxInt selectedIndex = (-1).obs;
  RxInt chapterNumber = 1.obs;
  RxString bookName = ''.obs;
  RxInt bookNumber = 0.obs;
  List<Book> loadedBooks = []; // Add a list to store loaded books

  // Method to get a book by its number
  Book getBookByName(String bookName) {
    return loadedBooks.firstWhere(
      (book) => book.bookName == bookName,
      orElse: () =>
          Book(), // Return a default Book or handle the case accordingly
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadBooksName();
    loadBook();
  }

  Future<void> loadBooksName() async {
    try {
      String data = await rootBundle.loadString('assets/json/bookName.json');
      List<dynamic> booksData = json.decode(data)['books'];
      List<BookName> bookList =
          booksData.map((json) => BookName.fromJson(json)).toList();
      booksName.assignAll(bookList);
    } catch (e) {
      // Handle errors
      print("Error loading books: $e");
    }
  }

  Future<void> loadBook() async {
    List<int> books = booksName.map((book) => book.number - 1).toList();
    List<Book> loadedBooks = [];

    try {
      for (int bookNumber in books) {
        String jsonData = await rootBundle
            .loadString('assets/json/$bookNumber.json', cache: false);
        var decodedData = jsonDecode(jsonData);
        loadedBooks.add(Book.fromJson(decodedData));
      }

      // Check if loadedBooks is not empty before accessing an index
      if (loadedBooks.isNotEmpty) {
        // Ensure that bookNumber.value is a valid index
        if (bookNumber.value >= 0 && bookNumber.value < loadedBooks.length) {
          book.value = loadedBooks[bookNumber.value];
        } else {
          print('Invalid bookNumber.value: ${bookNumber.value}');
        }
      } else {
        print('Loaded books list is empty');
      }
    } catch (e) {
      print('Error loading book: $e');
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
      selectedPoemIndex.value = -1;
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
