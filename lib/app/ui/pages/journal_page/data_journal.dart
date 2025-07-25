// ignore_for_file: invalid_use_of_protected_member

import 'package:animated_emoji/animated_emoji.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:emotion_tracker/app/ui/global_widgets/share_sheet.dart';
import 'package:emotion_tracker/app/ui/pages/journal_page/new_journal.dart';
import 'package:emotion_tracker/app/ui/utils/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

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
            if (index < 0 || index >= journalList.length) {
              return const Center(
                child: Text('No journal entry available'),
              );
            }
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

class JournalPageView extends StatelessWidget {
  final JournalController journalController = Get.put(JournalController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        var journalList = journalController.journals.value;
        int index = journalController.indexDataJournal.value;
        if (index < 0 || index >= journalList.length) {
          return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No journal entry available'),
                  SizedBox(
                    height: Get.height * 0.2,
                  ),
                  CustomButton(
                    text: "Back",
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ],
              ));
        }
        return PageView.builder(
          itemCount: journalList.length,
          controller: PageController(initialPage: index),
          onPageChanged: (newIndex) {
            journalController.indexDataJournal.value = newIndex;
          },
          itemBuilder: (context, index) {
            return Scaffold(
              // backgroundColor: valueToColor(journalList[index].value),
              body: SafeArea(
                child: Column(
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
                            icon: const Icon(
                              CupertinoIcons.xmark,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.04),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  QuickAlert.show(
                                      context: context,
                                      type: QuickAlertType.confirm,
                                      backgroundColor: Get.theme.canvasColor,
                                      textColor:
                                          Get.theme.colorScheme.onSurface,
                                      text: 'Do you want to Delete',
                                      confirmBtnText: 'Yes',
                                      cancelBtnText: 'No',
                                      confirmBtnColor: Colors.red,
                                      onCancelBtnTap: () => Get.back(),
                                      onConfirmBtnTap: () async {
                                        final player = AudioPlayer();
                                        await player.play(
                                            AssetSource('audio/swoosh.mp3'));
                                        player.onPlayerComplete.listen((event) {
                                          player.dispose();
                                        });
                                        journalController.deleteJournal(
                                            journalList[index].date.toString());
                                      });
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
                                      editValue: journalList[index].value,
                                    ),
                                    transition: Transition.downToUp,
                                  );
                                },
                                icon: const Icon(CupertinoIcons.pen),
                              ),
                              IconButton(
                                onPressed: () {
                                  showShareSheet(journalList[index]);
                                },
                                icon: const Icon(CupertinoIcons.share),
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
                              child: Hero(
                                tag: "emoji_${journalList[index].date}",
                                child: AnimatedEmoji(
                                  journalList[journalController
                                          .indexDataJournal.value]
                                      .emotion,
                                  errorWidget: Text(
                                    journalList[journalController
                                            .indexDataJournal.value]
                                        .emotion
                                        .toUnicodeEmoji(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 100),
                                  ),
                                  size: 150,
                                  source: AnimatedEmojiSource.asset,
                                ),
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
                                    icon: const Icon(
                                      CupertinoIcons.left_chevron,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Title(
                                        color: Colors.black,
                                        child: Text(
                                          DateFormat('EEEE, MMMM d, y')
                                              .format(journalList[
                                                      journalController
                                                          .indexDataJournal
                                                          .value]
                                                  .date)
                                              .toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            wordSpacing: 0,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: Get.height * 0.01,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.smiley,
                                            color: valueToColor(
                                              journalList[journalController
                                                      .indexDataJournal.value]
                                                  .value,
                                            ),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                          Text(
                                            valueToString(journalList[
                                                    journalController
                                                        .indexDataJournal.value]
                                                .value),
                                            style: TextStyle(
                                              color: valueToColor(
                                                journalList[journalController
                                                        .indexDataJournal.value]
                                                    .value,
                                              ),
                                              fontWeight: FontWeight.bold,
                                              fontSize: Get.width * 0.04,
                                            ),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.02,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      journalController.nextPage();
                                    },
                                    icon: const Icon(
                                      CupertinoIcons.right_chevron,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.03),
                                decoration: BoxDecoration(
                                  color: Get.theme.colorScheme.onSecondary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: Get.height * 0.33,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.07,
                                    vertical: Get.width * 0.07,
                                  ),
                                  child: Center(
                                    child: SelectableText(
                                      journalList[journalController
                                              .indexDataJournal.value]
                                          .content
                                          .toString(),
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: Get.width * 0.04,
                                        // color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
