import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/utils/helpers/languages/app_constants.dart';
import 'core/utils/helpers/languages/localization_controller.dart';
import 'core/utils/helpers/languages/messages.dart';
import 'core/utils/helpers/theme_config.dart';
import 'presentation/screens/home/screen/home_page.dart';

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({super.key, required this.languages});

  @override
  Widget build(BuildContext context) {
    final isPlatformDark =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    final initTheme = isPlatformDark ? darkTheme : lightTheme;
    return ThemeProvider(
        initTheme: initTheme,
        builder: (context, myTheme) {
          return GetBuilder<LocalizationController>(
              builder: (localizationController) {
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Agrumiya',
              locale: localizationController.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(AppConstants.languages[0].languageCode,
                  AppConstants.languages[0].countryCode),
              theme: myTheme,
              home: const Directionality(
                textDirection: TextDirection.rtl,
                child: HomePage(),
              ),
            );
          });
        });
  }
}
