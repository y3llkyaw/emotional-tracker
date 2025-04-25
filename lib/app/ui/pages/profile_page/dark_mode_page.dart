import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/controllers/darkmode_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DarkModePage extends StatelessWidget {
  DarkModePage({Key? key}) : super(key: key);
  final DarkmodeController darkmodeController = Get.put(DarkmodeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dark Mode Setting"),
      ),
      body: Obx(
        () => Column(
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: AnimatedEmoji(
                darkmodeController.theme.value == 0
                    ? AnimatedEmojis.moonFaceFirstQuarter
                    : darkmodeController.theme.value == 1
                        ? AnimatedEmojis.sunWithFace
                        : AnimatedEmojis.gear,
              ),
            ),
            SizedBox(
              height: Get.height * 0.07,
            ),
            RadioListTile<int>(
              selectedTileColor: Colors.black87,
              contentPadding: const EdgeInsets.symmetric(horizontal: 40),
              value: 0,
              groupValue: darkmodeController.theme.value,
              onChanged: (value) {
                if (value != null) {
                  darkmodeController.theme.value = value;
                  darkmodeController.setTheme(value);
                }
              },
              title: const Text("Dark Mode"),
              subtitle: const Text("Time to go dark!"),
              secondary: const Icon(Icons.dark_mode),
              selected: darkmodeController.theme.value == 0,
            ),
            RadioListTile<int>(
              selectedTileColor: Colors.black87,
              contentPadding: const EdgeInsets.symmetric(horizontal: 40),
              value: 1,
              groupValue: darkmodeController.theme.value,
              onChanged: (value) {
                if (value != null) {
                  darkmodeController.theme.value = value;
                  darkmodeController.setTheme(value);
                }
              },
              title: const Text("Light Mode"),
              subtitle: const Text("Let the sunshine in!"),
              secondary: const Icon(Icons.sunny),
              selected: darkmodeController.theme.value == 1,
            ),
            RadioListTile<int>(
              selectedTileColor: Colors.black87,
              contentPadding: const EdgeInsets.symmetric(horizontal: 40),
              value: 2,
              groupValue: darkmodeController.theme.value,
              onChanged: (value) {
                if (value != null) {
                  darkmodeController.theme.value = value;
                  darkmodeController.setTheme(value);
                }
              },
              title: const Text("System Setting"),
              subtitle: const Text("Let the system decide!"),
              secondary: const Icon(Icons.settings),
              selected: darkmodeController.theme.value == 2,
            ),
          ],
        ),
      ),
    );
  }
}
