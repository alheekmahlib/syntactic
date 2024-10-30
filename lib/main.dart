import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '/core/utils/helpers/languages/dependency_inj.dart' as dep;
import 'core/services/connectivity_service.dart';
import 'core/services/services_locator.dart';
import 'core/utils/helpers/notifications_helper.dart';
import 'core/widgets/theme_service.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> languages = await dep.init();
  final themeService = await ThemeService.instance;
  var initTheme = themeService.initial;

  await ServicesLocator().init();
  await GetStorage.init();
  NotifyHelper.initAwesomeNotifications();
  NotifyHelper().requestPermissions();
  await ConnectivityService.instance.init();
  runApp(MyApp(languages: languages, theme: initTheme));
}
