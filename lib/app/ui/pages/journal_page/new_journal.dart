import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:emotion_tracker/app/ui/global_widgets/radio_emoji_selction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NewJournalPage extends StatefulWidget {
  final DateTime date;

  const NewJournalPage({Key? key, required this.date}) : super(key: key);
  @override
  State<NewJournalPage> createState() => _NewJournalPageState();
}

class _NewJournalPageState extends State<NewJournalPage> {
  final JournalController journalController = Get.put(JournalController());
  final TextEditingController textEditingController = TextEditingController();

  AnimatedEmojiData selectedEmoji = AnimatedEmojis.neutralFace;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
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
            SizedBox(
              height: Get.height * 0.8,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Title(
                        color: Colors.black,
                        child: const Text(
                          "WHAT'S YOUR MOOD TODAY?",
                          style: TextStyle(
                            fontSize: 22,
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
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            wordSpacing: 0,
                          ),
                        ),
                      ),
                    ),
                    RadioEmojiSelection(
                      selectedEmoji: journalController.emotion.value,
                      onEmojiSelected: (value) {
                        journalController.emotion.value = value;
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.02),
                          child: Title(
                            color: Colors.black,
                            child: const Text(
                              "TEll ME HOW YOU FEEL",
                              style: TextStyle(
                                fontSize: 17,
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
                        onPressed: () {
                          journalController.content.value =
                              textEditingController.text;
                          journalController.date.value = widget.date;
                          journalController.createJournal().then((value) {
                            journalController.emotion.value =
                                AnimatedEmojis.neutralFace;
                            Get.back();
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
