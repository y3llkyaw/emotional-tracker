import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DarkmodeController extends GetxController {
  final box = GetStorage();
  final theme = 2.obs; // 0 = dark, 1 = light, 2 = system

  @override
  void onInit() {
    super.onInit();
    theme.value = box.read("theme") ?? 2;
  }

  void setTheme(int value) {
    theme.value = value;
    box.write('theme', value);
  }

  ThemeMode get currentThemeMode {
    switch (theme.value) {
      case 0:
        return ThemeMode.dark;
      case 1:
        return ThemeMode.light;
      case 2:
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }
}
