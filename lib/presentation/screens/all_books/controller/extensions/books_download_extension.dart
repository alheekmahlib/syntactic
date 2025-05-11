import 'dart:developer';

import 'package:get/get.dart';
import 'package:nahawi/core/utils/constants/extensions/download_extension.dart';

import '/presentation/screens/all_books/controller/extensions/books_storage_getters.dart';
import '../../../../../core/utils/constants/api_constants.dart';
import '../books_controller.dart';

/// امتداد للتحكم في تنزيل الكتب
/// Extension for handling book downloads
extension BooksDownloadExtension on AllBooksController {
  /// تنزيل كتاب بواسطة رقمه ونوعه
  /// Download a book by its number and type
  Future<void> downloadBook(int bookNumber, String type) async {
    try {
      // تعيين حالة التنزيل والتقدم
      // Set download state and progress
      state.downloading[bookNumber] = true;
      state.downloadProgress[bookNumber] = 0.0;
      update();

      final endpoint =
          '${ApiConstants.baseUrl}${ApiConstants.booksUrl}$bookNumber.json?raw=true';

      final documentsPath = await appDocumentsDir;
      final savePath = '$documentsPath/$bookNumber.json';

      // استخدام امتداد التنزيل العام
      // Use the generic download extension
      final success = await downloadFile(
        url: endpoint,
        savePath: savePath,
        showSuccessMessage: true,
        successMessage: 'booksDownloaded'.tr,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            state.downloadProgress[bookNumber] = (received / total);
            update();
          }
        },
        onSuccess: (_) {
          // إضافة الكتاب المنزل وحفظه
          // Add downloaded book and save it
          addDownloadedBook(type, bookNumber);
          saveDownloadedBooks();
          log('Book $bookNumber downloaded successfully',
              name: 'BooksDownloadExtension');
        },
        onError: (error) {
          log('Error downloading book: $error', name: 'BooksDownloadExtension');
        },
      );

      if (!success) {
        log('Download failed for book: $bookNumber',
            name: 'BooksDownloadExtension');
      }
    } catch (e) {
      log('Error in downloadBook: $e', name: 'BooksDownloadExtension');
    } finally {
      state.downloading[bookNumber] = false;
      update();
    }
  }
}
