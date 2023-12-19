import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

class ServicesLocator {
  Future<void> _initPrefs() async =>
      await SharedPreferences.getInstance().then((v) {
        sl.registerSingleton<SharedPreferences>(v);
      });

  // Future<void> setupHive() async {
  //   await Hive.initFlutter();
  //   Hive.registerAdapter(BookmarkAdapter());
  //   await Hive.openBox<Bookmark>(AssetsData.bookmarkBox);
  // }

  Future<void> init() async {
    await Future.wait([
      _initPrefs(),
      // setupHive(),
    ]);

    // Controllers
    // sl.registerLazySingleton<GeneralController>(
    //     () => Get.put<GeneralController>(GeneralController(), permanent: true));

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
