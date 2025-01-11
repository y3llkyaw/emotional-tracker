import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/ui/utils/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showEmojiSheet(void Function(AnimatedEmojiData) onEmojiSelected,
    AnimatedEmojiData selectedEmoji) {
  Get.bottomSheet(
    StatefulBuilder(
      builder: (context, setState) {
        return Transform(
          transform: Matrix4.translationValues(0, -Get.height * 0.03, 0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: Get.height * 0.06,
                    child: AnimatedEmoji(
                      selectedEmoji,
                      size: Get.width * 0.2,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: Get.height * 0.02,
                      ),
                      Text(
                        "Emoji Name",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Get.height * 0.016),
                      ),
                      SizedBox(height: Get.height * 0.006),
                      SizedBox(
                        width: Get.width * 0.6,
                        child: Text(
                          splitCamelCase(selectedEmoji.name)
                              .capitalize
                              .toString(),
                          maxLines: 4,
                          style: TextStyle(
                            overflow: TextOverflow
                                .ellipsis, // Ensure text does not overflow
                            fontWeight: FontWeight.w600,
                            fontSize: Get.height * 0.02,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: Get.height * 0.04,
                      ),
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Column(
                          children: [
                            Icon(CupertinoIcons.xmark),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 6,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  itemCount: AnimatedEmojis.values.length,
                  itemBuilder: (context, index) {
                    final emoji = AnimatedEmojis.values[index];
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            selectedEmoji = emoji;
                          });
                          onEmojiSelected(emoji);
                        },
                        child: Center(
                          child: Text(
                            emoji.toUnicodeEmoji(),
                            style: TextStyle(
                              fontSize: Get.width * 0.095,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ),
    // elevation: 1,
    backgroundColor: Colors.white,
    enableDrag: true,
  );
}
