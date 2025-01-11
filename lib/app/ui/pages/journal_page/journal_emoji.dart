import 'package:animated_emoji/animated_emoji.dart';
import 'package:emotion_tracker/app/ui/global_widgets/bottom_sheet.dart';
import 'package:emotion_tracker/app/ui/global_widgets/emojis_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JournalEmojiWidget extends StatefulWidget {
  const JournalEmojiWidget({
    Key? key,
    required this.emojis,
    required this.onClick,
  }) : super(key: key);
  final List<AnimatedEmojiData> emojis;
  final void Function(AnimatedEmojiData) onClick;

  @override
  State<JournalEmojiWidget> createState() => _JournalEmojiWidgetState();
}

class _JournalEmojiWidgetState extends State<JournalEmojiWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[] +
          widget.emojis.map((e) {
            return InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                onTap: () {
                  widget.onClick(e);
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: AnimatedEmoji(e, size: Get.width * 0.12),
                ));
          }).toList() +
          <Widget>[
            InkWell(
              onTap: () {
                showEmojiSheet(widget.onClick, journalController.emotion.value);
              },
              child: const Icon(Icons.more_horiz),
            )
          ],
    );
  }
}
