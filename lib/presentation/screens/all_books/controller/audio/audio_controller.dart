import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '/core/services/connectivity_service.dart'; // استيراد خدمة التحقق من الاتصال بالإنترنت
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
      final cachePath = await appCacheDir;
      final localPath = '$cachePath/book_${bookIndex}_audio_$poemId.mp3';
      final file = File(localPath);

      // متغير لتحديد إذا كان التشغيل من ملف محلي
      // Variable to determine if playing from local file
      state.isPlayingFromLocal = false;

      // أوقف المشغل قبل تعيين مصدر جديد
      // Stop the player before setting a new source
      await state.audioPlayer.stop();
      log('تم إيقاف المشغل قبل تعيين المصدر الجديد', name: 'AudioController');

      if ((hasFullBook || hasSpecificVerse) && await file.exists()) {
        // تحقق من حجم الملف قبل محاولة التشغيل
        // Check file size before trying to play
        final fileSize = await file.length();
        log('حجم الملف الصوتي المحلي: $fileSize بايت', name: 'AudioController');
        if (fileSize < 1024) {
          // الملف تالف أو غير صالح
          // File is corrupted or invalid
          log('الملف الصوتي تالف أو صغير جداً، سيتم حذف الملف ولن يتم التشغيل',
              name: 'AudioController');
          state.errorMessage.value =
              'الملف الصوتي غير صالح، يرجى إعادة التحميل';
          await file.delete();
          state.isLoading.value = false;
          Get.context?.showCustomErrorSnackBar(
              'الملف الصوتي غير صالح، يرجى إعادة التحميل');
          return;
        }
        // فحص صلاحية الملف mp3
        // Check mp3 file validity
        final isValid = await isValidMp3File(file);
        if (!isValid) {
          log('الملف الصوتي ليس mp3 صالح (header غير صحيح)، سيتم حذف الملف ولن يتم التشغيل',
              name: 'AudioController');
          state.errorMessage.value =
              'الملف الصوتي غير صالح، يرجى إعادة التحميل';
          await file.delete();
          state.isLoading.value = false;
          Get.context?.showCustomErrorSnackBar(
              'الملف الصوتي غير صالح، يرجى إعادة التحميل');
          return;
        }
        log('استخدام ملف صوتي محلي: $localPath', name: 'AudioController');
        await state.audioPlayer.setFilePath(localPath);
        log('تم تعيين ملف محلي كمصدر للصوت', name: 'AudioController');
        state.isPlayingFromLocal = true; // تشغيل من ملف محلي
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
            log('تم تعيين الملف الذي تم تحميله كمصدر للصوت',
                name: 'AudioController');
            state.isPlayingFromLocal = true;
          } else {
            log('تحميل الملف الصوتي من الإنترنت: $fileUrl',
                name: 'AudioController');
            await state.audioPlayer
                .setAudioSource(AudioSource.uri(Uri.parse(fileUrl)));
            log('تم تعيين مصدر الإنترنت كمصدر للصوت', name: 'AudioController');
          }
        } else {
          log('تحميل الملف الصوتي من الإنترنت: $fileUrl',
              name: 'AudioController');
          await state.audioPlayer
              .setAudioSource(AudioSource.uri(Uri.parse(fileUrl)));
          log('تم تعيين مصدر الإنترنت كمصدر للصوت', name: 'AudioController');
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
    // تجنب الاشتراكات المتكررة عن طريق إلغاء أي اشتراك سابق
    // Avoid multiple subscriptions by cancelling any previous subscription
    await state.playerStateSubscription?.cancel();

    state.playerStateSubscription =
        state.audioPlayer.playerStateStream.listen((playerState) async {
      // تحديث حالة التشغيل
      // Update playing state
      state.isPlaying.value = playerState.playing;

      // إذا انتهى التشغيل
      // If playback completed
      if (playerState.processingState == ProcessingState.completed) {
        log('انتهى تشغيل المقطع الصوتي', name: 'AudioController');
        // مباشرة انتقل للبيت التالي إذا لم نصل للنهاية
        // Directly move to next poem if not at the end
        if (state.audioPlayer.processingState == ProcessingState.completed) {
          if (bookCtrl.state.chapterNumber.value == lastChapter) {
            // إذا كان هذا آخر فصل، قم بإيقاف التشغيل
            // If this is the last chapter, stop playback
            await state.audioPlayer.stop();
          } else {
            // التحقق من توفر البيت التالي
            // Check availability of next poem
            final nextPoemNumber = state.poemNumber.value + 1;
            if (nextPoemNumber <= poemLength) {
              final bookIndex = bookCtrl.state.bookNumber.value - 1;
              final bookKey = bookIndex.toString();
              final nextPoemKey = nextPoemNumber.toString();
              final cachePath = await appCacheDir;
              final localPath =
                  '$cachePath/book_${bookIndex}_audio_$nextPoemNumber.mp3';
              final file = File(localPath);
              final bool hasFullBook =
                  state.downloadedBooksList.contains(bookIndex);
              final bool hasSpecificVerse =
                  state.downloadedAudios.containsKey(bookKey) &&
                      state.downloadedAudios[bookKey]!.contains(nextPoemKey);
              if ((hasFullBook || hasSpecificVerse) && await file.exists()) {
                log('الملف التالي متوفر، الانتقال إلى البيت التالي: $nextPoemNumber',
                    name: 'AudioController');
                await seekToNextPoem();
              } else {
                log('الملف التالي غير متوفر محليًا، إيقاف التشغيل التلقائي',
                    name: 'AudioController');
                state.isPlaying.value = false;
                await state.audioPlayer.pause();
              }
            } else {
              log('الوصول إلى نهاية الفصل، إيقاف التشغيل الآلي',
                  name: 'AudioController');
              await seekToNextPoem();
            }
          }
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
      // if (bookCtrl.state.bookNumber.value - 1 == 0 &&
      //     state.poemNumber.value == lastPoemInBook - 3) {
      //   log('وصلنا لنهاية قصائد الكتاب الأول الخاصة', name: 'AudioController');
      //   await state.audioPlayer.stop();
      //   return;
      // }

      // إذا وصلنا إلى آخر قصيدة في الكتاب
      // If we reached the last poem in the book
      else if (state.poemNumber.value == lastPoemInBook) {
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

          // التحقق من توفر الملف الصوتي للبيت الأول في الفصل الجديد
          // Check if audio file is available for the first poem in the new chapter
          final poemId = state.poemNumber.value;
          final bookIndex = bookCtrl.state.bookNumber.value - 1;
          final bookKey = bookIndex.toString();
          final poemKey = poemId.toString();

          final cachePath = await appCacheDir;
          final localPath = '$cachePath/book_${bookIndex}_audio_$poemId.mp3';
          final file = File(localPath);

          final bool hasFullBook =
              state.downloadedBooksList.contains(bookIndex);
          final bool hasSpecificVerse =
              state.downloadedAudios.containsKey(bookKey) &&
                  state.downloadedAudios[bookKey]!.contains(poemKey);

          // فقط تشغيل الملف إذا كان متوفرًا محليًا وبدون أخطاء
          // Only play file if available locally and no errors
          if ((hasFullBook || hasSpecificVerse) &&
              await file.exists() &&
              state.errorMessage.isEmpty) {
            log('ملف الفصل الجديد متوفر محليًا، بدء التشغيل',
                name: 'AudioController');
            await state.audioPlayer.play();
          } else {
            // الملف غير متوفر، إيقاف التشغيل التلقائي
            // File not available, stop auto-play
            log('ملف الفصل الجديد غير متوفر محليًا أو هناك خطأ، لن يتم التشغيل تلقائيًا',
                name: 'AudioController');
            state.isPlaying.value = false;
            await state.audioPlayer.pause();
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

        // تغيير مصدر الصوت للبيت الجديد
        // Change audio source for the new poem
        await changeAudioSource();

        // تشغيل البيت الجديد مباشرة بعد تغيير المصدر
        // Play the new poem immediately after changing the source
        if (state.errorMessage.isEmpty) {
          await state.audioPlayer.play();
          log('تم تشغيل البيت الجديد تلقائياً', name: 'AudioController');
        } else {
          log('تعذر تشغيل البيت الجديد بسبب خطأ: \\${state.errorMessage.value}',
              name: 'AudioController');
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
        state.isPlaying.value = false;
        await state.audioPlayer.pause();
        log('تم إيقاف التشغيل مؤقتاً', name: 'AudioController');
      } else {
        // تشغيل إذا لم يكن قيد التشغيل
        // Play if not playing

        // التحقق مما إذا كان الملف متوفر محليًا أو الكتاب كله محمّل
        // Check if audio file or full book is downloaded
        final poemId = state.poemNumber.value;
        final bookIndex = bookCtrl.state.bookNumber.value - 1;
        // final bookKey = bookIndex.toString();
        // final poemKey = poemId.toString();
        final chapterIndex = bookCtrl.state.chapterNumber.value + 1;

        final bool hasFullBook = state.downloadedBooksList.contains(bookIndex);
        final hasSpecificVerse =
            await checkAndDownloadAudio(bookIndex, chapterIndex, poemId);
        // final bool hasSpecificVerse =
        //     state.downloadedAudios.containsKey(bookKey) &&
        //         state.downloadedAudios[bookKey]!.contains(poemKey);

        // تحديد مسار الملف المحلي
        // Determine local file path
        final cachePath = await appCacheDir;
        final localPath = '$cachePath/book_${bookIndex}_audio_$poemId.mp3';
        final file = File(localPath);

        // إذا كان البيت أو الكتاب محمّلًا بالكامل، شغّل مباشرة بدون نافذة تحميل
        // If poem or full book is downloaded, play directly without download dialog

        // إذا لم يكن محمّلًا، تحقق من وجود الإنترنت
        // If not downloaded, check for internet connection
        if ((hasFullBook || hasSpecificVerse) || await file.exists()) {
          state.isPlaying.value = true;
          await state.audioPlayer.play();
          log('تم بدء التشغيل مباشرة لأن الملف محمّل', name: 'AudioController');
        } else if (ConnectivityService.instance.noConnection.value) {
          // لا يوجد إنترنت، أظهر رسالة خطأ
          // No internet, show error message
          Get.context!.showCustomErrorSnackBar('noInternet'.tr);
          log('لا يوجد اتصال بالإنترنت، لا يمكن التحميل',
              name: 'AudioController');
          return;
        } else {
          // يوجد إنترنت، أظهر نافذة خيارات التحميل
          // Internet available, show download options dialog
          await showDownloadOptions(bookIndex, chapterIndex, poemId);

          // إعادة فحص وجود الملف محليًا بعد التحميل مباشرة
          // Re-check file existence after download dialog
          final bool fileNowExists = await file.exists();
          if (fileNowExists) {
            // إذا كان الملف موجود فعلاً بعد التحميل، شغّل مباشرة
            // If file exists after download, play directly
            await changeAudioSource(); // تحديث مصدر الصوت بعد التحميل
            await state.audioPlayer.play();
            state.isPlaying.value = true;
            log('تم بدء التشغيل بعد التحميل (الملف موجود فعلياً)',
                name: 'AudioController');
          } else {
            // إذا لم يتم التحميل لأي سبب، لا تفعل شيئاً
            // If not downloaded for any reason, do nothing
            log('لم يتم العثور على الملف بعد نافذة التحميل',
                name: 'AudioController');
          }
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
      // الملف غير موجود بالموقع الأصلي
      // File not found at the original location
      log('الملف غير موجود بالمسار الأصلي، عرض خيارات التحميل',
          name: 'AudioController');

      // عرض رسالة للمستخدم بأن الملف غير متوفر
      // Show message to user that file is not available
      state.errorMessage.value = 'ملف الصوت غير متوفر';

      // عرض خيارات التنزيل للمستخدم
      final bookIndex = bookCtrl.state.bookNumber.value - 1;
      final chapterIndex = bookCtrl.state.chapterNumber.value + 1;
      final poemId = state.poemNumber.value;

      // تأكد من إيقاف التشغيل قبل عرض خيارات التنزيل
      state.isPlaying.value = false;
      await state.audioPlayer.pause();

      // عرض خيارات التنزيل
      await showDownloadOptions(bookIndex, chapterIndex, poemId);

      // التحقق مما إذا تم التنزيل بنجاح
      final bookKey = bookIndex.toString();
      final poemKey = poemId.toString();
      final cachePath = await appCacheDir;
      final localPath = '$cachePath/book_${bookIndex}_audio_$poemId.mp3';
      final file = File(localPath);

      if ((state.downloadedBooksList.contains(bookIndex) ||
              (state.downloadedAudios.containsKey(bookKey) &&
                  state.downloadedAudios[bookKey]!.contains(poemKey))) &&
          await file.exists()) {
        // تم التنزيل بنجاح، يمكن التشغيل الآن
        // Download successful, play now
        await changeAudioSource();
        if (state.errorMessage.isEmpty) {
          await state.audioPlayer.play();
          state.isPlaying.value = true;
        }
      } else {
        // عدم محاولة الانتقال تلقائيًا إلى الأبيات التالية
        // Do not try to automatically move to next poems
        // إظهار رسالة للمستخدم
        // Show message to user
        Get.context!.showCustomErrorSnackBar('noAudioFile'.tr);
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

  /// فحص صلاحية ملف mp3 عبر قراءة أول بايتات من الملف
  /// Check if the mp3 file is valid by reading its header bytes
  Future<bool> isValidMp3File(File file) async {
    try {
      // قراءة أول 16 بايت من الملف
      // Read first 16 bytes of the file
      final raf = await file.open();
      final header = await raf.read(16);
      await raf.close();
      log('أول 16 بايت من الملف الصوتي: $header', name: 'AudioController');
      // تحقق من وجود توقيع mp3 (ID3 أو sync word)
      // Check for mp3 signature (ID3 or sync word)
      if (header.length < 3) return false;
      // ID3 tag
      if (header[0] == 0x49 && header[1] == 0x44 && header[2] == 0x33)
        return true;
      // Frame sync (0xFFEx)
      if (header[0] == 0xFF && (header[1] & 0xE0) == 0xE0) return true;
      return false;
    } catch (e) {
      log('خطأ أثناء فحص صلاحية ملف mp3: $e', name: 'AudioController');
      return false;
    }
  }
}
