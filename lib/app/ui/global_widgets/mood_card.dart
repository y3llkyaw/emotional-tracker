import 'package:animated_emoji/emoji.dart';
import 'package:emotion_tracker/app/data/models/journal.dart';
import 'package:emotion_tracker/app/ui/global_widgets/share_sheet.dart';
import 'package:emotion_tracker/app/ui/utils/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MoodCard extends StatelessWidget {
  final Journal journal;

  const MoodCard({Key? key, required this.journal}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: valueToColor(journal.value),
      elevation: 5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: Get.height * 0.015,
          ),
          // Top Row (Emoji, Date, Mood)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white60,
                    child: AnimatedEmoji(
                      journal.emotion,
                      size: 60,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.06),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.calendar,
                            color: Get.theme.colorScheme.onError,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd/MM/yy').format(journal.date),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Get.theme.colorScheme.onError,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.smiley_fill,
                            color: Get.theme.colorScheme.onError,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            valueToString(journal.value),
                            style: TextStyle(
                              color: Get.theme.colorScheme.onError,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
    
          const Spacer(),
    
          // Mood Entry
          Container(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
            width: Get.width * 0.6,
            height: Get.height * 0.06,
            child: Text(
              journal.content,
              textAlign: TextAlign.center,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
    
          // const Spacer(),
          SizedBox(
            height: Get.height * 0.003,
          ),
          // Share Button
          InkWell(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            onTap: () => showShareSheet(journal),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.06, vertical: Get.width * 0.03),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                color: Colors.white30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    Icons.share,
                    color: Colors.black87,
                  ),
                  SizedBox(
                    width: Get.width * 0.03,
                  ),
                  const Text(
                    "share",
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
