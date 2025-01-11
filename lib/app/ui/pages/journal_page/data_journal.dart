// ignore_for_file: invalid_use_of_protected_member

import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/ui/pages/journal_page/new_journal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class DataJournalPage extends StatelessWidget {
  DataJournalPage({
    Key? key,
  }) : super(key: key);

  JournalController journalController = Get.put(JournalController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () {
            var journalList = journalController.journals.value;
            int index = journalController.indexDataJournal.value;
            return GestureDetector(
              onHorizontalDragEnd: (details) {
                if (details.primaryVelocity != null) {
                  if (details.primaryVelocity! > 0) {
                    journalController.previousPage();
                  } else if (details.primaryVelocity! < 0) {
                    journalController.nextPage();
                  }
                }
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.04),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                // Dummy delete action
                              },
                              icon: const Icon(
                                CupertinoIcons.delete,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Get.to(
                                  () => NewJournalPage(
                                    date: journalList[index].date,
                                    editContent: journalList[index].content,
                                    editEmoji: journalList[index].emotion,
                                  ),
                                );
                                // Dummy edit action
                              },
                              icon: const Icon(
                                CupertinoIcons.pen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.8,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.width * 0.01),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: AnimatedEmoji(
                              journalList[index].emotion,
                              errorWidget: Text(
                                journalList[index].emotion.toUnicodeEmoji(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 100),
                              ),
                              size: 150,
                              source: AnimatedEmojiSource.asset,
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    journalController.previousPage();
                                  },
                                  icon: const Icon(CupertinoIcons.left_chevron),
                                ),
                                Title(
                                  color: Colors.black,
                                  child: Text(
                                    DateFormat('EEEE, MMMM d, y')
                                        .format(journalList[journalController
                                                .indexDataJournal.value]
                                            .date)
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
                                    journalController.nextPage();
                                  },
                                  icon:
                                      const Icon(CupertinoIcons.right_chevron),
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
                                  journalList[journalController
                                          .indexDataJournal.value]
                                      .content,
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class Journal {
  final String uid;
  final DateTime date;
  final String content;
  final AnimatedEmojiData emotion;

  Journal({
    required this.uid,
    required this.date,
    required this.content,
    required this.emotion,
  });
}

class JournalPageView extends StatelessWidget {
  final JournalController journalController = Get.put(JournalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(
          () {
            var journalList = journalController.journals.value;
            int index = journalController.indexDataJournal.value;
            return PageView.builder(
              itemCount: journalList.length,
              controller: PageController(initialPage: index),
              onPageChanged: (newIndex) {
                journalController.indexDataJournal.value = newIndex;
              },
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.04),
                          child: IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: const Icon(CupertinoIcons.xmark),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.04),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  journalController.deleteJournal(
                                      journalList[index].date.toString());
                                },
                                icon: const Icon(CupertinoIcons.delete),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.to(
                                    () => NewJournalPage(
                                      date: journalList[index].date,
                                      editContent: journalList[index].content,
                                      editEmoji: journalList[index].emotion,
                                    ),
                                  );
                                },
                                icon: const Icon(CupertinoIcons.pen),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.8,
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.01),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: AnimatedEmoji(
                                journalList[index].emotion,
                                errorWidget: Text(
                                  journalList[index].emotion.toUnicodeEmoji(),
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
                                      journalController.previousPage();
                                    },
                                    icon:
                                        const Icon(CupertinoIcons.left_chevron),
                                  ),
                                  Title(
                                    color: Colors.black,
                                    child: Text(
                                      DateFormat('EEEE, MMMM d, y')
                                          .format(journalList[journalController
                                                  .indexDataJournal.value]
                                              .date)
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
                                      journalController.nextPage();
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
                                    journalList[journalController
                                            .indexDataJournal.value]
                                        .content,
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
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
