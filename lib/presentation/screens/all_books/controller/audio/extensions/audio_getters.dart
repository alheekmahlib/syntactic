import 'dart:developer';

import 'package:flutter/animation.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:rxdart/rxdart.dart' as rx;

import '/presentation/screens/all_books/controller/audio/audio_controller.dart';
import '/presentation/screens/all_books/controller/extensions/books_getters.dart';
import '../../../../../../core/utils/constants/constants.dart';
import '../../../../../../core/widgets/seek_bar.dart';

/// امتداد للحصول على قيم من AudioController
/// Extension to get values from AudioController
extension AudioGetters on AudioController {
  /// الحصول على عنوان URL لملف الصوت الحالي
  /// Get the URL for the current audio file
  String get fileUrl {
    try {
      // تأكد من وجود البيانات قبل محاولة إنشاء URL
      // Make sure data exists before attempting to create URL
      if (bookCtrl.state.bookNumber.value <= 0) {
        log('خطأ: رقم الكتاب غير صالح (${bookCtrl.state.bookNumber.value})',
            name: 'AudioGetters');
        return ''; // إرجاع URL فارغ في حالة وجود خطأ
      }

      // استخدم رقم الكتاب الفعلي (بدءًا من 1) للروابط
      // Use actual book number (starting from 1) for URLs
      final bookIndex = bookCtrl.state.bookNumber.value - 1;

      // إضافة 1 لرقم الفصل كما هو مطلوب في هيكل الملفات على السيرفر
      // Add 1 to chapter number as required by server file structure
      final chapterIndex = bookCtrl.state.chapterNumber.value + 1;

      // التحقق من نطاق الفهارس للتأكد من صحتها
      // Check index ranges to ensure they are valid
      if (chapterIndex <= 0 || state.poemNumber.value <= 0) {
        log('خطأ: الفهارس خارج النطاق - الفصل: $chapterIndex، القصيدة: ${state.poemNumber.value}',
            name: 'AudioGetters');
        return ''; // إرجاع URL فارغ في حالة وجود خطأ
      }

      // بناء وإرجاع URL النهائي - استخدام رقم الكتاب الفعلي بدون طرح 1
      // Build and return final URL - using actual book number without subtracting 1
      final url =
          '${Constants.audioUrl}$bookIndex/$chapterIndex/${state.poemNumber.value}.mp3';
      log('رابط ملف الصوت: $url', name: 'AudioGetters');
      return url;
    } catch (e) {
      log('خطأ في إنشاء رابط ملف الصوت: $e', name: 'AudioGetters');
      return ''; // إرجاع URL فارغ في حالة وجود خطأ
    }
  }

  /// الحصول على عدد القصائد في الفصل الحالي
  /// Get the number of poems in the current chapter
  int get poemLength {
    if (bookCtrl.currentPoemBook == null ||
        bookCtrl.currentPoemBook!.chapters == null ||
        bookCtrl.state.chapterNumber.value >=
            bookCtrl.currentPoemBook!.chapters!.length ||
        bookCtrl.currentPoemBook!.chapters![bookCtrl.state.chapterNumber.value]
                .poems ==
            null) {
      log('خطأ: البيانات غير متوفرة للحصول على عدد القصائد',
          name: 'AudioGetters');
      return 0;
    }
    return bookCtrl.currentPoemBook!
        .chapters![bookCtrl.state.chapterNumber.value].poems!.last.poemNumber!;
  }

  /// الحصول على رقم آخر قصيدة في الكتاب
  /// Get the number of the last poem in the book
  int get lastPoemIn {
    if (bookCtrl.currentPoemBook == null ||
        bookCtrl.currentPoemBook!.chapters == null ||
        bookCtrl.currentPoemBook!.chapters!.isEmpty ||
        bookCtrl.currentPoemBook!.chapters!.last.poems == null) {
      log('خطأ: البيانات غير متوفرة للحصول على رقم آخر قصيدة',
          name: 'AudioGetters');
      return 0;
    }
    return bookCtrl.currentPoemBook!.chapters!.last.poems!.last.poemNumber!;
  }

  /// الحصول على رقم أول قصيدة في الفصل الحالي
  /// Get the number of the first poem in the current chapter
  int get firstPoem {
    if (bookCtrl.currentPoemBook == null ||
        bookCtrl.currentPoemBook!.chapters == null ||
        bookCtrl.state.chapterNumber.value >=
            bookCtrl.currentPoemBook!.chapters!.length ||
        bookCtrl.currentPoemBook!.chapters![bookCtrl.state.chapterNumber.value]
                .poems ==
            null) {
      log('خطأ: البيانات غير متوفرة للحصول على رقم أول قصيدة',
          name: 'AudioGetters');
      return 1;
    }
    return bookCtrl.currentPoemBook!
        .chapters![bookCtrl.state.chapterNumber.value].poems!.first.poemNumber!;
  }

  /// الحصول على عدد الفصول في الكتاب الحالي
  /// Get the number of chapters in the current book
  int get lastChapter {
    if (bookCtrl.currentPoemBook == null ||
        bookCtrl.currentPoemBook!.chapters == null) {
      log('خطأ: البيانات غير متوفرة للحصول على عدد الفصول',
          name: 'AudioGetters');
      return 0;
    }
    return bookCtrl.currentPoemBook!.chapters!.length;
  }

  /// الانتقال إلى الصفحة التالية بتأثير متحرك
  /// Navigate to the next page with animation
  void get moveToNextPage {
    final nextPage = bookCtrl.state.chapterNumber.value + 1;
    if (nextPage < lastChapter) {
      bookCtrl.state.pPageController.animateToPage(nextPage,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      log('انتقال إلى الصفحة التالية: $nextPage', name: 'AudioGetters');
    } else {
      log('لا يمكن الانتقال: هذه هي الصفحة الأخيرة', name: 'AudioGetters');
    }
  }

  /// الانتقال إلى الصفحة السابقة بتأثير متحرك
  /// Navigate to the previous page with animation
  void get moveToPreviousPage {
    final prevPage = bookCtrl.state.chapterNumber.value - 1;
    if (prevPage >= 0) {
      bookCtrl.state.pPageController.animateToPage(prevPage,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
      log('انتقال إلى الصفحة السابقة: $prevPage', name: 'AudioGetters');
    } else {
      log('لا يمكن الانتقال: هذه هي الصفحة الأولى', name: 'AudioGetters');
    }
  }

  /// الحصول على تدفق بيانات موقع التشغيل (الوقت الحالي، التخزين المؤقت، المدة الكلية)
  /// Get stream of position data (current position, buffered position, total duration)
  Stream<PositionData> get positionDataStream =>
      rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          state.audioPlayer.positionStream,
          state.audioPlayer.bufferedPositionStream,
          state.audioPlayer.durationStream,
          (position, bufferedPosition, duration) {
        log('تحديث بيانات الموقع - الوقت: ${position.inSeconds}s',
            name: 'AudioGetters');
        return PositionData(
            position, bufferedPosition, duration ?? Duration.zero);
      });

  /// التحقق ما إذا كان الملف الصوتي متاح
  /// Check if the audio file is available
  Future<bool> get isAudioFileAvailable async {
    try {
      // يمكنك تنفيذ عملية فحص توفر الملف هنا
      // You can implement a check for file availability here
      return true;
    } catch (e) {
      log('خطأ في التحقق من توفر ملف الصوت: $e', name: 'AudioGetters');
      return false;
    }
  }

  /// الحصول على نص وصف للموضع الحالي للتشغيل
  /// Get a formatted text description of the current playback position
  String get currentPositionText {
    final position = state.audioPlayer.position;
    final duration = state.audioPlayer.duration ?? Duration.zero;

    final posMin = position.inMinutes;
    final posSec = position.inSeconds % 60;
    final durMin = duration.inMinutes;
    final durSec = duration.inSeconds % 60;

    return '$posMin:${posSec.toString().padLeft(2, '0')} / '
        '$durMin:${durSec.toString().padLeft(2, '0')}';
  }

  /// الحصول على مسار مجلد التخزين المؤقت للتطبيق
  /// Get application cache directory path
  Future<String> get appCacheDir async {
    try {
      // استيراد المكتبة هنا لتجنب الاستيراد الدائري
      // Import library here to avoid circular import

      final dir = await path_provider.getApplicationCacheDirectory();
      final cachePath = dir.path;
      log('App cache directory: $cachePath', name: 'AudioGetters');

      return cachePath;
    } catch (e) {
      log('Error getting cache directory: $e', name: 'AudioGetters');
      throw Exception('Could not access application cache directory');
    }
  }
}
