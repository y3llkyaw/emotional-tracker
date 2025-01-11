import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/data/models/journal.dart';
import 'package:emotion_tracker/app/ui/pages/journal_page/new_journal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DataJournalPage extends StatefulWidget {
  final DateTime date;
  final int? index;

  const DataJournalPage({
    Key? key,
    required this.date,
    this.index,
  }) : super(key: key);
  @override
  State<DataJournalPage> createState() => _DataJournalPageState();
}

class _DataJournalPageState extends State<DataJournalPage> {
  final TextEditingController textEditingController = TextEditingController();
  final journalController = JournalController();
  List<Journal> journals = [
    Journal(
        uid: "",
        date: DateTime.now(),
        content: "",
        emotion: AnimatedEmojis.iceHockey)
  ];
  @override
  void initState() {
    journalController.fetchJournals().then((v) {
      setState(() {
        journals = journalController.journals.value;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    journalController.getJournal(widget.date);
    journalController.fetchJournals();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                  child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(
                      CupertinoIcons.xmark,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          await journalController
                              .deleteJournal(widget.date.toString());
                        },
                        icon: const Icon(
                          CupertinoIcons.delete,
                        ),
                      ),
                      Obx(
                        () => journalController.singleJournal.value != null
                            ? IconButton(
                                onPressed: () async {
                                  await Get.to(
                                    () => NewJournalPage(
                                      date: widget.date,
                                      editContent: journalController
                                          .singleJournal.value!.content,
                                      editEmoji: journalController
                                          .singleJournal.value!.emotion,
                                    ),
                                  );
                                  journalController.getJournal(widget.date);
                                },
                                icon: const Icon(
                                  CupertinoIcons.pen,
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Obx(
              () {
                return journalController.singleJournal.value != null
                    ? SizedBox(
                        height: Get.height * 0.8,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.01),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: AnimatedEmoji(
                                  journalController
                                      .singleJournal.value!.emotion,
                                  errorWidget: Text(
                                    journalController
                                        .singleJournal.value!.emotion
                                        .toUnicodeEmoji(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 100),
                                  ),
                                  size: 150,
                                  source: AnimatedEmojiSource.asset,
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (widget.index != 0 &&
                                            widget.index != null) {
                                          Get.back();
                                          Get.to(
                                            () => DataJournalPage(
                                              date: journals[widget.index! - 1]
                                                  .date,
                                              index: widget.index! - 1,
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                          CupertinoIcons.left_chevron),
                                    ),
                                    Title(
                                      color: Colors.black,
                                      child: Text(
                                        DateFormat('EEEE, MMMM d, y')
                                            .format(journalController
                                                .singleJournal.value!.date)
                                            .toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          wordSpacing: 0,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        if (widget.index !=
                                                (journals.length - 1) &&
                                            widget.index != null) {
                                          Get.to(
                                              () => DataJournalPage(
                                                    date: journals[
                                                            widget.index! + 1]
                                                        .date,
                                                    index: widget.index! + 1,
                                                  ),
                                              transition:
                                                  Transition.circularReveal);
                                        }
                                      },
                                      icon: const Icon(
                                          CupertinoIcons.right_chevron),
                                    ),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.07),
                                  child: Center(
                                    child: Text(
                                      journalController
                                          .singleJournal.value!.content,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: Get.width * 0.04,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
