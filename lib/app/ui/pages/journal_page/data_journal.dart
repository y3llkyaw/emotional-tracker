import 'package:animated_emoji/animated_emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DataJournalPage extends StatefulWidget {
  final DateTime date;
  final String content;
  final AnimatedEmojiData emoji;

  const DataJournalPage({
    Key? key,
    required this.date,
    required this.content,
    required this.emoji,
  }) : super(key: key);
  @override
  State<DataJournalPage> createState() => _DataJournalPageState();
}

class _DataJournalPageState extends State<DataJournalPage> {
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
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
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: AnimatedEmoji(
                        widget.emoji,
                        size: 150,
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(CupertinoIcons.left_chevron),
                          ),
                          Title(
                            color: Colors.black,
                            child: Text(
                              DateFormat('EEEE, MMMM d, y')
                                  .format(widget.date)
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                wordSpacing: 0,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(CupertinoIcons.right_chevron),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Text(widget.content),
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
