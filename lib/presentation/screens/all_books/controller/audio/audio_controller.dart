import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '/core/services/connectivity_service.dart';
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
    super.onInit();
    try {
      loadDownloadedAudios();
      await subscribeToPlayerState();
      await initializePlayer();
    } catch (e) {
      log('خطأ في تهيئة المشغل: $e', name: 'AudioController');
    }
  }

  @override
  void onClose() {
    state.audioPlayer.dispose();
    state.playerStateSubscription?.cancel();
    super.onClose();
  }

  void createPlayList() {
    state.chaptersPlayList = List.generate(poemLength, (i) {
      state.poemNumber.value = i + 1;
      return AudioSource.uri(Uri.parse(fileUrl));
    });
  }

  Future<void> changeAudioSource() async {
    try {
      if (fileUrl.isEmpty) {
        state.errorMessage.value = 'عنوان ملف الصوت غير صالح';
        return;
      }

      state.isLoading.value = true;
      state.errorMessage.value = '';
      await state.audioPlayer.stop();

      final poemId = state.poemNumber.value;
      final bookIndex = bookCtrl.state.bookNumber.value - 1;
      final cachePath = await appCacheDir;
      final localPath = '$cachePath/book_${bookIndex}_audio_$poemId.mp3';
      final file = File(localPath);

      final hasFullBook = state.downloadedBooksList.contains(bookIndex);
      final hasSpecificVerse =
          state.downloadedAudios.containsKey(bookIndex.toString()) &&
              state.downloadedAudios[bookIndex.toString()]!
                  .contains(poemId.toString());

      if ((hasFullBook || hasSpecificVerse) && await file.exists()) {
        if (await file.length() > 1024 && await isValidMp3File(file)) {
          await state.audioPlayer.setFilePath(localPath);
          state.isPlayingFromLocal = true;
        } else {
          await file.delete();
          state.errorMessage.value = 'الملف الصوتي غير صالح';
        }
      } else {
        // لا تظهر نافذة التحميل تلقائياً، فقط جهز مصدر الإنترنت
        await state.audioPlayer
            .setAudioSource(AudioSource.uri(Uri.parse(fileUrl)));
      }

      state.isLoading.value = false;
    } catch (e) {
      state.isLoading.value = false;
      state.errorMessage.value = 'فشل في تحميل الملف الصوتي';
      log('خطأ في changeAudioSource: $e', name: 'AudioController');
    }
  }

  Future<void> initializePlayer() async {
    try {
      await state.audioPlayer.setVolume(1.0);
      if (state.chaptersPlayList != null &&
          state.chaptersPlayList!.isNotEmpty) {
        await state.audioPlayer.setAudioSources(state.chaptersPlayList!);
      } else {
        await changeAudioSource();
      }
    } catch (e) {
      log('خطأ أثناء تهيئة مشغل الصوت: $e', name: 'AudioController');
    }
  }

  Future<void> subscribeToPlayerState() async {
    await state.playerStateSubscription?.cancel();
    state.playerStateSubscription =
        state.audioPlayer.playerStateStream.listen((playerState) async {
      state.isPlaying.value = playerState.playing;

      if (playerState.processingState == ProcessingState.completed) {
        // إذا كان التشغيل لبيت واحد فقط، توقف ولا تنتقل للبيت التالي
        if (state.isPlayingSingleVerse.value) {
          await state.audioPlayer.stop();
          state.isPlaying.value = false;
          return;
        }

        // التشغيل المستمر - انتقل للبيت التالي
        if (bookCtrl.state.chapterNumber.value == lastChapter) {
          await state.audioPlayer.stop();
        } else {
          final nextPoemNumber = state.poemNumber.value + 1;
          if (nextPoemNumber <= poemLength) {
            final bookIndex = bookCtrl.state.bookNumber.value - 1;
            final cachePath = await appCacheDir;
            final localPath =
                '$cachePath/book_${bookIndex}_audio_$nextPoemNumber.mp3';
            final file = File(localPath);
            final hasFullBook = state.downloadedBooksList.contains(bookIndex);
            final hasSpecificVerse =
                state.downloadedAudios.containsKey(bookIndex.toString()) &&
                    state.downloadedAudios[bookIndex.toString()]!
                        .contains(nextPoemNumber.toString());

            if ((hasFullBook || hasSpecificVerse) && await file.exists()) {
              await seekToNextPoem();
            } else {
              state.isPlaying.value = false;
              await state.audioPlayer.pause();
            }
          } else {
            await seekToNextPoem();
          }
        }
      }
    });
  }

  Future<void> seekToNextPoem() async {
    try {
      if (state.isLoading.value) return;

      if (state.poemNumber.value == lastPoemInBook) {
        await state.audioPlayer.stop();
        return;
      }

      if (state.poemNumber.value == poemLength) {
        moveToNextPage;
        final nextChapter = bookCtrl.state.chapterNumber.value + 1;
        bookCtrl.state.chapterNumber.value = nextChapter;
        bookCtrl.state.selectedPoemIndex.value = 0;
        await Future.delayed(const Duration(milliseconds: 300));

        state.poemNumber.value = bookCtrl
            .currentPoemBook!.chapters![nextChapter].poems!.first.poemNumber!;
        await changeAudioSource();

        final poemId = state.poemNumber.value;
        final bookIndex = bookCtrl.state.bookNumber.value - 1;
        final cachePath = await appCacheDir;
        final localPath = '$cachePath/book_${bookIndex}_audio_$poemId.mp3';
        final file = File(localPath);
        final hasFullBook = state.downloadedBooksList.contains(bookIndex);
        final hasSpecificVerse =
            state.downloadedAudios.containsKey(bookIndex.toString()) &&
                state.downloadedAudios[bookIndex.toString()]!
                    .contains(poemId.toString());

        if ((hasFullBook || hasSpecificVerse) &&
            await file.exists() &&
            state.errorMessage.isEmpty) {
          await state.audioPlayer.play();
        } else {
          state.isPlaying.value = false;
          await state.audioPlayer.pause();
          await handleFileNotFound();
        }
      } else {
        state.poemNumber.value += 1;
        bookCtrl.state.selectedPoemIndex.value += 1;
        await changeAudioSource();

        if (state.errorMessage.isEmpty) {
          await state.audioPlayer.play();
        } else {
          await handleFileNotFound();
        }
      }
    } catch (e) {
      log('خطأ أثناء الانتقال للقصيدة التالية: $e', name: 'AudioController');
      await handleFileNotFound();
    }
  }

  Future<void> seekToPrevious() async {
    try {
      if (state.isLoading.value) return;

      if (state.poemNumber.value <= firstPoem) {
        if (bookCtrl.state.chapterNumber.value > 0) {
          moveToPreviousPage;
          final prevChapter = bookCtrl.state.chapterNumber.value - 1;
          bookCtrl.state.chapterNumber.value = prevChapter;
          await Future.delayed(const Duration(milliseconds: 300));

          state.poemNumber.value = poemLength;
          int lastIndex =
              bookCtrl.currentPoemBook!.chapters![prevChapter].poems!.length -
                  1;
          bookCtrl.state.selectedPoemIndex.value = lastIndex;

          createPlayList();
          await changeAudioSource();

          if (state.errorMessage.isEmpty) {
            await state.audioPlayer.play();
          } else {
            await handleFileNotFound();
          }
        }
      } else {
        state.poemNumber.value -= 1;
        bookCtrl.state.selectedPoemIndex.value -= 1;
        await changeAudioSource();

        if (state.errorMessage.isEmpty) {
          await state.audioPlayer.play();
        } else {
          await handleFileNotFound();
        }
      }
    } catch (e) {
      log('خطأ أثناء الانتقال للقصيدة السابقة: $e', name: 'AudioController');
      await handleFileNotFound();
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState appState) {
    if (appState == AppLifecycleState.paused && state.isPlaying.value) {
      state.audioPlayer.pause();
    }
  }

  Future<void> togglePlayPause() async {
    try {
      if (state.isPlaying.value) {
        state.isPlaying.value = false;
        await state.audioPlayer.pause();
      } else {
        final poemId = state.poemNumber.value;
        final bookIndex = bookCtrl.state.bookNumber.value - 1;
        final chapterIndex = bookCtrl.state.chapterNumber.value + 1;
        final hasFullBook = state.downloadedBooksList.contains(bookIndex);
        final hasSpecificVerse =
            await checkAndDownloadAudio(bookIndex, chapterIndex, poemId);
        final cachePath = await appCacheDir;
        final localPath = '$cachePath/book_${bookIndex}_audio_$poemId.mp3';
        final file = File(localPath);

        if ((hasFullBook || hasSpecificVerse) || await file.exists()) {
          // إذا كان الكتاب كاملاً محمل = تشغيل مستمر، إذا كان بيت واحد = تشغيل بيت واحد
          state.isPlayingSingleVerse.value = !hasFullBook;
          state.isPlaying.value = true;
          await state.audioPlayer.play();
        } else if (ConnectivityService.instance.noConnection.value) {
          Get.context!.showCustomErrorSnackBar('noInternet'.tr);
          return;
        } else {
          await showDownloadOptions(bookIndex, chapterIndex, poemId);
          final bool fileNowExists = await file.exists();
          if (fileNowExists) {
            await changeAudioSource();
            await state.audioPlayer.play();
            state.isPlaying.value = true;
          }
        }
      }
    } catch (e) {
      log('خطأ أثناء تشغيل/إيقاف الصوت: $e', name: 'AudioController');
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      if (volume < 0) volume = 0;
      if (volume > 1) volume = 1;
      await state.audioPlayer.setVolume(volume);
    } catch (e) {
      log('خطأ أثناء تعديل مستوى الصوت: $e', name: 'AudioController');
    }
  }

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

  Future<void> handleFileNotFound() async {
    try {
      state.errorMessage.value = 'ملف الصوت غير متوفر';
      final bookIndex = bookCtrl.state.bookNumber.value - 1;
      final chapterIndex = bookCtrl.state.chapterNumber.value + 1;
      final poemId = state.poemNumber.value;

      state.isPlaying.value = false;
      await state.audioPlayer.pause();
      await showDownloadOptions(bookIndex, chapterIndex, poemId);

      final cachePath = await appCacheDir;
      final localPath = '$cachePath/book_${bookIndex}_audio_$poemId.mp3';
      final file = File(localPath);

      if ((state.downloadedBooksList.contains(bookIndex) ||
              (state.downloadedAudios.containsKey(bookIndex.toString()) &&
                  state.downloadedAudios[bookIndex.toString()]!
                      .contains(poemId.toString()))) &&
          await file.exists()) {
        await changeAudioSource();
        if (state.errorMessage.isEmpty) {
          await state.audioPlayer.play();
          state.isPlaying.value = true;
        }
      } else {
        Get.context!.showCustomErrorSnackBar('noAudioFile'.tr);
      }
    } catch (e) {
      log('فشل في معالجة حالة عدم وجود الملف: $e', name: 'AudioController');
      Get.snackbar('خطأ', 'حدث خطأ أثناء محاولة تشغيل الملف الصوتي',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3));
    }
  }

  void checkPlaybackStatus() {
    if (state.lastChapterNumber.value != bookCtrl.state.chapterNumber.value) {
      state.poemNumber.value = 1;
      changeAudioSource();
    }
  }

  Future<bool> isValidMp3File(File file) async {
    try {
      final raf = await file.open();
      final header = await raf.read(16);
      await raf.close();
      if (header.length < 3) return false;
      // ID3 tag
      if (header[0] == 0x49 && header[1] == 0x44 && header[2] == 0x33) {
        return true;
      }
      // Frame sync (0xFFEx)
      if (header[0] == 0xFF && (header[1] & 0xE0) == 0xE0) {
        return true;
      }
      return false;
    } catch (e) {
      log('خطأ أثناء فحص صلاحية ملف mp3: $e', name: 'AudioController');
      return false;
    }
  }
}
