import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:emotion_tracker/app/ui/pages/journal_page/data_journal.dart';
import 'package:emotion_tracker/app/ui/pages/journal_page/journal_emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewJournalPage extends StatefulWidget {
  final DateTime date;
  final String? editContent;
  final AnimatedEmojiData? editEmoji;
  const NewJournalPage(
      {Key? key, required this.date, this.editContent, this.editEmoji})
      : super(key: key);
  @override
  State<NewJournalPage> createState() => _NewJournalPageState();
}

class _NewJournalPageState extends State<NewJournalPage> {
  final JournalController journalController = Get.put(JournalController());
  final ProfilePageController profilePageController =
      Get.put(ProfilePageController());

  final TextEditingController textEditingController = TextEditingController();

  AnimatedEmojiData selectedEmoji = AnimatedEmojis.neutralFace;

  @override
  void initState() {
    profilePageController.getCurrentUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    journalController.emotion.value =
        widget.editEmoji ?? AnimatedEmojis.airplaneArrival;
    journalController.content.value = widget.editContent ?? "";
    textEditingController.text = widget.editContent ?? "";
    selectedEmoji = widget.editEmoji ?? AnimatedEmojis.neutralFace;
    final basicEmojis = [
      AnimatedEmojis.angry,
      AnimatedEmojis.sad,
      AnimatedEmojis.neutralFace,
      AnimatedEmojis.smile,
      AnimatedEmojis.joy,
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
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
              ],
            ),
            Obx(
              () => Center(
                child: AnimatedEmoji(
                  journalController.emotion.value,
                  size: 100,
                ),
              ),
            ),
            SizedBox(
              height: Get.height * 0.7,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Title(
                        color: Colors.black,
                        child: Text(
                          "WHAT'S YOUR MOOD TODAY?",
                          style: TextStyle(
                            fontSize: Get.width * 0.05,
                            fontWeight: FontWeight.bold,
                            wordSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Title(
                        color: Colors.black,
                        child: Text(
                          DateFormat('EEEE, MMMM d, y').format(widget.date),
                          style: TextStyle(
                            fontSize: Get.width * 0.04,
                            fontWeight: FontWeight.w500,
                            wordSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                    Obx(() => JournalEmojiWidget(
                        emojis: profilePageController
                                .userProfile.value!.recentEmojis.isEmpty
                            ? basicEmojis
                            : profilePageController
                                .userProfile.value!.recentEmojis,
                        onClick: (emoji) {
                          journalController.emotion.value = emoji;
                        })),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.02),
                          child: Title(
                            color: Colors.black,
                            child: Text(
                              "TEll ME HOW YOU FEEL",
                              style: TextStyle(
                                fontSize: Get.width * 0.04,
                                fontWeight: FontWeight.w700,
                                wordSpacing: 0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        Container(
                          padding: EdgeInsets.all(Get.width * 0.04),
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 0.4,
                                // offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Describe how you feel today!",
                              border: InputBorder.none,
                            ),
                            controller: textEditingController,
                            maxLines: 10,
                          ),
                        ),
                      ],
                    ),
                    Obx(
                      () => CustomButton(
                        isLoading: journalController.isLoading.value,
                        text: "Confirm",
                        onPressed: () async {
                          journalController.content.value =
                              textEditingController.text;
                          journalController.date.value = widget.date;
                          journalController.createJournal().then((value) async {
                            await profilePageController
                                .getCurrentUserProfile()
                                .then((value) {
                              if (!profilePageController
                                  .userProfile.value!.recentEmojis
                                  .contains(journalController.emotion.value)) {
                                profilePageController
                                    .userProfile.value!.recentEmojis
                                    .add(journalController.emotion.value);
                                profilePageController
                                    .userProfile.value!.recentEmojis
                                    .removeAt(0);
                              }
                              profilePageController.updateRecentEmojis();
                            });
                            if (widget.editEmoji != null) {
                              Get.back();
                              await journalController.getJournal(widget.date);
                              Get.to(() => DataJournalPage(date: widget.date));
                            }
                            journalController.emotion.value =
                                AnimatedEmojis.neutralFace;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
