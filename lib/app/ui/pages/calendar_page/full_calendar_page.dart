import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/bottom_sheet.dart';
import 'package:emotion_tracker/app/ui/pages/journal_page/data_journal.dart';
import 'package:emotion_tracker/app/ui/pages/journal_page/new_journal.dart';
import 'package:emotion_tracker/app/ui/utils/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class FullCalendarPage extends StatefulWidget {
  const FullCalendarPage({Key? key}) : super(key: key);

  @override
  State<FullCalendarPage> createState() => _FullCalendarPageState();
}

class _FullCalendarPageState extends State<FullCalendarPage> {
  final JournalController journalController = Get.put(JournalController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Get.width * 0.08,
                  vertical: Get.width * 0.01,
                ),
                child: Row(
                  children: [
                    Text(
                      journalController.journals.isEmpty
                          ? 'Full Calendar'
                          : 'Full Calendar',
                      style: TextStyle(
                        fontSize: Get.width * 0.046,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                    const Icon(
                      CupertinoIcons.calendar,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(CupertinoIcons.xmark),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.005),
                child: _calendar(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _calendar() {
  return SizedBox(
    height: Get.height * 0.75,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TableCalendar(
        shouldFillViewport: true,
        rowHeight: Get.height * 0.11,
        headerVisible: true,
        availableCalendarFormats: const {
          CalendarFormat.month: 'calendar',
          CalendarFormat.week: 'calendar',
        },
        onFormatChanged: (format) {
          Get.back();
        },
        availableGestures: AvailableGestures.horizontalSwipe,
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: Get.width * 0.04,
          ),
          titleCentered: false,
          formatButtonVisible: true,
          leftChevronVisible: false,
          rightChevronVisible: false,
          headerPadding: EdgeInsets.all(Get.width * 0.06),
          formatButtonDecoration: const BoxDecoration(
            color: Color.fromARGB(255, 0, 92, 167),
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          formatButtonTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
        ),
        calendarFormat: CalendarFormat.month,
        formatAnimationCurve: Curves.easeInOut,
        formatAnimationDuration: const Duration(milliseconds: 400),
        weekNumbersVisible: true,
        focusedDay: DateTime.now(),
        firstDay: DateTime(DateTime.now().year - 1),
        lastDay: DateTime.now(),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, date, events) {
            for (var element in journalController.journals) {
              if (DateTime(element.date.day, element.date.month,
                      element.date.year) ==
                  DateTime(date.day, date.month, date.year)) {
                return dataCalendar(
                    date, element.content, element.emotion, element.value);
              }
            }
            return defaultCalendar(date);
          },
          todayBuilder: (context, date, events) {
            for (var element in journalController.journals) {
              if (DateTime(element.date.day, element.date.month,
                      element.date.year) ==
                  DateTime(date.day, date.month, date.year)) {
                return dataCalendar(
                    date, element.content, element.emotion, element.value);
              }
            }
            return defaultCalendar(date);
          },
          disabledBuilder: (context, day, focusedDay) => disableCalaneder(day),
          outsideBuilder: (context, date, events) {
            for (var element in journalController.journals) {
              if (DateTime(element.date.day, element.date.month,
                      element.date.year) ==
                  DateTime(date.day, date.month, date.year)) {
                return dataCalendar(
                    date, element.content, element.emotion, element.value);
              }
            }
            return defaultCalendar(date);
          },
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
          ? () => Get.to(
                () => NewJournalPage(date: date),
                transition: Transition.downToUp,
              )
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

Widget dataCalendar(
    DateTime day, String content, AnimatedEmojiData emojiData, int value) {
  return Padding(
    padding: const EdgeInsets.only(top: 15),
    child: GestureDetector(
      onTap: () async {
        await Get.to(
          () => JournalPageView(),
          transition: Transition.downToUp,
        );
        journalController.fetchJournals();
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
                    fontSize: Get.width * 0.08,
                  ),
                ),
              ),
              source: AnimatedEmojiSource.asset,
            ),
            SizedBox(
              height: Get.height * 0.01,
            ),
            Center(
              child: CircleAvatar(
                radius: Get.width * 0.028,
                backgroundColor: valueToColor(value),
                child: Text(
                  day.day.toString(),
                  style: TextStyle(
                    fontSize: Get.width * 0.023,
                    color: Colors.white,
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
