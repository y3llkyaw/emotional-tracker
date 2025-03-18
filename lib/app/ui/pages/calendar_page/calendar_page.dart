import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/controllers/chat_controller.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/controllers/online_controller.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/share_sheet.dart';
import 'package:emotion_tracker/app/ui/pages/calendar_page/full_calendar_page.dart';
import 'package:emotion_tracker/app/ui/pages/calendar_page/piechart_page.dart';
import 'package:emotion_tracker/app/ui/pages/journal_page/data_journal.dart';
import 'package:emotion_tracker/app/ui/pages/journal_page/new_journal.dart';
import 'package:emotion_tracker/app/ui/utils/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:emotion_tracker/app/controllers/home_controller.dart';

class CalendarPage extends GetView<HomeController> {
  CalendarPage({Key? key}) : super(key: key);

  final JournalController journalController = Get.put(JournalController());
  final OnlineController onlineController = Get.put(OnlineController());
  final FriendsController friendsController = Get.put(FriendsController());
  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    journalController.fetchJournals();
    onlineController.updateOnlineStatus();
    return Scaffold(
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            calendar(),
            Divider(
              color: Colors.grey.shade300,
            ),
            PiechartPage(),
            Divider(
              color: Colors.grey.shade300,
            ),
            Expanded(
              child: ListView.builder(
                reverse: true,
                controller: ScrollController(),
                scrollDirection: Axis.horizontal,
                itemCount: journalController.journals.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(Get.height * 0.02),
                    child: Card(
                      color:
                          valueToColor(journalController.journals[index].value),
                      shadowColor: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.translationValues(
                                    -Get.width * 0.02, -Get.height * 0.022, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: valueToColor(journalController
                                          .journals[index].value),
                                      shape: BoxShape.circle),
                                  child: CircleAvatar(
                                    radius: 30,
                                    backgroundColor:
                                        Colors.white.withOpacity(0.4),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AnimatedEmoji(
                                        journalController
                                            .journals[index].emotion,
                                        size: 50,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.translationValues(
                                    Get.width * 0.009, -Get.height * 0.012, 0),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.03),
                                  child: Text(
                                    DateFormat('MMMM d, y').format(
                                      journalController.journals[index].date,
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.05,
                            ),
                            child: SizedBox(
                              width: 200,
                              height: 100,
                              child: Center(
                                child: Text(
                                  journalController.journals[index].content,
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.05,
                            ),
                            child: InkWell(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              onTap: () {
                                // "journal_${date.value.toString().split(" ")[0]}"
                                final jid =
                                    "journal_${journalController.journals[index].date.toString().split(" ")[0]}";
                                showShareSheet(
                                    journalController.journals[index]);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Icon(
                                      Icons.share,
                                    ),
                                    Text(
                                      "share",
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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

  Widget calendar() {
    return SizedBox(
      height: Get.height / 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        child: TableCalendar(
          shouldFillViewport: true,
          rowHeight: Get.height * 0.11,
          headerVisible: true,
          availableCalendarFormats: const {
            CalendarFormat.month: 'full-calendar',
            CalendarFormat.week: 'full-calendar',
            CalendarFormat.twoWeeks: 'full-calendar',
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
          calendarFormat: CalendarFormat.week,
          onFormatChanged: (format) {
            // journalController.toggleCalendarFormat();
            Get.to(() => const FullCalendarPage(),
                transition: Transition.downToUp);
          },
          formatAnimationCurve: Curves.easeInOut,
          formatAnimationDuration: const Duration(milliseconds: 400),
          weekNumbersVisible: true,
          focusedDay: DateTime.now(),
          firstDay: DateTime(DateTime.now().year - 1),
          lastDay: DateTime.now(),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, date, events) {
              int index = 0;
              for (var element in journalController.journals) {
                if (DateTime(element.date.day, element.date.month,
                        element.date.year) ==
                    DateTime(date.day, date.month, date.year)) {
                  return dataCalendar(date, element.content, element.emotion,
                      index, element.value);
                }
                index++;
              }
              return defaultCalendar(date);
            },
            todayBuilder: (context, date, events) {
              int index = 0;
              for (var element in journalController.journals) {
                if (DateTime(element.date.day, element.date.month,
                        element.date.year) ==
                    DateTime(date.day, date.month, date.year)) {
                  return dataCalendar(date, element.content, element.emotion,
                      index, element.value);
                }
                index++;
              }
              return defaultCalendar(date);
            },
            disabledBuilder: (context, day, focusedDay) =>
                disableCalaneder(day),
            outsideBuilder: (context, date, events) {
              int index = 0;
              for (var element in journalController.journals) {
                if (DateTime(element.date.day, element.date.month,
                        element.date.year) ==
                    DateTime(date.day, date.month, date.year)) {
                  return dataCalendar(date, element.content, element.emotion,
                      index, element.value);
                }
                index++;
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
    final bool isToday = DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;

    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        onTap: date.isBefore(DateTime.now().add(const Duration(days: 1)))
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
              backgroundColor: isToday ? Colors.blue : Colors.grey.shade200,
              child: Text(
                date.day.toString(),
                style: TextStyle(
                  fontSize: Get.width * 0.023,
                  color: isToday
                      ? Colors.white
                      : date.isBefore(
                              DateTime.now().add(const Duration(days: 1)))
                          ? Colors.black
                          : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataCalendar(DateTime day, String content, AnimatedEmojiData emojiData,
      int index, int value) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: GestureDetector(
        onTap: () async {
          journalController.indexDataJournal.value = index;
          Get.to(
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
}
