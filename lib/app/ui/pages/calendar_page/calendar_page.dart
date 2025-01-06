import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
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
      body: SingleChildScrollView(
        child: Obx(
          () => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // title goes here
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.08,
                vertical: Get.width * 0.04,
              ),
              child: Row(
                children: [
                  Text(
                    journalController.journals.isEmpty
                        ? 'No Journals'
                        : 'Journals',
                    style: TextStyle(
                      fontSize: Get.width * 0.046,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.02,
                  ),
                  const Icon(CupertinoIcons.news_solid),
                ],
              ),
            ),
            SizedBox(
              height: Get.width * 0.03,
            ),
            // calendar goes here
            calendar(),
            const Center(
              child: Wrap(
                spacing: 40,
                runSpacing: 20,
                children: [],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

Widget calendar() {
  return SizedBox(
    height: journalController.formatCalender.value == CalendarFormat.week
        ? Get.height * 0.22
        : Get.height * 0.7,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TableCalendar(
        shouldFillViewport: true,
        rowHeight: Get.height * 0.11,
        headerVisible: true,
        availableCalendarFormats: const {
          CalendarFormat.month: 'monthly / weekly',
          CalendarFormat.week: 'monthly / weekly',
        },
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: Get.width * 0.04,
          ),
          titleCentered: false,
          formatButtonVisible: false,
          leftChevronVisible: false,
          rightChevronVisible: false,
          headerPadding: EdgeInsets.all(Get.width * 0.06),
        ),
        calendarFormat: journalController.formatCalender.value,
        onFormatChanged: (format) {
          journalController.toggleCalendarFormat();
        },
        formatAnimationCurve: Curves.easeInOut,
        formatAnimationDuration: const Duration(milliseconds: 400),
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
                return dataCalendar(date, element.content, element.emotion);
              }
            }
            return defaultCalendar(date);
          },
          disabledBuilder: (context, day, focusedDay) => disableCalaneder(day),
          todayBuilder: (context, date, events) {
            for (var element in journalController.journals) {
              if (DateTime(element.date.day, element.date.month,
                      element.date.year) ==
                  DateTime(date.day, date.month, date.year)) {
                return dataCalendar(date, element.content, element.emotion);
              }
            }
            return defaultCalendar(date);
          },
          outsideBuilder: (context, day, focusedDay) => disableCalaneder(day),
        ),
      ),
    ),
  );
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
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
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
            height: Get.width * 0.12,
          ),
          CircleAvatar(
            radius: Get.width * 0.028,
            backgroundColor: Colors.grey.shade200,
            child: Text(
              date.day.toString(),
              style: TextStyle(
                fontSize: Get.width * 0.023,
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
            SizedBox(
              height: Get.height * 0.01,
            ),
            Center(
              child: CircleAvatar(
                radius: Get.width * 0.028,
                backgroundColor: Colors.yellow,
                child: Text(
                  day.day.toString(),
                  style: TextStyle(
                    fontSize: Get.width * 0.023,
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
