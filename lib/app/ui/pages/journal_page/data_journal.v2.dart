import 'package:animated_emoji/emoji.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/data/models/journal.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/ui/utils/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DataJournalV2 extends StatelessWidget {
  const DataJournalV2({
    Key? key,
    required this.journal,
    required this.heroId,
    required this.friProfile,
  }) : super(key: key);

  final Journal journal;
  final String heroId;
  final Profile friProfile;

  @override
  Widget build(BuildContext context) {
    bool isFriMood = false;
    if (journal.uid == friProfile.uid) {
      isFriMood = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          trailing: CircleAvatar(
            child: AvatarPlus(
              isFriMood
                  ? friProfile.uid + friProfile.name
                  : FirebaseAuth.instance.currentUser!.uid +
                      FirebaseAuth.instance.currentUser!.displayName!,
            ),
          ),
          title: Text(
            "${isFriMood ? "${friProfile.name}'s" : "Your"} Mood",
            style: TextStyle(
              fontSize: Get.width * 0.04,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                CupertinoIcons.smiley_fill,
                color: valueToColor(journal.value),
              ),
              SizedBox(
                width: Get.width * 0.013,
              ),
              Text(
                valueToString(journal.value),
                style: TextStyle(
                  fontSize: Get.width * 0.03,
                  color: valueToColor(journal.value),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: Get.width * 0.026,
              ),
              Icon(
                CupertinoIcons.calendar_today,
                color: valueToColor(journal.value),
              ),
              SizedBox(
                width: Get.width * 0.013,
              ),
              Text(
                DateFormat('dd/MM/yy').format(journal.date),
                style: TextStyle(
                  fontSize: Get.width * 0.03,
                  color: valueToColor(journal.value),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: Get.height * 0.3,
              width: Get.width * 0.3,
              child: Hero(
                  tag: "journal_${journal.date}_$heroId",
                  child: AnimatedEmoji(journal.emotion)),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            height: Get.height * 0.3,
            child: SingleChildScrollView(
              child: Text(
                journal.content,
                style: TextStyle(
                  fontSize: Get.width * 0.04,
                ),
              ),
            ),
          ),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text("data"),
            ],
          ),
        ],
      ),
    );
  }
}
