import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ThemeData lightTheme = ThemeData.light(useMaterial3: true);

// ThemeData darkTheme = ThemeData.dark(useMaterial3: true);

// ThemeData brownTheme = lightTheme.copyWith(
//     primaryColorDark: const Color(0xFF77554C),
//     primaryColor: const Color(0xFFC39B7B),
//     primaryColorLight: const Color(0xFF77554C),
//     canvasColor: const Color(0xFFFFEEDC),
//     scaffoldBackgroundColor: const Color(0xFFFAF8F0),
//     cardColor: const Color(0xFFFFFBF8),
//     colorScheme: const ColorScheme(
//       brightness: Brightness.light,
//       primary: Color(0xFF77554C),
//       onPrimary: Color(0xffE6DAC8),
//       secondary: Color(0xFFFFFBF8),
//       onSecondary: Color(0xffFFFFFE),
//       error: Color(0xFFFFEEDC),
//       onError: Color(0xFFFFEEDC),
//       surface: Color(0xFFC39B7B),
//       onSurface: Color(0xFFC39B7B),
//       inversePrimary: Color(0xFF000000),
//       primaryContainer: Color(0xffFFFFFE),
//       onPrimaryContainer: Color(0xffF7F1EC),
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(
//         color: Colors.black87,
//       ),
//     ));

// ThemeData darkBrownTheme = darkTheme.copyWith(
//     primaryColorDark: const Color(0xFF121212),
//     primaryColor: const Color(0xFFC39B7B),
//     primaryColorLight: const Color(0xFFFFFBF8),
//     canvasColor: const Color(0xFFFFEEDC),
//     scaffoldBackgroundColor: const Color(0xFF181818),
//     cardColor: const Color(0xFFFFFBF8),
//     colorScheme: const ColorScheme(
//       brightness: Brightness.light,
//       primary: Color(0xffE6DAC8),
//       onPrimary: Color(0xFF77554C),
//       secondary: Color(0xFF181818),
//       onSecondary: Color(0xffFFFFFE),
//       error: Color(0xFFFFEEDC),
//       onError: Color(0xFFFFEEDC),
//       surface: Color(0xFFC39B7B),
//       onSurface: Color(0xFFC39B7B),
//       inversePrimary: Color(0xffE6DAC8),
//       primaryContainer: Color(0xFF181818),
//       onPrimaryContainer: Color(0xffF7F1EC),
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(
//         color: Colors.black87,
//       ),
//     ));

final ThemeData brownTheme = ThemeData.light(
  useMaterial3: true,
).copyWith(
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
  primaryColorDark: const Color(0xFF77554C),
  primaryColor: const Color(0xFFC39B7B),
  primaryColorLight: const Color(0xFF77554C),
  canvasColor: const Color(0xFFFFEEDC),
  scaffoldBackgroundColor: const Color(0xFFFAF8F0),
  dividerTheme: const DividerThemeData(
    color: Color(0xff31493C),
  ),
  textSelectionTheme: TextSelectionThemeData(
      selectionColor: const Color(0xffB3EFB2).withValues(alpha: 0.3),
      selectionHandleColor: const Color(0xffB3EFB2)),
  cupertinoOverrideTheme: const CupertinoThemeData(
    primaryColor: Color(0xff7A9E7E),
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: const Color(0xff31493C),
    dialBackgroundColor: const Color(0xffEFF4FE),
    dialHandColor: const Color(0xff31493C),
    dialTextColor: const Color(0xff000000).withValues(alpha: .6),
    entryModeIconColor: const Color(0xff000000).withValues(alpha: .6),
    hourMinuteTextColor: const Color(0xff000000).withValues(alpha: .6),
    dayPeriodTextColor: const Color(0xff000000).withValues(alpha: .6),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
          const Color(0xff000000).withValues(alpha: .6)),
      foregroundColor: WidgetStateProperty.all(const Color(0xffEFF4FE)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      textStyle: WidgetStateProperty.all(const TextStyle(
        fontFamily: 'cairo',
        fontSize: 16,
      )),
    ),
    confirmButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
          const Color(0xff000000).withValues(alpha: .8)),
      foregroundColor: WidgetStateProperty.all(const Color(0xffEFF4FE)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      textStyle: WidgetStateProperty.all(const TextStyle(
        fontFamily: 'cairo',
        fontSize: 16,
      )),
    ),
  ),
  textTheme: const TextTheme(
    titleMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: 'cairo',
      fontSize: 12,
      color: Color(0xff001A23),
    ),
  ),
);

final ThemeData darkBrownTheme = ThemeData.dark(
  useMaterial3: true,
).copyWith(
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
  primaryColorDark: const Color(0xFF121212),
  primaryColor: const Color(0xFFC39B7B),
  primaryColorLight: const Color(0xFFFFFBF8),
  canvasColor: const Color(0xFFFFEEDC),
  scaffoldBackgroundColor: const Color(0xFF181818),
  cardColor: const Color(0xFFFFFBF8),
  dividerTheme: const DividerThemeData(
    color: Color(0xff31493C),
  ),
  textSelectionTheme: TextSelectionThemeData(
      selectionColor: const Color(0xffB3EFB2).withValues(alpha: 0.3),
      selectionHandleColor: const Color(0xffB3EFB2)),
  cupertinoOverrideTheme: const CupertinoThemeData(
    primaryColor: Color(0xff7A9E7E),
  ),
  timePickerTheme: TimePickerThemeData(
    backgroundColor: const Color(0xff31493C),
    dialBackgroundColor: const Color(0xffEFF4FE),
    dialHandColor: const Color(0xff31493C),
    dialTextColor: const Color(0xff000000).withValues(alpha: .6),
    entryModeIconColor: const Color(0xff000000).withValues(alpha: .6),
    hourMinuteTextColor: const Color(0xff000000).withValues(alpha: .6),
    dayPeriodTextColor: const Color(0xff000000).withValues(alpha: .6),
    cancelButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
          const Color(0xff000000).withValues(alpha: .6)),
      foregroundColor: WidgetStateProperty.all(const Color(0xffEFF4FE)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      textStyle: WidgetStateProperty.all(const TextStyle(
        fontFamily: 'cairo',
        fontSize: 16,
      )),
    ),
    confirmButtonStyle: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(
          const Color(0xff000000).withValues(alpha: .8)),
      foregroundColor: WidgetStateProperty.all(const Color(0xffEFF4FE)),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      textStyle: WidgetStateProperty.all(const TextStyle(
        fontFamily: 'cairo',
        fontSize: 16,
      )),
    ),
  ),
  textTheme: const TextTheme(
    titleMedium: TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: 'cairo',
      fontSize: 12,
      color: Color(0xff001A23),
    ),
  ),
);
