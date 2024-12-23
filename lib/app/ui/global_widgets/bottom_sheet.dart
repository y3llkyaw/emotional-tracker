import 'dart:developer';

import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:emotion_tracker/app/ui/global_widgets/radio_emoji_selction.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final JournalController journalController = Get.put(JournalController());
void showEmojiBottomSheet(DateTime date) {
  AnimatedEmojiData selectedEmoji = AnimatedEmojis.neutralFace;
  final messageController = TextEditingController();
  Get.bottomSheet(
    StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          height: Get.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  leading: AnimatedEmoji(
                    selectedEmoji,
                    errorWidget: Center(
                      child: Text(
                        selectedEmoji.toUnicodeEmoji(),
                        style: const TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    size: 50,
                  ),
                  title: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    title: Text(
                      "${date.day}/${date.month}/${date.year}",
                      style: TextStyle(
                        fontSize: Get.theme.textTheme.titleSmall!.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: const Text(
                      "how were you feeling? ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    splashColor: Colors.orangeAccent,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: messageController,
                    maxLength: 500,
                    maxLines: 5,
                    scrollPadding: const EdgeInsets.all(20),
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orangeAccent,
                          width: 2.0,
                        ),
                      ),
                      counterStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      focusColor: Colors.white,
                      hintText: "write about your feelings..",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintMaxLines: 5,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                RadioEmojiSelection(
                  selectedEmoji: selectedEmoji,
                  onEmojiSelected: (emoji) {
                    setState(() => selectedEmoji = emoji);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Get.width * 0.45,
                      child: CustomButton(
                        text: "Back",
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.45,
                      child: Obx(
                        () => CustomButton(
                          isLoading: journalController.isLoading.value,
                          text: "Next",
                          onPressed: () async {
                            journalController.content.value =
                                messageController.text;
                            journalController.emotion.value = selectedEmoji;
                            journalController.date.value = date;
                            await journalController
                                .createJournal()
                                .then((value) {
                              if (value != null) {
                                Get.back();
                                Get.snackbar(
                                    "Success", "Journal created successfully!");
                              } else {
                                Get.snackbar(
                                  "Error",
                                  value.toString(),
                                );
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
    elevation: 1,
    backgroundColor: Colors.black54,
    enableDrag: true,
  );
}
