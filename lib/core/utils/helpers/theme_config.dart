import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData.light();

ThemeData darkTheme = ThemeData.dark();

ThemeData pinkTheme = lightTheme.copyWith(
    primaryColorDark: const Color(0xFF77554C),
    primaryColor: const Color(0xFFC39B7B),
    primaryColorLight: const Color(0xFFFFFBF8),
    canvasColor: const Color(0xFFFFEEDC),
    scaffoldBackgroundColor: const Color(0xFFFAF8F0),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF77554C),
      onPrimary: Color(0xffE6DAC8),
      secondary: Color(0xFFFFFBF8),
      onSecondary: Color(0xffFFFFFE),
      error: Color(0xFFFFEEDC),
      onError: Color(0xFFFFEEDC),
      background: Color(0xffFFFFFE),
      onBackground: Color(0xffF7F1EC),
      surface: Color(0xFFC39B7B),
      onSurface: Color(0xFFFAF8F0),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black87,
      ),
    ));

ThemeData halloweenTheme = lightTheme.copyWith(
  primaryColor: const Color(0xFF55705A),
  scaffoldBackgroundColor: const Color(0xFFE48873),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    foregroundColor: Color(0xFFea8e71),
    backgroundColor: Color(0xFF2b2119),
  ),
);

ThemeData darkBlueTheme = ThemeData.dark().copyWith(
    primaryColorDark: const Color(0xFF77554C),
    primaryColor: const Color(0xFFC39B7B),
    primaryColorLight: const Color(0xFFFFFBF8),
    canvasColor: const Color(0xFFFFEEDC),
    scaffoldBackgroundColor: const Color(0xFFFAF8F0),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffE6DAC8),
      onPrimary: Color(0xFF77554C),
      secondary: Color(0xFFFFFBF8),
      onSecondary: Color(0xffFFFFFE),
      error: Color(0xFFFFEEDC),
      onError: Color(0xFFFFEEDC),
      background: Color(0xFFFFEEDC),
      onBackground: Color(0xffF7F1EC),
      surface: Color(0xFFC39B7B),
      onSurface: Color(0xFFFAF8F0),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black87,
      ),
    ));
