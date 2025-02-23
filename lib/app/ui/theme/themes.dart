import 'package:flutter/material.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.red,
    cardColor: Colors.white,
    shadowColor: Colors.grey,
  );
  final darkTheme = ThemeData.light();
  // final darkTheme = ThemeData.dark().copyWith(
  //   // primaryColor: Colors.red,
  //   cardColor: Colors.white24,
  //   primaryColorDark: Colors.blueAccent,
  //   shadowColor: Colors.grey,
  //   // scaffoldBackgroundColor: Colors.amber,
  //   textTheme: const TextTheme(
  //     titleLarge: TextStyle(
  //       color: Colors.grey,
  //     ),
  //     titleMedium: TextStyle(
  //       color: Colors.grey,
  //     ),
  //     titleSmall: TextStyle(
  //       color: Colors.grey,
  //     ),
  //   ),
  // );
}
