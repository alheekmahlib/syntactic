import 'dart:developer';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

import '/core/utils/constants/extensions/custom_error_snack_bar.dart';
import '/core/utils/constants/extensions/download_extension.dart';
import '../../../../core/utils/constants/api_constants.dart';
import '../../all_books/controller/audio/audio_controller.dart';
import '../widgets/audio_download_progress.dart';

/// امتداد للتحكم في تنزيل ملفات الصوت
/// Extension for handling audio files downloads
extension AudioDownloadExtension on AudioController {
  /// إظهار نافذة سفلية للمستخدم لاختيار طريقة التحميل
  /// Show bottom sheet to user for choosing download method
  Future<void> showDownloadOptions(
      int bookIndex, int chapterIndex, int poemNumber) async {
    if (Get.context == null) return;

    // التحقق إذا كانت هناك عملية تنزيل جارية
    // Check if there's an ongoing download
    if (state.downloading[poemNumber] == true) {
      Get.context!.showCustomErrorSnackBar(
        'جاري تحميل الملف الصوتي، يرجى الانتظار',
      );
      return;
    }

    // عرض مؤشر التقدم إذا كان التحميل جاري للصوت الحالي
    // Show progress indicator if download is in progress for current audio
    if (state.downloading[poemNumber] == true ||
        state.isDownloadingChapter.value) {
      log('جاري التحميل بالفعل للصوت $poemNumber أو للفصل كاملاً',
          name: 'AudioDownloadExtension');
      return; // التحميل قيد التنفيذ بالفعل، العودة بدون فعل أي شيء
    }

    final result = await Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(Get.context!)
                      .colorScheme
                      .secondary
                      .withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              'تحميل الصوت',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'kufi',
                fontWeight: FontWeight.bold,
                color: Theme.of(Get.context!).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'اختر طريقة تحميل ملفات الصوت:',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'naskh',
                color: Theme.of(Get.context!).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            _buildOptionButton(
              title: 'تحميل جميع أبيات الفصل',
              subtitle: 'يتم تحميل ملف مضغوط يحتوي على جميع الأبيات',
              onTap: () => Get.back(result: 'full'),
              icon: Icons.cloud_download_rounded,
            ),
            const SizedBox(height: 12),
            _buildOptionButton(
              title: 'تحميل بيت بيت أثناء التشغيل',
              subtitle: 'تحميل البيت الحالي فقط والأبيات الأخرى عند الحاجة',
              onTap: () => Get.back(result: 'verse'),
              icon: Icons.play_circle_outline_rounded,
            ),
            const SizedBox(height: 12),
            _buildOptionButton(
              title: 'إلغاء',
              onTap: () => Get.back(result: 'cancel'),
              icon: Icons.close_rounded,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
    );

    if (result == 'full') {
      await downloadChapterAudioZip(bookIndex, chapterIndex);
    } else if (result == 'verse') {
      await downloadAudio(poemNumber);
    } else if (result == 'cancel') {
      await state.audioPlayer.stop();
    }
  }

  /// زر خيار في النافذة السفلية
  /// Option button in bottom sheet
  Widget _buildOptionButton({
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required IconData icon,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color ??
                Theme.of(Get.context!).colorScheme.secondary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color ?? Theme.of(Get.context!).colorScheme.secondary,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(Get.context!).colorScheme.primary,
                      fontFamily: 'kufi',
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(Get.context!).colorScheme.secondary,
                        fontFamily: 'naskh',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// إلغاء تحميل ملف صوتي
  /// Cancel audio file download
  Future<void> cancelDownload(int audioId) async {
    try {
      log('إلغاء تحميل الملف الصوتي: $audioId', name: 'AudioDownloadExtension');

      if (audioId == -1) {
        // إلغاء تحميل الفصل الكامل
        // Cancel full chapter download
        state.isDownloadingChapter.value = false;
        state.downloadProgress[-1] = 0.0;
      } else {
        // إلغاء تحميل ملف صوتي محدد
        // Cancel specific audio file download
        state.downloading[audioId] = false;
        state.downloadProgress[audioId] = 0.0;
      }

      // إغلاق نافذة التقدم
      // Close progress dialog
      Get.back();

      // إظهار رسالة للمستخدم
      // Show message to user
      Get.context?.showCustomErrorSnackBar(
        'downloedCancel'.tr,
      );

      update();
    } catch (e) {
      log('خطأ في إلغاء التحميل: $e', name: 'AudioDownloadExtension');
    } finally {
      // إغلاق مؤشر التقدم إذا لم يتم إغلاقه بالفعل
      // Close progress indicator if not already closed
      BotToast.closeAllLoading();
    }
  }

  /// تحميل ملف صوتي بواسطة رقمه
  /// Download audio file by its number
  Future<void> downloadAudio(int audioId, {String? audioUrl}) async {
    try {
      // تعيين حالة التنزيل والتقدم
      // Set download state and progress
      state.downloading[audioId] = true;
      state.downloadProgress[audioId] = 0.0;

      // عرض مؤشر تقدم التنزيل
      // Show download progress indicator
      _showProgressOverlay(audioId);

      update();

      final endpoint = audioUrl ?? '${ApiConstants.zipFilebookUrl}$audioId.mp3';

      // الحصول على رقم الكتاب الحالي
      // Get current book number
      final bookIndex = bookCtrl.state.bookNumber.value - 1;
      final bookKey = bookIndex.toString();

      final cachePath = await appCacheDir;
      final savePath = '$cachePath/book_${bookIndex}_audio_$audioId.mp3';

      // استخدام امتداد التنزيل العام
      // Use the generic download extension
      final success = await downloadFile(
        url: endpoint,
        savePath: savePath,
        showSuccessMessage: true,
        successMessage: 'audioDownloaded'.tr,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            state.downloadProgress[audioId] = (received / total);
            update();
          }

          // التحقق مما إذا تم إلغاء التحميل
          // Check if download was cancelled
          if (!state.downloading[audioId]!) {
            throw Exception('Download cancelled');
          }
        },
        onSuccess: (file) {
          // تحديث قائمة الملفات الصوتية المنزلة مع تضمين رقم الكتاب
          // Update downloaded audio files list including book number
          addDownloadedAudio(bookKey, audioId.toString(), file.path);
          saveDownloadedAudios();
          log('Audio $audioId for book $bookIndex downloaded successfully',
              name: 'AudioDownloadExtension');
        },
        onError: (error) {
          log('Error downloading audio: $error',
              name: 'AudioDownloadExtension');
        },
      );

      if (!success) {
        log('Download failed for audio: $audioId',
            name: 'AudioDownloadExtension');
      }
    } catch (e) {
      log('Error in downloadAudio: $e', name: 'AudioDownloadExtension');
    } finally {
      state.downloading[audioId] = false;
      update();
      // إغلاق مؤشر التقدم
      // Close progress indicator
      BotToast.closeAllLoading();
    }
  }

  /// تحميل وفك ضغط ملف الفصل الكامل
  /// Download and extract full chapter zip file
  Future<bool> downloadChapterAudioZip(int bookIndex, int chapterIndex) async {
    try {
      // تعيين حالة التنزيل للفصل كاملاً
      // Set download state for the whole chapter
      state.isDownloadingChapter.value = true;
      state.downloadProgress[-1] = 0.0; // استخدام -1 كمؤشر للفصل بأكمله

      // عرض مؤشر تقدم التنزيل
      // Show download progress indicator
      _showProgressOverlay(-1);

      update();

      // بناء رابط الملف المضغوط من GitHub
      // Build ZIP file URL from GitHub
      final zipUrl = '${ApiConstants.zipFilebookUrl}$bookIndex.zip?raw=true';
      log('Downloading ZIP file from: $zipUrl', name: 'AudioDownloadExtension');

      final bookKey = bookIndex.toString();
      final cachePath = await appCacheDir;
      final zipSavePath = '$cachePath/chapter_${bookIndex}_$chapterIndex.zip';

      // استخدام امتداد التنزيل العام للملف المضغوط
      // Use generic download extension for ZIP file
      final success = await downloadFile(
        url: zipUrl,
        savePath: zipSavePath,
        showSuccessMessage: false,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            state.downloadProgress[-1] = (received / total);
            update();
          }

          // التحقق مما إذا تم إلغاء التحميل
          // Check if download was cancelled
          if (!state.isDownloadingChapter.value) {
            throw Exception('Download cancelled');
          }
        },
        onError: (error) {
          log('Error downloading ZIP: $error', name: 'AudioDownloadExtension');
          Get.context!.showCustomErrorSnackBar(
            '${'downloedError'.tr} $error',
          );
        },
      );

      if (!success) {
        log('ZIP download failed', name: 'AudioDownloadExtension');
        Get.context?.showCustomErrorSnackBar('errorDownloadedZipFile'.tr);
        return false;
      }

      // التحقق مما إذا تم إلغاء التحميل بعد تنزيل الملف المضغوط
      // Check if download was cancelled after zip file was downloaded
      if (!state.isDownloadingChapter.value) {
        // حذف الملف المضغوط إذا تم إلغاء التحميل
        // Delete the zip file if download was cancelled
        final zipFile = File(zipSavePath);
        if (await zipFile.exists()) {
          await zipFile.delete();
        }
        return false;
      }

      // فك ضغط الملف
      // Extract ZIP file
      final zipFile = File(zipSavePath);
      if (!await zipFile.exists()) {
        log('ZIP file not found at: $zipSavePath',
            name: 'AudioDownloadExtension');
        Get.context?.showCustomErrorSnackBar('zipFileNotFound'.tr);
        return false;
      }

      // قراءة وفك ضغط الأرشيف
      // Read and extract archive
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // استخراج كل ملف في الأرشيف
      // Extract each file in archive
      for (final file in archive) {
        // التحقق مما إذا تم إلغاء التحميل أثناء فك الضغط
        // Check if download was cancelled during extraction
        if (!state.isDownloadingChapter.value) {
          // حذف الملف المضغوط إذا تم إلغاء التحميل
          // Delete the zip file if download was cancelled
          await zipFile.delete();
          return false;
        }

        if (file.isFile) {
          final filename = file.name;
          final data = file.content as List<int>;

          // تحديد رقم البيت من اسم الملف
          // Get verse number from filename
          final poemNumberStr = path.basenameWithoutExtension(filename);
          final poemNumber = int.tryParse(poemNumberStr);

          if (poemNumber != null) {
            // إضافة رقم الكتاب إلى اسم الملف المستخرج
            // Add book number to the extracted file name
            final audioFilePath =
                '$cachePath/book_${bookIndex}_audio_$poemNumber.mp3';
            final audioFile = File(audioFilePath);
            await audioFile.writeAsBytes(data);

            // تحديث قائمة الملفات الصوتية المنزلة مع تضمين رقم الكتاب
            // Update downloaded audio files list with book number
            addDownloadedAudio(bookKey, poemNumber.toString(), audioFilePath);
            log('Extracted audio file: $poemNumber for book $bookIndex',
                name: 'AudioDownloadExtension');
          }
        }
      }

      // حفظ قائمة الملفات وإظهار رسالة نجاح
      // Save files list and show success message
      saveDownloadedAudios();

      // تسجيل الكتاب كمحمل بالكامل
      // Mark the book as fully downloaded
      if (!state.downloadedBooksList.contains(bookIndex)) {
        state.downloadedBooksList.add(bookIndex);
        state.storage
            .write('downloaded_audio_books', state.downloadedBooksList);
      }

      Get.context?.showCustomErrorSnackBar(
        'downloadedSuccess'.tr,
        isDone: true,
      );

      // حذف الملف المضغوط بعد استخراجه لتوفير مساحة التخزين
      // Delete ZIP file after extraction to save storage space
      await zipFile.delete();

      return true;
    } catch (e) {
      log('Error in downloadChapterAudioZip: $e',
          name: 'AudioDownloadExtension');
      Get.context?.showCustomErrorSnackBar(
        '${'errorOrganizedZipFile'.tr} $e',
      );
      return false;
    } finally {
      state.isDownloadingChapter.value = false;
      update();
      // إغلاق مؤشر التقدم
      // Close progress indicator
      BotToast.closeAllLoading();
    }
  }

  /// فحص وتحميل الصوت عند الحاجة
  /// Check and download audio when needed
  Future<bool> checkAndDownloadAudio(
      int bookIndex, int chapterIndex, int poemNumber) async {
    // التحقق إذا كان الكتاب كامل موجود
    // Check if the entire book is downloaded
    if (state.downloadedBooksList.contains(bookIndex)) {
      return true;
    }

    // التحقق إذا كان الصوت موجوداً بالفعل
    // Check if audio already exists
    final bookKey = bookIndex.toString();
    final poemKey = poemNumber.toString();

    final isDownloaded = state.downloadedAudios.containsKey(bookKey) &&
        state.downloadedAudios[bookKey]!.contains(poemKey);

    if (isDownloaded) {
      return true;
    } else {
      // عرض خيارات التحميل للمستخدم
      // Show download options to user
      await showDownloadOptions(bookIndex, chapterIndex, poemNumber);

      // التحقق بعد التحميل
      // Check after download
      return state.downloadedBooksList.contains(bookIndex) ||
          (state.downloadedAudios.containsKey(bookKey) &&
              state.downloadedAudios[bookKey]!.contains(poemKey));
    }
  }

  /// إضافة ملف صوتي منزل إلى القائمة
  /// Add downloaded audio file to the list
  void addDownloadedAudio(String bookKey, String poemKey, String filePath) {
    // تأكد من وجود مفتاح الكتاب في القائمة
    // Ensure book key exists in the map
    if (!state.downloadedAudios.containsKey(bookKey)) {
      state.downloadedAudios[bookKey] = [];
    }

    // إضافة رقم البيت إلى قائمة الكتاب إذا لم يكن موجودًا بالفعل
    // Add poem number to the book's list if not already present
    if (!state.downloadedAudios[bookKey]!.contains(poemKey)) {
      state.downloadedAudios[bookKey]!.add(poemKey);
    }

    update();
  }

  /// حفظ قائمة الملفات الصوتية المنزلة
  /// Save downloaded audio files list
  void saveDownloadedAudios() {
    try {
      // استخدام GetStorage لحفظ القائمة
      // Using GetStorage to save the list
      state.storage.write('downloaded_audios', state.downloadedAudios);
      state.storage.write('downloaded_audio_books', state.downloadedBooksList);

      log('تم حفظ ${state.downloadedAudios.length} كتب صوتية في التخزين',
          name: 'AudioDownloadExtension');
      log('تم حفظ ${state.downloadedBooksList.length} كتب كاملة في التخزين',
          name: 'AudioDownloadExtension');
    } catch (e) {
      log('خطأ في حفظ الملفات الصوتية المحملة: $e',
          name: 'AudioDownloadExtension');
    }
  }

  /// تحميل قائمة الملفات الصوتية المنزلة
  /// Load downloaded audio files list
  void loadDownloadedAudios() {
    try {
      // تحميل قائمة الكتب المحملة بالكامل
      // Load fully downloaded books list
      final downloadedBooks =
          state.storage.read<List<dynamic>>('downloaded_audio_books');
      if (downloadedBooks != null) {
        state.downloadedBooksList.clear();
        state.downloadedBooksList.addAll(downloadedBooks.map((e) => e as int));
      }

      // تحميل قائمة الأبيات المحملة من كل كتاب
      // Load downloaded verses from each book
      final audioMap =
          state.storage.read<Map<String, dynamic>>('downloaded_audios');
      if (audioMap != null) {
        audioMap.forEach((bookKey, value) {
          if (value is List<dynamic>) {
            state.downloadedAudios[bookKey] =
                value.map((e) => e.toString()).toList();
          }
        });
      }

      log('تم تحميل ${state.downloadedAudios.length} كتب صوتية من التخزين',
          name: 'AudioDownloadExtension');
      log('تم تحميل ${state.downloadedBooksList.length} كتب كاملة من التخزين',
          name: 'AudioDownloadExtension');
    } catch (e) {
      log('خطأ في تحميل الملفات الصوتية المحملة: $e',
          name: 'AudioDownloadExtension');
    }
  }

  /// عرض مؤشر تقدم التنزيل
  /// Show download progress indicator
  void _showProgressOverlay(int audioId) {
    // إذا كان السياق غير متاح، لا يمكن عرض أي واجهة
    // If context is not available, cannot show UI
    if (Get.context == null) return;

    // استخدام BotToast لعرض مؤشر التقدم
    // Use BotToast to show progress indicator
    Get.dialog(Dialog(
      alignment: Alignment.center,
      backgroundColor: Colors.transparent,
      child: AudioDownloadProgress(audioId: audioId),
    ));
  }
}
