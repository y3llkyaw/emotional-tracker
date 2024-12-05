// import 'dart:ffi';
import 'dart:ui';
import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/cupertino.dart';
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
      appBar: AppBar(),
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
                // defaultBuilder: (context, date, events) => Container(
                //   margin: const EdgeInsets.all(4.0),
                //   alignment: Alignment.center,
                //   decoration: BoxDecoration(
                //     color: Colors.orange,
                //     borderRadius: BorderRadius.circular(20.0),
                //   ),
                //   child: Text(
                //     date.day.toString(),
                //     style: const TextStyle(color: Colors.white),
                //   ),
                // ),
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
