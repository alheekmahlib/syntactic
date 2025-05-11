import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../../services/connectivity_service.dart';
import '../../helpers/api_client.dart';
import 'custom_error_snack_bar.dart';

/// امتداد عام للتنزيلات يمكن استخدامه لتنزيل أي نوع من الملفات
/// Generic download extension that can be used to download any type of files
extension DownloadExtension on Object {
  /// دالة للتحقق من الاتصال بالإنترنت
  /// Function to check internet connectivity
  bool _checkConnectivity({bool showError = true}) {
    if (ConnectivityService.instance.noConnection.value) {
      if (showError) {
        Get.context!.showCustomErrorSnackBar('noInternet'.tr);
      }
      return false;
    }
    return true;
  }

  /// تنزيل ملف من رابط معين وحفظه في المسار المحدد
  /// Download a file from a specific URL and save it to the specified path
  ///
  /// [url] رابط الملف المراد تنزيله / URL of the file to download
  /// [savePath] مسار الحفظ الكامل مع اسم الملف / Full save path with filename
  /// [headers] رؤوس HTTP الإضافية / Additional HTTP headers
  /// [token] رمز المصادقة / Authentication token
  /// [showSuccessMessage] عرض رسالة النجاح / Show success message
  /// [successMessage] نص رسالة النجاح / Success message text
  /// [onReceiveProgress] دالة رد النداء لتتبع التقدم / Callback function for tracking progress
  /// [onSuccess] دالة رد النداء عند نجاح التنزيل / Callback function on successful download
  /// [onError] دالة رد النداء عند فشل التنزيل / Callback function on download error
  Future<bool> downloadFile({
    required String url,
    required String savePath,
    Map<String, String>? headers,
    String? token,
    bool showSuccessMessage = true,
    String? successMessage,
    void Function(int received, int total)? onReceiveProgress,
    void Function(File file)? onSuccess,
    void Function(String error)? onError,
  }) async {
    if (!_checkConnectivity()) return false;

    try {
      log('Starting download from: $url', name: 'DownloadExtension');
      log('Save path: $savePath', name: 'DownloadExtension');

      final apiClient = ApiClient();

      // تنزيل الملف باستخدام ApiClient
      // Download file using ApiClient
      final result = await apiClient.downloadFile(
        url: url,
        headers: headers,
        token: token,
        onReceiveProgress: onReceiveProgress,
      );

      // معالجة نتيجة التنزيل
      // Handle download result
      return result.fold(
        (failure) {
          final errorMessage = 'Error downloading file: ${failure.message}';
          log(errorMessage, name: 'DownloadExtension');

          if (onError != null) {
            onError(failure.message);
          } else {
            Get.context!.showCustomErrorSnackBar('downloadError'.tr);
          }
          return false;
        },
        (data) async {
          final file = File(savePath);

          // إنشاء المجلد إذا لم يكن موجودًا
          // Create directory if it doesn't exist
          final directory = file.parent;
          if (!await directory.exists()) {
            await directory.create(recursive: true);
          }

          // كتابة البيانات في الملف
          // Write data to file
          await file.writeAsBytes(data);

          log('File downloaded successfully to: $savePath',
              name: 'DownloadExtension');

          if (showSuccessMessage) {
            Get.context!.showCustomErrorSnackBar(
                successMessage ?? 'fileDownloaded'.tr,
                isDone: true);
          }

          if (onSuccess != null) {
            onSuccess(file);
          }

          return true;
        },
      );
    } catch (e) {
      final errorMessage = 'Error in downloadFile: $e';
      log(errorMessage, name: 'DownloadExtension');

      if (onError != null) {
        onError(e.toString());
      } else {
        Get.context!.showCustomErrorSnackBar('downloadError'.tr);
      }

      return false;
    }
  }

  /// تنزيل ملف وإرجاع مصفوفة البيانات بدلاً من حفظه
  /// Download a file and return the data array instead of saving it
  Future<Uint8List?> downloadFileAsBytes({
    required String url,
    Map<String, String>? headers,
    String? token,
    void Function(int received, int total)? onReceiveProgress,
    void Function(String error)? onError,
  }) async {
    if (!_checkConnectivity()) return null;

    try {
      log('Starting download as bytes from: $url', name: 'DownloadExtension');

      final apiClient = ApiClient();

      // تنزيل الملف باستخدام ApiClient
      // Download file using ApiClient
      final result = await apiClient.downloadFile(
        url: url,
        headers: headers,
        token: token,
        onReceiveProgress: onReceiveProgress,
      );

      // معالجة نتيجة التنزيل
      // Handle download result
      return result.fold(
        (failure) {
          final errorMessage =
              'Error downloading file as bytes: ${failure.message}';
          log(errorMessage, name: 'DownloadExtension');

          if (onError != null) {
            onError(failure.message);
          } else {
            Get.context!.showCustomErrorSnackBar('downloadError'.tr);
          }
          return null;
        },
        (data) {
          log('File downloaded successfully as bytes',
              name: 'DownloadExtension');
          return data;
        },
      );
    } catch (e) {
      final errorMessage = 'Error in downloadFileAsBytes: $e';
      log(errorMessage, name: 'DownloadExtension');

      if (onError != null) {
        onError(e.toString());
      } else {
        Get.context!.showCustomErrorSnackBar('downloadError'.tr);
      }

      return null;
    }
  }

  /// الحصول على مسار مجلد التطبيق للتخزين المؤقت
  /// Get application cache directory path
  Future<String> get appCacheDir async {
    final directory = await getTemporaryDirectory();
    return directory.path;
  }

  /// الحصول على مسار مجلد المستندات للتطبيق
  /// Get application documents directory path
  Future<String> get appDocumentsDir async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
