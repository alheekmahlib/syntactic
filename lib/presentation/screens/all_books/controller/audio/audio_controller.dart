import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '/core/utils/constants/extensions/custom_error_snack_bar.dart';
import '/presentation/screens/all_books/controller/audio/extensions/audio_getters.dart';
import '/presentation/screens/audio_player/extensions/audio_download_extension.dart';
import '../books_controller.dart';
import '../extensions/books_getters.dart';
import 'audio_state.dart';

class AudioController extends GetxController {
  static AudioController get instance => Get.isRegistered<AudioController>()
      ? Get.find<AudioController>()
      : Get.put(AudioController());

  final bookCtrl = AllBooksController.instance;
  AudioState state = AudioState();

  @override
  Future<void> onInit() async {
    // تهيئة المشغل الصوتي وإعداد قائمة التشغيل
    // Initialize audio player and setup playlist
    super.onInit();

    // تحميل قائمة الملفات الصوتية المنزلة مسبقاً
    // Load previously downloaded audio files list
    loadDownloadedAudios();

    createPlayList();
    await subscribeToPlayerState();
    await initializePlayer();
    log('تم تهيئة مشغل الصوت بنجاح', name: 'AudioController');
  }

  @override
  void onClose() {
    // إيقاف وتحرير موارد المشغل الصوتي عند إغلاق الصفحة
    // Stop and dispose audio player resources on page close
    state.audioPlayer.pause();
    state.audioPlayer.dispose();
    state.playerStateSubscription?.cancel();
    log('تم تحرير موارد مشغل الصوت', name: 'AudioController');
    super.onClose();
  }

  // قائمة التشغيل الصوتية المتسلسلة للفصول
  // Concatenated audio source for chapters playlist
  late final chapterList = ConcatenatingAudioSource(
    // تحميل العنصر التالي قبل الوصول إليه
    // Start loading next item just before reaching it
    useLazyPreparation: true,
    // تخصيص خوارزمية العشوائية
    // Customise the shuffle algorithm
    shuffleOrder: DefaultShuffleOrder(),
    // تحديد عناصر قائمة التشغيل
    // Specify the playlist items
    children: state.chaptersPlayList ?? [],
  );

  /// إنشاء قائمة تشغيل للقصائد
  /// Create playlist for poems
  void createPlayList() {
    state.chaptersPlayList = List.generate(poemLength, (i) {
      state.poemNumber.value = i + 1;
      return AudioSource.uri(
        Uri.parse(fileUrl),
        tag: {'poemNumber': state.poemNumber.value},
      );
    });
    log('تم إنشاء قائمة التشغيل: $fileUrl', name: 'AudioController');
  }

  /// تغيير مصدر الصوت الحالي
  /// Change current audio source
  Future<void> changeAudioSource() async {
    try {
      // التحقق من صلاحية URL قبل محاولة تعيينه
      // Check URL validity before attempting to set it
      if (fileUrl.isEmpty) {
        state.errorMessage.value = 'عنوان ملف الصوت غير صالح';
        log('خطأ: تم محاولة تعيين مصدر صوت بURL فارغ', name: 'AudioController');
        state.isLoading.value = false;
        return;
      }

      log('تغيير مصدر الصوت: $fileUrl', name: 'AudioController');

      // تعيين حالة التحميل إلى نشطة
      // Set loading state to active
      state.isLoading.value = true;
      state.errorMessage.value = '';

      // حفظ رقم الفصل الحالي
      // Save current chapter number
      state.lastChapterNumber.value = bookCtrl.state.chapterNumber.value;

      // التحقق مما إذا كان الصوت متاحًا محليًا
      // Check if audio is available locally
      final poemId = state.poemNumber.value;
      final bookIndex = bookCtrl.state.bookNumber.value - 1;
      final bookKey = bookIndex.toString();
      final poemKey = poemId.toString();
      final chapterIndex = bookCtrl.state.chapterNumber.value + 1;

      final bool hasFullBook = state.downloadedBooksList.contains(bookIndex);
      final bool hasSpecificVerse =
          state.downloadedAudios.containsKey(bookKey) &&
              state.downloadedAudios[bookKey]!.contains(poemKey);

      // تحديد مسار الملف المحلي
      // Determine local file path
      final cachePath = await appCacheDir;
      final localPath = '$cachePath/book_${bookIndex}_audio_$poemId.mp3';
      final file = File(localPath);

      // إذا كان الملف موجودًا محليًا، استخدمه
      // If file exists locally, use it
      if ((hasFullBook || hasSpecificVerse) && await file.exists()) {
        log('استخدام ملف صوتي محلي: $localPath', name: 'AudioController');
        await state.audioPlayer.setFilePath(localPath);
      }
      // إذا لم يكن الملف متوفرًا، اعرض خيارات التحميل
      // If file is not available, show download options
      else {
        final isDownloaded =
            await checkAndDownloadAudio(bookIndex, chapterIndex, poemId);

        if (isDownloaded) {
          // إعادة المحاولة بعد التحميل
          // Retry after download
          final newLocalPath = '$cachePath/book_${bookIndex}_audio_$poemId.mp3';
          final newFile = File(newLocalPath);

          if (await newFile.exists()) {
            log('استخدام ملف صوتي تم تحميله حديثًا: $newLocalPath',
                name: 'AudioController');
            await state.audioPlayer.setFilePath(newLocalPath);
          } else {
            // استخدام الملف من الإنترنت كخيار أخير
            // Use file from internet as last resort
            log('تحميل الملف الصوتي من الإنترنت: $fileUrl',
                name: 'AudioController');
            await state.audioPlayer
                .setAudioSource(AudioSource.uri(Uri.parse(fileUrl)));
          }
        } else {
          // فشل التحميل، استخدام الملف من الإنترنت كخيار أخير
          // Download failed, use file from internet as last resort
          log('تحميل الملف الصوتي من الإنترنت: $fileUrl',
              name: 'AudioController');
          await state.audioPlayer
              .setAudioSource(AudioSource.uri(Uri.parse(fileUrl)));
        }
      }

      state.isLoading.value = false;
    } catch (e) {
      state.isLoading.value = false;
      state.errorMessage.value = 'فشل في تحميل الملف الصوتي';
      log('خطأ في تغيير مصدر الصوت: $e', name: 'AudioController');

      // محاولة استرجاع الوضع السابق إذا كان ذلك ممكناً
      // Try to recover to previous state if possible
      if (state.lastChapterNumber.value != bookCtrl.state.chapterNumber.value) {
        log('محاولة استرجاع الوضع السابق بعد الفشل', name: 'AudioController');
      }
    }
  }

  /// تهيئة مشغل الصوت وإعداده
  /// Initialize audio player and prepare it
  Future<void> initializePlayer() async {
    try {
      // ضبط مستوى الصوت الافتراضي
      // Set default volume
      await state.audioPlayer.setVolume(1.0);

      // تهيئة المشغل بقائمة التشغيل
      // Initialize player with playlist
      if (state.chaptersPlayList != null &&
          state.chaptersPlayList!.isNotEmpty) {
        await state.audioPlayer.setAudioSource(chapterList);
      } else {
        await changeAudioSource();
      }

      log('تم تهيئة مشغل الصوت بنجاح', name: 'AudioController');
    } catch (e) {
      log('خطأ أثناء تهيئة مشغل الصوت: $e', name: 'AudioController');
    }
  }

  /// الاشتراك في حالة المشغل لمعالجة الأحداث كإنتهاء التشغيل
  /// Subscribe to player state to handle events like playback completion
  Future<void> subscribeToPlayerState() async {
    state.playerStateSubscription =
        state.audioPlayer.playerStateStream.listen((playerState) async {
      // تحديث حالة التشغيل
      // Update playing state
      state.isPlaying.value = playerState.playing;

      // معالجة حالة الانتهاء من تشغيل المقطع الصوتي
      // Handle completion of audio playback
      if (playerState.processingState == ProcessingState.completed) {
        log('انتهى تشغيل المقطع الصوتي', name: 'AudioController');
        if (bookCtrl.state.chapterNumber.value == lastChapter) {
          // إذا كان هذا آخر فصل، قم بإيقاف التشغيل
          // If this is the last chapter, stop playback
          await state.audioPlayer.stop();
        } else {
          // انتقل إلى القصيدة التالية
          // Move to the next poem
          await seekToNextPoem();
        }
      }
    });
  }

  /// الانتقال إلى القصيدة التالية
  /// Navigate to the next poem
  Future<void> seekToNextPoem() async {
    try {
      // تأكد من عدم وجود عملية تحميل جارية
      // Make sure there is no ongoing loading operation
      if (state.isLoading.value) {
        log('جاري تحميل الصوت، يرجى الانتظار', name: 'AudioController');
        return;
      }

      // حالة خاصة للكتاب الأول
      // Special case for the first book
      if (bookCtrl.state.bookNumber.value - 1 == 0 &&
          state.poemNumber.value == lastPoemIn - 3) {
        log('وصلنا لنهاية قصائد الكتاب الأول الخاصة', name: 'AudioController');
        await state.audioPlayer.stop();
        return;
      }

      // إذا وصلنا إلى آخر قصيدة في الكتاب
      // If we reached the last poem in the book
      else if (state.poemNumber.value == lastPoemIn) {
        log('وصلنا لآخر قصيدة في الكتاب', name: 'AudioController');
        await state.audioPlayer.stop();
        return;
      }

      // إذا كانت هذه آخر قصيدة في الفصل الحالي، انتقل إلى الفصل التالي
      // If this is the last poem in the current chapter, move to the next chapter
      else if (state.poemNumber.value == poemLength) {
        log('انتقال إلى الفصل التالي', name: 'AudioController');

        // انتقال بصري إلى الفصل التالي
        // Visual transition to next chapter
        moveToNextPage;

        // زيادة رقم الفصل والانتقال إلى القصيدة الأولى في الفصل الجديد
        // Increment chapter number and move to the first poem in new chapter
        final nextChapter = bookCtrl.state.chapterNumber.value + 1;
        bookCtrl.state.chapterNumber.value = nextChapter;
        bookCtrl.state.selectedPoemIndex.value = 0;

        // انتظار لحظة قصيرة للتأكد من تحديث واجهة المستخدم
        // Wait a moment to ensure UI updates
        await Future.delayed(const Duration(milliseconds: 300));

        try {
          log('محاولة الحصول على القصيدة الأولى في الفصل: $nextChapter',
              name: 'AudioController');

          // إعادة ضبط رقم القصيدة إلى 1 (أو الرقم المناسب للقصيدة الأولى)
          // Reset poem number to 1 (or appropriate number for first poem)
          state.poemNumber.value = bookCtrl
              .currentPoemBook!.chapters![nextChapter].poems!.first.poemNumber!;

          log('تشغيل القصيدة الأولى في الفصل الجديد: ${state.poemNumber.value}',
              name: 'AudioController');

          // إعادة إنشاء قائمة التشغيل للفصل الجديد
          // Recreate playlist for the new chapter
          await changeAudioSource();

          // إذا لم يكن هناك أخطاء، قم بالتشغيل
          // If there are no errors, play
          if (state.errorMessage.isEmpty) {
            await state.audioPlayer.play();
          } else {
            // محاولة معالجة حالة عدم وجود الملف
            // Try to handle file not found
            await handleFileNotFound();
          }
        } catch (e) {
          log('خطأ أثناء محاولة تشغيل أول قصيدة في الفصل الجديد: $e',
              name: 'AudioController');
          await handleFileNotFound();
        }
      }

      // انتقال للقصيدة التالية ضمن نفس الفصل
      // Move to the next poem within the same chapter
      else {
        log('انتقال إلى القصيدة التالية: ${state.poemNumber.value + 1}',
            name: 'AudioController');
        state.poemNumber.value += 1;
        bookCtrl.state.selectedPoemIndex.value += 1;

        await changeAudioSource();
        if (state.errorMessage.isEmpty) {
          await state.audioPlayer.play();
        } else {
          // محاولة معالجة حالة عدم وجود الملف
          // Try to handle file not found
          await handleFileNotFound();
        }
      }
    } catch (e) {
      log('خطأ أثناء الانتقال للقصيدة التالية: $e', name: 'AudioController');
      await handleFileNotFound();
    }
  }

  /// الانتقال إلى القصيدة السابقة
  /// Navigate to the previous poem
  Future<void> seekToPrevious() async {
    try {
      // تأكد من عدم وجود عملية تحميل جارية
      // Make sure there is no ongoing loading operation
      if (state.isLoading.value) {
        log('جاري تحميل الصوت، يرجى الانتظار', name: 'AudioController');
        return;
      }

      // إذا كنا في أول قصيدة من الفصل، انتقل إلى الفصل السابق
      // If we are at the first poem of the chapter, move to the previous chapter
      if (state.poemNumber.value <= firstPoem) {
        // تأكد من أننا لسنا في الفصل الأول
        // Make sure we're not in the first chapter
        if (bookCtrl.state.chapterNumber.value > 0) {
          log('انتقال إلى الفصل السابق', name: 'AudioController');

          // انتقال بصري إلى الفصل السابق
          // Visual transition to previous chapter
          moveToPreviousPage;

          // خفض رقم الفصل
          // Decrement chapter number
          final prevChapter = bookCtrl.state.chapterNumber.value - 1;
          bookCtrl.state.chapterNumber.value = prevChapter;

          // انتظار لحظة قصيرة للتأكد من تحديث واجهة المستخدم
          // Wait a moment to ensure UI updates
          await Future.delayed(const Duration(milliseconds: 300));

          try {
            log('محاولة الحصول على المعلومات لآخر قصيدة في الفصل السابق',
                name: 'AudioController');

            // قم بتعيين رقم القصيدة إلى قيمة مرتفعة لآخر قصيدة
            // Set poem number to a high value for the last poem
            state.poemNumber.value =
                poemLength; // استخدم poemLength الجديد بعد تغيير الفصل

            // تعيين مؤشر القصيدة المحددة
            // Set selected poem index
            int lastIndex = 0;
            try {
              // محاولة الحصول على عدد القصائد في الفصل السابق
              // Try to get the number of poems in previous chapter
              lastIndex = bookCtrl
                      .currentPoemBook!.chapters![prevChapter].poems!.length -
                  1;
            } catch (e) {
              log('تعذر حساب المؤشر بدقة، استخدام القيمة الافتراضية',
                  name: 'AudioController');
              lastIndex = 0;
            }

            bookCtrl.state.selectedPoemIndex.value = lastIndex;

            log('تشغيل آخر قصيدة في الفصل السابق: ${state.poemNumber.value}',
                name: 'AudioController');

            // إعادة إنشاء قائمة التشغيل للفصل الجديد
            // Recreate playlist for the new chapter
            createPlayList();
            await changeAudioSource();

            // إذا لم يكن هناك أخطاء، قم بالتشغيل
            // If there are no errors, play
            if (state.errorMessage.isEmpty) {
              await state.audioPlayer.play();
            } else {
              // محاولة معالجة حالة عدم وجود الملف
              // Try to handle file not found
              await handleFileNotFound();
            }
          } catch (e) {
            log('خطأ أثناء محاولة تشغيل آخر قصيدة في الفصل السابق: $e',
                name: 'AudioController');
            await handleFileNotFound();
          }
        } else {
          log('نحن بالفعل في أول فصل وأول قصيدة', name: 'AudioController');
        }
      }

      // انتقال للقصيدة السابقة ضمن نفس الفصل
      // Move to the previous poem within the same chapter
      else {
        log('انتقال إلى القصيدة السابقة: ${state.poemNumber.value - 1}',
            name: 'AudioController');
        state.poemNumber.value -= 1;
        bookCtrl.state.selectedPoemIndex.value -= 1;

        await changeAudioSource();
        // إذا لم يكن هناك أخطاء، قم بالتشغيل
        // If there are no errors, play
        if (state.errorMessage.isEmpty) {
          await state.audioPlayer.play();
        } else {
          // محاولة معالجة حالة عدم وجود الملف
          // Try to handle file not found
          await handleFileNotFound();
        }
      }
    } catch (e) {
      log('خطأ أثناء الانتقال للقصيدة السابقة: $e', name: 'AudioController');
      await handleFileNotFound();
    }
  }

  /// معالجة التغييرات في دورة حياة التطبيق
  /// Handle app lifecycle state changes
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    switch (appState) {
      case AppLifecycleState.paused:
        // إيقاف التشغيل مؤقتاً عند مغادرة التطبيق
        // Pause playback when app goes to background
        if (state.isPlaying.value) {
          state.audioPlayer.pause();
          log('تم إيقاف تشغيل الصوت مؤقتاً (التطبيق في الخلفية)',
              name: 'AudioController');
        }
        break;
      case AppLifecycleState.resumed:
        // إمكانية استئناف التشغيل عند العودة للتطبيق (يمكن تعديل الشرط حسب تجربة المستخدم)
        // Option to resume playback when app comes to foreground (condition can be modified based on UX preference)
        // if (state.isPlaying.value) {
        //   state.audioPlayer.play();
        //   log('تم استئناف تشغيل الصوت (العودة للتطبيق)', name: 'AudioController');
        // }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      default:
        // معالجة الحالات الأخرى إذا لزم الأمر
        // Handle other states if needed
        break;
    }
    log('حالة دورة حياة التطبيق = $appState', name: 'AudioController');
  }

  /// تشغيل أو إيقاف مؤقت
  /// Play or pause
  Future<void> togglePlayPause() async {
    try {
      if (state.isPlaying.value) {
        // إيقاف مؤقت إذا كان قيد التشغيل
        // Pause if currently playing
        await state.audioPlayer.pause();
        state.isPlaying.value = false;
        log('تم إيقاف التشغيل مؤقتاً', name: 'AudioController');
      } else {
        // تشغيل إذا لم يكن قيد التشغيل
        // Play if not playing

        // التحقق مما إذا كان الملف متوفر محليًا
        // Check if audio file is available locally
        final poemId = state.poemNumber.value;
        final bookIndex = bookCtrl.state.bookNumber.value - 1;
        final bookKey = bookIndex.toString();
        final poemKey = poemId.toString();
        final chapterIndex = bookCtrl.state.chapterNumber.value + 1;

        final bool hasFullBook = state.downloadedBooksList.contains(bookIndex);
        final bool hasSpecificVerse =
            state.downloadedAudios.containsKey(bookKey) &&
                state.downloadedAudios[bookKey]!.contains(poemKey);

        // تحديد مسار الملف المحلي
        // Determine local file path
        final cachePath = await appCacheDir;
        final localPath = '$cachePath/book_${bookIndex}_audio_$poemId.mp3';
        final file = File(localPath);

        // إذا كان الملف غير متوفر محليًا، عرض خيارات التحميل
        // If file not available locally, show download options
        if (!(hasFullBook || hasSpecificVerse) || !await file.exists()) {
          log('الملف الصوتي غير متوفر محلياً. عرض خيارات التحميل.',
              name: 'AudioController');
          await showDownloadOptions(bookIndex, chapterIndex, poemId);

          // التحقق مرة أخرى بعد عرض خيارات التحميل
          // Check again after showing download options
          if ((state.downloadedBooksList.contains(bookIndex) ||
                  (state.downloadedAudios.containsKey(bookKey) &&
                      state.downloadedAudios[bookKey]!.contains(poemKey))) &&
              await file.exists()) {
            await changeAudioSource(); // تحديث مصدر الصوت بعد التحميل
            await state.audioPlayer.play();
            state.isPlaying.value = true;
          }
        } else {
          // إذا كان الملف متوفر، قم بتشغيله مباشرة
          // If file exists, play it directly
          await state.audioPlayer.play();
          state.isPlaying.value = true;
          log('تم بدء التشغيل', name: 'AudioController');
        }
      }
    } catch (e) {
      log('خطأ أثناء تشغيل/إيقاف الصوت: $e', name: 'AudioController');
    }
  }

  /// التحكم بمستوى الصوت
  /// Control volume
  Future<void> setVolume(double volume) async {
    try {
      if (volume < 0) volume = 0;
      if (volume > 1) volume = 1;

      await state.audioPlayer.setVolume(volume);
      log('تم تعديل مستوى الصوت: $volume', name: 'AudioController');
    } catch (e) {
      log('خطأ أثناء تعديل مستوى الصوت: $e', name: 'AudioController');
    }
  }

  /// إعادة تحميل الملف الصوتي الحالي في حالة حدوث خطأ
  /// Reload current audio file in case of error
  Future<void> retryLoadAudio() async {
    try {
      state.errorMessage.value = '';
      await changeAudioSource();
      if (state.errorMessage.isEmpty) {
        await state.audioPlayer.play();
      }
    } catch (e) {
      log('فشلت محاولة إعادة تحميل الملف الصوتي: $e', name: 'AudioController');
    }
  }

  /// معالجة حالة تعذر العثور على الملف الصوتي
  /// Handle case when audio file is not found
  Future<void> handleFileNotFound() async {
    try {
      // الملف غير موجود بالموقع الأصلي، يمكن تجربة مسار بديل
      // File not found at the original location, try an alternative path
      log('الملف غير موجود بالمسار الأصلي، محاولة استخدام مسار بديل',
          name: 'AudioController');

      // يجب ضبط رقم القصيدة على 1 في حالة الانتقال لفصل جديد
      // Set poem number to 1 when moving to a new chapter
      if (state.lastChapterNumber.value != bookCtrl.state.chapterNumber.value) {
        state.poemNumber.value = 1;
        log('تم إعادة ضبط رقم القصيدة إلى 1 للفصل الجديد',
            name: 'AudioController');

        // إعادة محاولة التشغيل بعد ضبط رقم القصيدة
        // Retry playback after setting poem number
        await Future.delayed(const Duration(milliseconds: 300));
        await changeAudioSource();

        // محاولة التشغيل بعد تغيير المصدر
        // Try playback after changing source
        if (state.errorMessage.isEmpty) {
          await state.audioPlayer.play();
        }
      } else {
        // محاولة القصيدة التالية إذا كانت متوفرة
        // Try next poem if available
        if (state.poemNumber.value < poemLength) {
          log('محاولة تشغيل القصيدة التالية', name: 'AudioController');
          state.poemNumber.value += 1;
          await changeAudioSource();

          if (state.errorMessage.isEmpty) {
            await state.audioPlayer.play();
          }
        } else {
          // إظهار رسالة للمستخدم
          // Show message to user
          state.errorMessage.value = 'ملف الصوت غير متوفر';
          Get.context!.showCustomErrorSnackBar(
            'noAudioFile'.tr,
          );
        }
      }
    } catch (e) {
      log('فشل في معالجة حالة عدم وجود الملف: $e', name: 'AudioController');

      // إظهار رسالة للمستخدم في حالة الفشل
      // Show message to user in case of failure
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء محاولة تشغيل الملف الصوتي',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  /// التحقق من حالة التشغيل الحالية
  /// Check current playback status
  void checkPlaybackStatus() {
    if (state.lastChapterNumber.value != bookCtrl.state.chapterNumber.value) {
      // تغير رقم الفصل - قد يلزم تحديث الصوت
      // Chapter number changed - might need to update audio
      log('تم اكتشاف تغيير في رقم الفصل، جاري تحديث الصوت',
          name: 'AudioController');
      state.poemNumber.value = 1; // البدء من أول قصيدة في الفصل الجديد
      changeAudioSource();
    }
  }
}
