import 'package:animated_emoji/animated_emoji.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/controllers/mood_slider_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:emotion_tracker/app/ui/global_widgets/slider_widget.dart';
import 'package:emotion_tracker/app/ui/pages/journal_page/journal_emoji.dart';
import 'package:emotion_tracker/app/ui/utils/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewJournalPage extends StatefulWidget {
  final DateTime date;
  final String? editContent;
  final AnimatedEmojiData? editEmoji;
  final int? editValue;
  const NewJournalPage(
      {Key? key,
      required this.date,
      this.editContent,
      this.editEmoji,
      this.editValue})
      : super(key: key);
  @override
  State<NewJournalPage> createState() => _NewJournalPageState();
}

class _NewJournalPageState extends State<NewJournalPage> {
  final JournalController journalController = Get.put(JournalController());
  final ProfilePageController profilePageController =
      Get.put(ProfilePageController());
  final MoodSliderController moodSliderController =
      Get.put(MoodSliderController());
  final TextEditingController textEditingController = TextEditingController();

  AnimatedEmojiData selectedEmoji = AnimatedEmojis.neutralFace;

  @override
  void initState() {
    profilePageController.getCurrentUserProfile();
    textEditingController.text = widget.editContent ?? "";
    journalController.emotion.value = widget.editEmoji ?? AnimatedEmojis.bat;
    journalController.content.value = widget.editContent ?? "";

    selectedEmoji = widget.editEmoji ?? AnimatedEmojis.neutralFace;
    if (widget.editValue != null) {
      moodSliderController.sliderValue.value = widget.editValue!.toDouble();
      journalController.moodSlider.value = widget.editValue!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final basicEmojis = [
      AnimatedEmojis.angry,
      AnimatedEmojis.sad,
      AnimatedEmojis.neutralFace,
      AnimatedEmojis.smile,
      AnimatedEmojis.joy,
    ];
    return Scaffold(
      body: SafeArea(
        child: AnimatedContainer(
          height: Get.height,
          duration: const Duration(
            milliseconds: 200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Title(
                              color: Colors.black,
                              child: Text(
                                "WHAT'S YOUR MOOD TODAY?",
                                style: TextStyle(
                                  fontSize: Get.height * 0.021,
                                  fontWeight: FontWeight.bold,
                                  wordSpacing: 0,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
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
                      ],
                    ),
                    Title(
                      color: Colors.black,
                      child: Text(
                        DateFormat('EEEE, MMMM d, y').format(widget.date),
                        style: TextStyle(
                          fontSize: Get.height * 0.017,
                          fontWeight: FontWeight.w500,
                          wordSpacing: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(
                () => Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CircleAvatar(
                        radius: Get.width / 5,
                        backgroundColor: valueToColor(
                            journalController.moodSlider.value.toInt()),
                        child: AnimatedEmoji(
                          journalController.emotion.value,
                          size: Get.width / 5,
                        ),
                      ),
                      MoodSliderWidget(
                        onChange: (value) {
                          journalController.moodSlider.value = value;
                        },
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.55,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => JournalEmojiWidget(
                          emojis: profilePageController
                                  .userProfile.value!.recentEmojis.isEmpty
                              ? basicEmojis
                              : profilePageController
                                  .userProfile.value!.recentEmojis,
                          onClick: (emoji) {
                            journalController.emotion.value = emoji;
                          },
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Obx(
                            () => Container(
                              padding: EdgeInsets.all(Get.width * 0.04),
                              decoration: BoxDecoration(
                                color: Colors.white60,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: valueToColor(journalController
                                        .moodSlider.value
                                        .toInt()),
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
                          ),
                        ],
                      ),
                      const Spacer(),
                      Obx(
                        () => CustomButton(
                          isLoading: journalController.isLoading.value,
                          text: "Confirm",
                          color: valueToColor(
                              journalController.moodSlider.value.toInt()),
                          onPressed: () async {
                            journalController.content.value =
                                textEditingController.text;
                            journalController.date.value = widget.date;
                            journalController.moodSlider.value =
                                moodSliderController.sliderValue.value.toInt();
                            journalController
                                .createJournal()
                                .then((value) async {
                              await profilePageController
                                  .getCurrentUserProfile()
                                  .then((value) {
                                if (!profilePageController
                                    .userProfile.value!.recentEmojis
                                    .contains(
                                        journalController.emotion.value)) {
                                  profilePageController
                                      .userProfile.value!.recentEmojis
                                      .add(journalController.emotion.value);
                                  profilePageController
                                      .userProfile.value!.recentEmojis
                                      .removeAt(0);
                                }
                                profilePageController
                                    .updateRecentEmojis()
                                    .then((value) {});
                              });
                              if (widget.editEmoji != null) {
                                Get.back();
                                await journalController.getJournal(widget.date);
                                // Get.to(() => DataJournalPage(date: widget.date));
                              }
                              journalController.moodSlider.value = 2;
                            });
                            final player = AudioPlayer();
                            player.play(AssetSource("audio/multi-pop.mp3"));
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
      ),
    );
  }
}
