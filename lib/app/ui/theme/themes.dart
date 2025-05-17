import 'package:flutter/material.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    tooltipTheme: TooltipThemeData(
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.orange.shade800,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.grey.shade300,
      onPrimary: Colors.indigo,
      secondary: Colors.white,
      onSecondary: Colors.black12,
      error: const Color.fromRGBO(1, 85, 145, 0.7),
      onError: Colors.white,
      surface: Colors.transparent,
      onSurface: Colors.black87,
    ),
  );

  final darkTheme = ThemeData.dark().copyWith(
    tooltipTheme: TooltipThemeData(
      textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    primaryColorDark: Colors.blue,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.grey.shade800,
      onPrimary: Colors.indigo,
      secondary: Colors.grey,
      onSecondary: Colors.grey.shade800,
      error: const Color.fromRGBO(1, 85, 145, 1),
      onError: Colors.white,
      surface: Colors.transparent,
      onSurface: Colors.grey.shade300,
    ),
  );
}
