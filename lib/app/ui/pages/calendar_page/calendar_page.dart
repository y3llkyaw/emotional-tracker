import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/ui/global_widgets/bottom_sheet.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:get/get.dart';

import 'package:emotion_tracker/app/ui/global_widgets/custom_radio_button.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../controllers/home_controller.dart';

class CalendarPage extends GetView<HomeController> {
  CalendarPage({Key? key}) : super(key: key);
  final HomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title goes here
            const Text(
              "Calendar",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // fliter widget goes here
            const CustomRadioButton(
              title: 'September',
              title2: 'History',
            ),
            const SizedBox(
              height: 20,
            ),
            // calendar goes here
            TableCalendar(
              headerVisible: false,
              weekNumbersVisible: false,
              focusedDay: DateTime.now(),
              firstDay: DateTime(DateTime.now().year - 1),
              lastDay: DateTime(DateTime.now().year + 1),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, events) => InkWell(
                  splashColor: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(40),
                  onTap: date.isBefore(DateTime.now())
                      ? () => showEmojiBottomSheet(date)
                      : null,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                          color: date.isBefore(DateTime.now())
                              ? Colors.black
                              : Colors.grey),
                    ),
                  ),
                ),
                todayBuilder: (context, day, focusedDay) {
                  return GestureDetector(
                    onTap: () {},
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(4.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ReactionButton(
                              selectedReaction: const Reaction<String>(
                                value: 'neutral',
                                icon: AnimatedEmoji(
                                  AnimatedEmojis.neutralFace,
                                  errorWidget: Text(
                                    "😐",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              onReactionChanged: (val) {},
                              reactions: const [
                                Reaction<String>(
                                  value: 'furious',
                                  icon: AnimatedEmoji(
                                    AnimatedEmojis.angry,
                                    errorWidget: Text(
                                      "😡",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Reaction<String>(
                                  value: 'sad',
                                  icon: AnimatedEmoji(
                                    AnimatedEmojis.sad,
                                    errorWidget: Text(
                                      "😢",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Reaction<String>(
                                  value: 'neutral',
                                  icon: AnimatedEmoji(
                                    AnimatedEmojis.neutralFace,
                                    errorWidget: Text(
                                      "😐",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Reaction<String>(
                                  value: 'happy',
                                  icon: AnimatedEmoji(
                                    AnimatedEmojis.smile,
                                    errorWidget: Text(
                                      "😊",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Reaction<String>(
                                  value: 'joy',
                                  icon: AnimatedEmoji(
                                    AnimatedEmojis.joy,
                                    errorWidget: Text(
                                      "😂",
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              boxColor: Colors.black.withOpacity(0.5),
                              boxRadius: 15,
                              itemsSpacing: 20,
                              itemSize: const Size(30, 30),
                            ),
                            Transform(
                              transform: Matrix4.translationValues(15, 15, 0),
                              child: Container(
                                width: Get.width * 0.05,
                                height: Get.width * 0.05,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    day.day.toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
