import 'dart:async';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../../core/widgets/seek_bar.dart';

class AudioState {
  /// -------- [متغيرات الحالة] ----------
  /// -------- [State Variables] ----------
  RxInt position = RxInt(0);
  ArabicNumbers arabicNumber = ArabicNumbers();
  AudioPlayer audioPlayer = AudioPlayer();
  RxBool isPlaying = false.obs;
  RxInt poemNumber = 1.obs;
  List<AudioSource>? chaptersPlayList;
  Rx<PositionData>? positionData;
  var activeButton = RxString('');
  RxDouble audioWidgetPosition = (-240.0).obs;
  StreamSubscription<PlayerState>? playerStateSubscription;
  double poemHeight = 90.0;

  /// مخزن البيانات المحلي
  /// Local storage instance
  final storage = GetStorage();

  /// قائمة الملفات الصوتية المنزلة - مفتاح الكتاب (رقم الكتاب) -> قائمة الأبيات المحملة
  /// Downloaded audio files map - book key (book number) -> list of downloaded verses
  final Map<String, List<String>> downloadedAudios = {};

  /// قائمة الكتب التي تم تحميلها بالكامل
  /// List of books that have been fully downloaded
  RxList<int> downloadedBooksList = <int>[].obs;

  /// حالات تنزيل الملفات الصوتية
  /// Audio files download states (audioID -> isDownloading)
  final Map<int, bool> downloading = <int, bool>{};

  /// نسبة تقدم التنزيل لكل ملف صوتي
  /// Download progress for each audio file (audioID -> progress)
  final RxMap<int, double> downloadProgress = <int, double>{}.obs;

  /// حالة تنزيل الفصل كاملاً
  /// Full chapter downloading state
  RxBool isDownloadingChapter = false.obs;

  /// حالة تحميل الصوت
  /// Audio loading state
  RxBool isLoading = false.obs;

  /// رسالة الخطأ إذا حدثت مشكلة
  /// Error message if there was a problem
  RxString errorMessage = ''.obs;

  /// آخر فصل تم الانتقال إليه
  /// Last chapter navigated to
  RxInt lastChapterNumber = 0.obs;

  /// هل التشغيل الحالي من ملف محلي؟
  /// Is the current playback from a local file?
  bool isPlayingFromLocal = false;

  /// نوع التشغيل - بيت واحد أم تشغيل مستمر
  /// Playback mode - single verse or continuous
  RxBool isPlayingSingleVerse = false.obs;
}
