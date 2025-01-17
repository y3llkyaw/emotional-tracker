import 'dart:ui';

import 'package:flutter/material.dart';

String splitCamelCase(String input) {
  return input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (Match match) {
    return '${match.group(1)} ${match.group(2)}';
  });
}

// Color valueToColor(int value) {
//   switch (value) {
//     case 0:
//       return const Color.fromARGB(255, 255, 147, 85);
//     case 1:
//       return const Color.fromARGB(255, 91, 133, 206);
//     case 2:
//       return Colors.grey;
//     case 3:
//       return Colors.green;
//     case 4:
//       return const Color.fromARGB(255, 211, 201, 61);
//     default:
//       return Colors.white;
//   }
// }

Color valueToColor(int value) {
  switch (value) {
    case 0:
      return Colors.red.shade400;
    case 1:
      return Colors.orange;
    case 2:
      return Colors.grey;
    case 3:
      return Colors.lightGreen;
    case 4:
      return Colors.green;
    default:
      return Colors.white;
  }
}
