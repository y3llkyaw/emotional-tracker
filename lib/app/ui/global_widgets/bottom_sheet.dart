import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.g.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showEmojiBottomSheet() {
  Get.bottomSheet(
    InkWell(
      onTap: () {
        Get.back();
      },
      child: SizedBox(
        height: Get.height * 0.8,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Text(
                  "Choose your Emotion",
                  style: TextStyle(
                    fontSize: Get.theme.textTheme.titleMedium!.fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Text(
                  "Emotions",
                  style: TextStyle(
                    fontSize: Get.theme.textTheme.titleSmall!.fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {},
                      child: const AnimatedEmoji(
                        AnimatedEmojis.angry,
                        size: 40,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {},
                      child: const AnimatedEmoji(
                        AnimatedEmojis.sad,
                        size: 40,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {},
                      child: const AnimatedEmoji(
                        AnimatedEmojis.neutralFace,
                        size: 40,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {},
                      child: const AnimatedEmoji(
                        AnimatedEmojis.smile,
                        size: 40,
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () {},
                      child: const AnimatedEmoji(
                        AnimatedEmojis.joy,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    elevation: 1,
    persistent: false,
    backgroundColor: Colors.black54,
  );
}
