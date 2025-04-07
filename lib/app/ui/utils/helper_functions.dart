import 'package:flutter/material.dart';

String splitCamelCase(String input) {
  return input.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (Match match) {
    return '${match.group(1)} ${match.group(2)}';
  });
}

Color valueToColor(int value) {
  switch (value) {
    case 0:
      return Colors.red.shade800;
    case 1:
      return Colors.orange.shade800;
    case 2:
      return Colors.grey.shade800;
    case 3:
      return Colors.lightGreen.shade800;
    case 4:
      return Colors.green.shade800;
    default:
      return Colors.white;
  }
}

String valueToString(int value) {
  switch (value) {
    case 0:
      return "Super Bad";
    case 1:
      return "Kinda Bad";
    case 2:
      return "Meh";
    case 3:
      return "Pretty Good";
    case 4:
      return "Awesome";
    default:
      return "Nahh";
  }
}
