import 'package:flutter/material.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.blue,
    dividerColor: Colors.grey.shade200,
    primaryColorDark: Colors.blue,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.grey.shade300,
      onPrimary: Colors.blue.shade800,
      secondary: Colors.white,
      onSecondary: Colors.black12,
      error: const Color.fromRGBO(1, 85, 145, 0.7),
      onError: Colors.white,
      surface: Colors.transparent,
      onSurface: Colors.black87,
    ),
  );

  final darkTheme = ThemeData.dark().copyWith(
    primaryColorDark: Colors.blue,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.grey.shade800,
      onPrimary: const Color.fromRGBO(1, 85, 145, 1),
      secondary: Colors.grey,
      onSecondary: Colors.grey.shade800,
      error: const Color.fromRGBO(1, 85, 145, 1),
      onError: Colors.white,
      surface: Colors.transparent,
      onSurface: Colors.grey.shade300,
    ),
  );
}
