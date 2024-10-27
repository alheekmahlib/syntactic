import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/custom_error_snackBar.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_getters.dart';
import 'package:nahawi/presentation/screens/all_books/controller/extensions/books_storage_getters.dart';
import 'package:path_provider/path_provider.dart';

import '../data/models/books_model.dart';
import '../data/models/page_model.dart';
import '../data/models/part_model.dart';
import '../data/models/poem_model.dart';
import 'books_state.dart';

class AllBooksController extends GetxController
    with GetTickerProviderStateMixin {
  static AllBooksController get instance =>
      Get.isRegistered<AllBooksController>()
          ? Get.find<AllBooksController>()
          : Get.put(AllBooksController());

  BooksState state = BooksState();

  @override
  void onInit() {
    super.onInit();
    state.tabBarController = TabController(length: 3, vsync: this);
    fetchBooks().then((_) {
      loadLastRead();
    });
    loadFromGetStorage();
  }

  @override
  void onClose() {
    state.bPageController.dispose();
    // state.ScrollUpDownBook.dispose();
    state.bookRLFocusNode.dispose();
    // state.bookUDFocusNode.dispose();
    super.onClose();
  }

  /// -------- [Methods] ----------

  Future<void> fetchBooks() async {
    try {
      state.isLoading(true);
      String jsonString =
          await rootBundle.loadString('assets/json/collections.json');
      var booksJson = json.decode(jsonString) as List;
      state.booksList.value =
          booksJson.map((book) => Book.fromJson(book)).toList();
      log('Books loaded: ${state.booksList.length}');
      separateBooksByTypes();
      loadDownloadedBooks();
      _loadPoem();
    } catch (e) {
      log('Error fetching books: $e');
    } finally {
      state.isLoading(false);
    }
  }

  Future<void> _loadPoem() async {
    try {
      for (int poemBookNumber in poemBookNumbers) {
        String jsonData = await rootBundle
            .loadString('assets/json/books/$poemBookNumber.json', cache: false);
        var decodedData = jsonDecode(jsonData);
        state.loadedPoems.add(PoemBook.fromJson(decodedData));
        print(state.loadedPoems.length);
      }
    } catch (e) {
      print('Error loading books: $e');
    }
  }

  void separateBooksByTypes() {
    for (var b in state.booksList) {
      if (b.bookType == 'poemBooks') {
        state.poemBooks.add(b);
      } else if (b.bookType == 'book') {
        state.books.add(b);
      } else if (b.bookType == 'explanation') {
        state.explanationBooks.add(b);
      }
      // b.bookType == 'book' ? state.books.add(b) : state.poemBooks.add(b);
    }
  }

  Future<void> downloadBook(int bookNumber, String type) async {
    try {
      state.downloading[bookNumber] = true;
      state.downloadProgress[bookNumber] = 0.0;
      update();
      var response = await Dio().get(
        'https://raw.githubusercontent.com/alheekmahlib/thegarlanded/refs/heads/master/nahawi_book/$bookNumber.json',
        options: Options(responseType: ResponseType.stream),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            state.downloadProgress[bookNumber] = (received / total);
          }
        },
      );

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$bookNumber.json');

      var data = <int>[];
      await for (var value in response.data.stream) {
        data.addAll(value);
      }
      await file.writeAsBytes(data);
      addDownloadedBook(type, bookNumber);
      saveDownloadedBooks();
    } catch (e) {
      log('Error downloading book: $e');
    } finally {
      state.downloading[bookNumber] = false;
      Get.context!.showCustomErrorSnackBar('booksDownloaded'.tr, isDone: true);
    }
    update();
  }

  void addDownloadedBook(String type, int bookNumber) {
    if (!state.downloadedBooksByType.containsKey(type)) {
      state.downloadedBooksByType[type] = <int, bool>{};
    }
    state.downloadedBooksByType[type]![bookNumber] = true;
  }

  List<Part> getParts(int bookNumber, String type) {
    return state.booksList
        .firstWhere(
            (book) => book.bookNumber == bookNumber && book.bookType == type)
        .parts;
  }

  // List<Chapter> getChapters(int bookNumber) {
  //   var book = state.booksList.firstWhere(
  //     (book) => book.bookNumber == bookNumber,
  //     orElse: () => Book.empty(),
  //   );
  //
  //   var toc = book.parts; // Assuming `toc` is a list of parts
  //
  //   // Expand the second list in each toc item to retrieve chapters
  //   return toc
  //       .expand((part) => part[1].map((chapter) => Chapter.fromJson(chapter)))
  //       .toList();
  // }

  Future<int> getChapterStartPage(
      int bookNumber, int chapterPage, bool isLocal) async {
    try {
      File? file;
      dynamic toc;

      if (!isLocal) {
        final directory = await getApplicationDocumentsDirectory();
        file = File('${directory.path}/$bookNumber.json');
        if (await file.exists()) {
          String jsonString = await file.readAsString();
          state.bookJsonList = json.decode(jsonString);

          // التأكد من أن bookJsonList هو قائمة
          if (state.bookJsonList is List && state.bookJsonList.isNotEmpty) {
            var bookJson = state.bookJsonList[0]; // اختيار أول عنصر من القائمة

            // التحقق من وجود الحقل 'info' في العنصر الأول
            if (bookJson.containsKey('info')) {
              var info = bookJson['info'];

              // التحقق من وجود الحقل 'toc' داخل 'info'
              if (info.containsKey('toc')) {
                toc = info['toc'];
              } else {
                log("Error: 'toc' not found in 'info'");
              }
            } else {
              log("Error: 'info' not found in book JSON");
            }
          } else {
            log("Error: bookJsonList is either not a list or empty");
          }
        }
      } else {
        String jsonString =
            await rootBundle.loadString('assets/json/books/$bookNumber.json');
        state.bookJsonList = json.decode(jsonString);

        // التأكد من أن bookJsonList هو قائمة
        if (state.bookJsonList is List && state.bookJsonList.isNotEmpty) {
          var bookJson = state.bookJsonList[0]; // اختيار أول عنصر من القائمة

          // التحقق من وجود الحقل 'info' في العنصر الأول
          if (bookJson.containsKey('info')) {
            var info = bookJson['info'];

            // التحقق من وجود الحقل 'toc' داخل 'info'
            if (info.containsKey('toc')) {
              toc = info['toc'];
            } else {
              log("Error: 'toc' not found in 'info'");
            }
          } else {
            log("Error: 'info' not found in book JSON");
          }
        } else {
          log("Error: bookJsonList is either not a list or empty");
        }
      }

      // التحقق من أن toc ليس فارغًا وأنه من نوع قائمة (List)
      if (toc != null && toc is List) {
        for (var part in toc) {
          // التحقق من أن الجزء (part) يحتوي على عنصرين
          if (part is List && part.length >= 2) {
            var partInfo =
                part[0]; // معلومات الجزء مثل {"page": 1, "text": "الجزء الأول"}
            var chapters = part[1]; // قائمة الفصول

            // التحقق من أن الفصول هي قائمة (List)
            if (chapters is List) {
              for (var chapter in chapters) {
                // التحقق من أن الحقل 'page' موجود ومن نوع int أو قابل للتحويل إلى int
                if (chapter is Map && chapter.containsKey('page')) {
                  int? pageNumber = int.tryParse(chapter['page'].toString());

                  // التأكد من أن النص موجود والتأكد من أن الصفحة تم تحويلها بنجاح
                  if (chapter['page'] == chapterPage && pageNumber != null) {
                    return pageNumber - 1; // إرجاع رقم الصفحة المصحح
                  }
                }
              }
            }
          }
        }
      } else {
        log("Error: 'toc' is null or not a list");
      }

      return 0; // إرجاع 0 إذا لم يتم العثور على أي نتائج
    } catch (e) {
      log('Error in getChapterStartPage: $e');
      return 0;
    }
  }

  Future<List<PageContent>> getPages(int bookNumber, bool isLocal) async {
    try {
      File? file;
      dynamic pages;
      dynamic bookJson; // تعريف متغير bookJson

      if (!isLocal) {
        final directory = await getApplicationDocumentsDirectory();
        file = File('${directory.path}/$bookNumber.json');
        if (await file.exists()) {
          String jsonString = await file.readAsString();
          var bookJsonList = json.decode(jsonString);

          // التأكد من أن bookJsonList هو قائمة وأنها ليست فارغة
          if (bookJsonList is List && bookJsonList.isNotEmpty) {
            bookJson = bookJsonList[0]; // أخذ العنصر الأول في القائمة
          } else {
            log("Error: bookJsonList is either not a list or empty");
            return [];
          }
        } else {
          return [];
        }
      } else {
        String jsonString =
            await rootBundle.loadString('assets/json/books/$bookNumber.json');
        var bookJsonList = json.decode(jsonString);

        // التأكد من أن bookJsonList هو قائمة وأنها ليست فارغة
        if (bookJsonList is List && bookJsonList.isNotEmpty) {
          bookJson = bookJsonList[0]; // أخذ العنصر الأول في القائمة
        } else {
          log("Error: bookJsonList is either not a list or empty");
          return [];
        }
      }

      // التحقق من أن bookJson هو خريطة (Map) ويحتوي على الحقل 'pages'
      if (bookJson is Map && bookJson.containsKey('pages')) {
        pages = bookJson['pages'];
      } else {
        log("Error: 'pages' not found in book JSON");
        return [];
      }

      // التحقق من أن 'pages' هو قائمة (List)
      if (pages is List) {
        return pages.map((page) {
          // التحقق من أن الصفحة هي خريطة (Map) قبل محاولة الوصول إلى محتوياتها
          if (page is Map<String, dynamic>) {
            return PageContent.fromJson(page, bookJson['info']['title']);
          } else {
            log("Error: Page is not a Map");
            return PageContent.empty(); // إرجاع صفحة فارغة عند وجود خطأ
          }
        }).toList();
      } else {
        log("Error: 'pages' is not a list");
        return [];
      }
    } catch (e) {
      log('Error in getPages: $e');
      return [];
    }
  }
}
