import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '/presentation/screens/main/main_screen.dart';
import 'core/utils/helpers/languages/app_constants.dart';
import 'core/utils/helpers/languages/localization_controller.dart';
import 'core/utils/helpers/languages/messages.dart';
import 'core/utils/helpers/theme_config.dart';

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  const MyApp({super.key, required this.languages});

  @override
  Widget build(BuildContext context) {
    final isPlatformDark =
        WidgetsBinding.instance.window.platformBrightness == Brightness.dark;
    final initTheme = isPlatformDark ? darkTheme : pinkTheme;
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return ThemeProvider(
              initTheme: initTheme,
              builder: (context, myTheme) {
                return GetBuilder<LocalizationController>(
                    builder: (localizationController) {
                  return GetMaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Syntactic',
                    locale: localizationController.locale,
                    translations: Messages(languages: languages),
                    fallbackLocale: Locale(
                        AppConstants.languages[0].languageCode,
                        AppConstants.languages[0].countryCode),
                    theme: myTheme,
                    home: const Directionality(
                      textDirection: TextDirection.rtl,
                      child: MainScreen(),
                    ),
                  );
                });
              });
        });
  }
}
