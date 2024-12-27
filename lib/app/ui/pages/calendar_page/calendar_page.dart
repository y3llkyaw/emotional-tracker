import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/bottom_sheet.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../controllers/home_controller.dart';

class CalendarPage extends GetView<HomeController> {
  CalendarPage({Key? key}) : super(key: key);
  final JournalController journalController = Get.put(JournalController());
  @override
  Widget build(BuildContext context) {
    journalController.fetchJournals();
    return Scaffold(
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // title goes here
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                journalController.journals.isEmpty ? 'No Journals' : 'Journals',
                style: TextStyle(
                  fontSize: Get.width * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // fliter widget goes here
            // const Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20),
            //   child: CustomRadioButton(
            //     title: 'September',
            //     title2: 'History',
            //   ),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // calendar goes here
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TableCalendar(
                rowHeight: Get.height * 0.11,
                headerVisible: true,
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                weekNumbersVisible: true,
                focusedDay: DateTime.now(),
                firstDay: DateTime(DateTime.now().year - 1),
                lastDay: DateTime(DateTime.now().year + 1),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, date, events) {
                    for (var element in journalController.journals) {
                      if (DateTime(element.date.day, element.date.month,
                              element.date.year) ==
                          DateTime(date.day, date.month, date.year)) {
                        return dataCalendar(
                            date, element.content, element.emotion);
                      }
                    }
                    return defaultCalendar(date);
                  },
                  todayBuilder: (context, day, focusedDay) =>
                      defaultCalendar(day),
                  disabledBuilder: (context, day, focusedDay) =>
                      disableCalaneder(day),
                  outsideBuilder: (context, day, focusedDay) =>
                      disableCalaneder(day),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget disableCalaneder(DateTime date) {
  return Padding(
    padding: const EdgeInsets.only(top: 15),
    child: Column(
      children: [
        SizedBox(
          height: Get.width * 0.12,
        ),
        Center(
            child: Text(
          date.day.toString(),
          style: const TextStyle(color: Colors.grey),
        )),
      ],
    ),
  );
}

Widget defaultCalendar(DateTime date) {
  return Padding(
    padding: const EdgeInsets.only(top: 15),
    child: InkWell(
      // splashColor: Colors.orangeAccent,
      borderRadius: BorderRadius.circular(40),
      onTap: date.isBefore(DateTime.now())
          ? () => showEmojiBottomSheet(date)
          : null,
      child: Column(
        children: [
          SizedBox(
            height: Get.width * 0.1,
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              date.day.toString(),
              style: TextStyle(
                color:
                    date.isBefore(DateTime.now()) ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget dataCalendar(DateTime day, String content, AnimatedEmojiData emojiData) {
  return Padding(
    padding: const EdgeInsets.only(top: 15),
    child: GestureDetector(
      onTap: () {
        showDataBottomSheet(day, content, emojiData);
      },
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedEmoji(
              emojiData,
              size: Get.width * 0.1,
              errorWidget: Center(
                child: Text(
                  emojiData.toUnicodeEmoji(),
                  style: TextStyle(
                    fontSize: Get.width * 0.1,
                  ),
                ),
              ),
            ),
            Center(
              child: CircleAvatar(
                backgroundColor: Colors.yellow.withOpacity(0.1),
                child: Text(
                  day.day.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    // fontSize: 11,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
