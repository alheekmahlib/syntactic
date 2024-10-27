import 'dart:developer';

import '../../../../../core/utils/constants/shared_preferences_constants.dart';
import '../books_controller.dart';

extension BooksStorageGetters on AllBooksController {
  /// -------- [Getters] --------
  void saveLastRead(int pageNumber, String bookName, int bookNumber,
      int totalPages, String chapterName, String bookType) {
    state.lastReadPage[bookNumber] = pageNumber;
    state.bookTotalPages[bookNumber] = totalPages;
    state.box.write('lastRead_$bookNumber', {
      'pageNumber': pageNumber,
      'bookName': bookName,
      'totalPages': totalPages,
      'chapterName': chapterName,
      'bookType': bookType,
    });
    log('book: $bookName, book Number: $bookNumber, book type: $bookType, chapter: $chapterName, page: $pageNumber, total page: $totalPages was saved');
  }

  void loadLastRead() {
    if (state.booksList.isNotEmpty) {
      for (var book in state.booksList) {
        var lastRead = state.box.read('lastRead_${book.bookNumber}');
        if (lastRead != null) {
          state.lastReadPage[book.bookNumber] = lastRead['pageNumber'];
          log('state.lastReadPage[book.bookNumber]: ${state.lastReadPage[book.bookNumber]}');
          state.bookTotalPages[book.bookNumber] = lastRead['totalPages'];
          state.lastBookType[book.bookNumber] = lastRead['totalPages'];
          log('state.bookTotalPages[book.bookNumber]: ${state.bookTotalPages[book.bookNumber]}');
        }
      }
    } else {
      log('state.booksList is empty.');
    }
  }

  void loadFromGetStorage() {
    state.isTashkil.value = state.box.read(IS_TASHKIL) ?? true;
  }

  void saveDownloadedBooks() {
    Map<String, List<String>> downloadedBooks = state.downloadedBooksByType.map(
      (type, booksMap) {
        List<String> downloadedBookNumbers = booksMap.entries
            .where((entry) => entry.value) // فقط الكتب المحملة
            .map((entry) => entry.key.toString()) // تحويل رقم الكتاب إلى String
            .toList();
        return MapEntry(type, downloadedBookNumbers);
      },
    );

    log('Saving downloaded books by type: $downloadedBooks');
    state.box.write(DOWNLOADED_BOOKS, downloadedBooks);
  }

  Future<void> loadDownloadedBooks() async {
    try {
      Map<String, dynamic>? downloadedBooks = state.box.read(DOWNLOADED_BOOKS);
      log('Loaded downloaded books by type: $downloadedBooks');
      if (downloadedBooks != null) {
        downloadedBooks.forEach((type, bookNumbers) {
          if (bookNumbers is List) {
            for (var bookNumber in bookNumbers) {
              if (bookNumber is String) {
                if (!state.downloadedBooksByType.containsKey(type)) {
                  state.downloadedBooksByType[type] = <int, bool>{};
                }
                state.downloadedBooksByType[type]![int.parse(bookNumber)] =
                    true;
              } else {
                log('Invalid book number format: $bookNumber');
              }
            }
          } else {
            log('Invalid data format for type: $type');
          }
        });
      } else {
        log('No downloaded books found or data is in incorrect format.');
      }
    } catch (e) {
      log('Error loading downloaded books: $e');
    }
  }
}
