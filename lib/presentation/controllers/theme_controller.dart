import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/utils/constants/shared_preferences_constants.dart';
import '../../core/utils/helpers/theme_config.dart';

enum AppTheme { blue, dark }

class ThemeController extends GetxController {
  static ThemeController get instance =>
      GetInstance().putOrFind(() => ThemeController());

  AppTheme? initialTheme;
  ThemeData? initialThemeData;
  final Rx<AppTheme> _currentTheme = AppTheme.blue.obs;
  final box = GetStorage();

  @override
  void onInit() async {
    var theme = await loadThemePreference();
    setTheme(theme);
    super.onInit();
  }

  void checkTheme() {
    switch (initialTheme) {
      case AppTheme.blue:
        initialThemeData = brownTheme;
        break;
      case AppTheme.dark:
        initialThemeData = darkBrownTheme;
        break;
      default:
        initialThemeData = brownTheme;
    }
  }

  Future<AppTheme> loadThemePreference() async {
    String themeString = box.read(SET_THEME) ?? AppTheme.blue.toString();
    return initialTheme = AppTheme.values.firstWhere(
      (e) => e.toString() == themeString,
      orElse: () => AppTheme.blue,
    );
  }

  Future<void> setTheme(AppTheme theme) async {
    _currentTheme.value = theme;
    ThemeData newThemeData;
    switch (theme) {
      case AppTheme.blue:
        newThemeData = brownTheme;
        break;
      case AppTheme.dark:
        newThemeData = darkBrownTheme;
        break;
    }

    Get.changeTheme(newThemeData);

    // Save theme preference
    box.write(SET_THEME, theme.toString());
    update();
    Get.forceAppUpdate();
  }

  ThemeData get currentThemeData {
    switch (_currentTheme.value) {
      case AppTheme.blue:
        return brownTheme;
      case AppTheme.dark:
        return darkBrownTheme;
    }
  }

  AppTheme get currentTheme => _currentTheme.value;

  bool get isBlueMode => _currentTheme.value == AppTheme.blue;
  bool get isDarkMode => _currentTheme.value == AppTheme.dark;

  final List<Map<String, dynamic>> themeList = [
    {
      'name': AppTheme.blue,
      'title': 'oldMode',
      'svgUrl': 'assets/svg/theme/theme1.svg',
    },
    {
      'name': AppTheme.dark,
      'title': 'darkMode',
      'svgUrl': 'assets/svg/theme/theme2.svg',
    }
  ];
}
