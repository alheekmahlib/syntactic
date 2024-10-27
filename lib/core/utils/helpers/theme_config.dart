import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData.light(useMaterial3: true);

ThemeData darkTheme = ThemeData.dark(useMaterial3: true);

ThemeData brownTheme = lightTheme.copyWith(
    primaryColorDark: const Color(0xFF77554C),
    primaryColor: const Color(0xFFC39B7B),
    primaryColorLight: const Color(0xFF77554C),
    canvasColor: const Color(0xFFFFEEDC),
    scaffoldBackgroundColor: const Color(0xFFFAF8F0),
    cardColor: const Color(0xFFFFFBF8),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF77554C),
      onPrimary: Color(0xffE6DAC8),
      secondary: Color(0xFFFFFBF8),
      onSecondary: Color(0xffFFFFFE),
      error: Color(0xFFFFEEDC),
      onError: Color(0xFFFFEEDC),
      surface: Color(0xFFC39B7B),
      onSurface: Color(0xFFC39B7B),
      inversePrimary: Color(0xFF000000),
      primaryContainer: Color(0xffFFFFFE),
      onPrimaryContainer: Color(0xffF7F1EC),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black87,
      ),
    ));

ThemeData darkBrownTheme = darkTheme.copyWith(
    primaryColorDark: const Color(0xFF121212),
    primaryColor: const Color(0xFFC39B7B),
    primaryColorLight: const Color(0xFFFFFBF8),
    canvasColor: const Color(0xFFFFEEDC),
    scaffoldBackgroundColor: const Color(0xFF181818),
    cardColor: const Color(0xFFFFFBF8),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffE6DAC8),
      onPrimary: Color(0xFF77554C),
      secondary: Color(0xFF181818),
      onSecondary: Color(0xffFFFFFE),
      error: Color(0xFFFFEEDC),
      onError: Color(0xFFFFEEDC),
      surface: Color(0xFFC39B7B),
      onSurface: Color(0xFFC39B7B),
      inversePrimary: Color(0xffE6DAC8),
      primaryContainer: Color(0xFF181818),
      onPrimaryContainer: Color(0xffF7F1EC),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black87,
      ),
    ));
