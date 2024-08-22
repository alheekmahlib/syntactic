import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/controllers/audio_controller.dart';
import '../../presentation/controllers/bookmarks_controller.dart';
import '../../presentation/controllers/books_controller.dart';
import '../../presentation/controllers/general_controller.dart';
import '../../presentation/controllers/onboarding_controller.dart';
import '../../presentation/controllers/ourApps_controller.dart';
import '../../presentation/controllers/search_controller.dart';
import '../../presentation/controllers/splashScreen_controller.dart';
import '../../presentation/screens/bookmark/data/data_source/object_box.dart';
import '../../presentation/screens/bookmark/data/models/objectbox.g.dart';
import '/presentation/controllers/settings_controller.dart';
import '/presentation/controllers/share_controller.dart';

final sl = GetIt.instance;

class ServicesLocator {
  Future<void> _initPrefs() async =>
      await SharedPreferences.getInstance().then((v) {
        sl.registerSingleton<SharedPreferences>(v);
      });

  Future<void> _initObjectBox() async {
    final objectBox = await ObjectBox.create();
    sl.registerSingleton<ObjectBox>(objectBox);

    final store = await openStore();
    sl.registerSingleton<Store>(store);
  }

  Future<void> init() async {
    await Future.wait([
      _initPrefs(),
      _initObjectBox(),
      // sl<BookmarksController>().getAndSetBookmarks()
    ]);

    // Controllers
    sl.registerLazySingleton<GeneralController>(
        () => Get.put<GeneralController>(GeneralController(), permanent: true));

    sl.registerLazySingleton<SettingsController>(() =>
        Get.put<SettingsController>(SettingsController(), permanent: true));

    sl.registerLazySingleton<ShareController>(
        () => Get.put<ShareController>(ShareController(), permanent: true));

    sl.registerLazySingleton<OurAppsController>(
        () => Get.put<OurAppsController>(OurAppsController(), permanent: true));

    sl.registerLazySingleton<BooksController>(
        () => Get.put<BooksController>(BooksController(), permanent: true));

    sl.registerLazySingleton<AudioController>(
        () => Get.put<AudioController>(AudioController(), permanent: true));

    sl.registerLazySingleton<SearchControllers>(
        () => Get.put<SearchControllers>(SearchControllers(), permanent: true));

    sl.registerLazySingleton<BookmarksController>(() =>
        Get.put<BookmarksController>(BookmarksController(), permanent: true));

    sl.registerLazySingleton<SplashScreenController>(() =>
        Get.put<SplashScreenController>(SplashScreenController(),
            permanent: true));

    sl.registerLazySingleton<OnboardingController>(() =>
        Get.put<OnboardingController>(OnboardingController(), permanent: true));
    // UiHelper.rateMyApp.init();
    //
    // if (Platform.isWindows || Platform.isLinux) {
    //   // Initialize FFI
    //   sqfliteFfiInit();
    // }
    // if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    //   await DesktopWindow.setMinWindowSize(const Size(900, 840));
    // }
  }
}
