import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:emotion_tracker/app/ui/global_widgets/radio_emoji_selction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

void showEmojiBottomSheet(DateTime date) {
  AnimatedEmojiData selectedEmoji = AnimatedEmojis.neutralFace;
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
                      child: SvgPicture.asset(
                        "assets/svg/emoji_u${selectedEmoji.id.replaceAll("_fe0f", "")}.svg",
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
                    subtitle: Text(
                      date.isAfter(DateTime.now())
                          ? "'how are you feeling ?'"
                          : "how were you feeling? ",
                      style: const TextStyle(
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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    maxLength: 500,
                    maxLines: 5,
                    scrollPadding: EdgeInsets.all(20),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orangeAccent,
                          width: 2.0,
                        ),
                      ),
                      counterStyle: TextStyle(color: Colors.grey),
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
                    style: TextStyle(
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
                      child: CustomButton(
                        text: "Next",
                        onPressed: () {},
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
