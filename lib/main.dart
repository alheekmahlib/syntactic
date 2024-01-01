import 'package:flutter/material.dart';

import '/core/utils/helpers/languages/dependency_inj.dart' as dep;
import 'core/services/services_locator.dart';
import 'core/widgets/theme_service.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Map<String, Map<String, String>> languages = await dep.init();
  final themeService = await ThemeService.instance;
  var initTheme = themeService.initial;

  await ServicesLocator().init();
  runApp(MyApp(languages: languages, theme: initTheme));
}
