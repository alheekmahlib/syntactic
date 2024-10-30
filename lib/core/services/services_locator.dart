import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/presentation/controllers/settings_controller.dart';
import '/presentation/controllers/share_controller.dart';
import '../../presentation/controllers/bookmarks_controller.dart';
import '../../presentation/controllers/general_controller.dart';
import '../../presentation/controllers/onboarding_controller.dart';
import '../../presentation/controllers/splashScreen_controller.dart';
import '../../presentation/screens/all_books/controller/audio/audio_controller.dart';
import '../../presentation/screens/all_books/controller/books_controller.dart';
import '../../presentation/screens/ourApp/controller/ourApps_controller.dart';
import '../../presentation/screens/search/controller/search_controller.dart';
import '../../presentation/screens/whats_new/controller/whats_new_controller.dart';
import '../widgets/local_notification/controller/local_notifications_controller.dart';
import 'connectivity_service.dart';

final sl = GetIt.instance;

class ServicesLocator {
  Future<void> _initPrefs() async =>
      await SharedPreferences.getInstance().then((v) {
        sl.registerSingleton<SharedPreferences>(v);
      });

  Future<void> init() async {
    await Future.wait([
      _initPrefs(),
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

    sl.registerLazySingleton<AllBooksController>(() =>
        Get.put<AllBooksController>(AllBooksController(), permanent: true));

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

    sl.registerLazySingleton<WhatsNewController>(() =>
        Get.put<WhatsNewController>(WhatsNewController(), permanent: true));

    sl.registerLazySingleton<LocalNotificationsController>(() =>
        Get.put<LocalNotificationsController>(LocalNotificationsController(),
            permanent: true));

    sl.registerLazySingleton<ConnectivityService>(() =>
        Get.put<ConnectivityService>(ConnectivityService(), permanent: true));
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
