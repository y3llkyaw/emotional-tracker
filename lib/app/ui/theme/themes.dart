import 'package:flutter/material.dart';

class Themes {
  final lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.red,
    cardColor: Colors.white,
    shadowColor: Colors.grey,
  );

  final darkTheme = ThemeData.light().copyWith(
    primaryColor: Colors.red,
    cardColor: Colors.white,
    shadowColor: Colors.grey,
  );
  // final darkTheme = ThemeData.dark().copyWith(
  //   primaryColor: Colors.grey[900],
  //   cardColor: Colors.grey[900],
  //   textTheme: const TextTheme(
  //     headlineLarge: TextStyle(
  //       fontSize: 32,
  //     ),
  //   ),
  //   shadowColor: Colors.grey,
  // );
}
