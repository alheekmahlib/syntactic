import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/utils/helpers/languages/app_constants.dart';
import 'core/utils/helpers/languages/localization_controller.dart';
import 'core/utils/helpers/languages/messages.dart';
import 'presentation/screens/splashScreen/splash_screen.dart';

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> languages;
  final ThemeData theme;
  const MyApp({super.key, required this.languages, required this.theme});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return ThemeProvider(
              initTheme: theme,
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
                      child: SplashScreen(),
                    ),
                  );
                });
              });
        });
  }
}
