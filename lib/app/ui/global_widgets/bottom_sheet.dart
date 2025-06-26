import 'package:animated_emoji/animated_emoji.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/chat_controller.dart';
import 'package:emotion_tracker/app/controllers/comment_controller.dart';
import 'package:emotion_tracker/app/controllers/home_controller.dart';
import 'package:emotion_tracker/app/controllers/journal_controller.dart';
import 'package:emotion_tracker/app/controllers/matching_controller.dart';
import 'package:emotion_tracker/app/controllers/other_profile_page_controller.dart';
import 'package:emotion_tracker/app/controllers/post_controller.dart';
import 'package:emotion_tracker/app/controllers/post_detail_page_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/comment.dart';
import 'package:emotion_tracker/app/data/models/message.dart';
import 'package:emotion_tracker/app/data/models/post.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/sources/enums.dart';
import 'package:emotion_tracker/app/ui/global_widgets/custom_button.dart';
import 'package:emotion_tracker/app/ui/global_widgets/radio_emoji_selction.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/other_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final ChatController chatController = Get.put(ChatController());
final JournalController journalController = Get.put(JournalController());
final MatchingController matchingController = Get.put(MatchingController());
final ProfilePageController profilePageController =
    Get.put(ProfilePageController());

void showEmojiBottomSheet(DateTime date) async {
  // await profilePageController.getCurrentUserProfile();
  AnimatedEmojiData selectedEmoji = AnimatedEmojis.neutralFace;
  final messageController = TextEditingController();
  Get.bottomSheet(
    StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          height: Get.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ListTile(
                  leading: AnimatedEmoji(
                    selectedEmoji,
                    errorWidget: Center(
                      child: Text(
                        selectedEmoji.toUnicodeEmoji(),
                        style: const TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    size: 50,
                  ),
                  title: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    title: Text(
                      "${date.day}/${date.month}/${date.year}",
                      style: TextStyle(
                        fontSize: Get.theme.textTheme.titleSmall!.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: const Text(
                      "how were you feeling? ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    splashColor: Colors.orangeAccent,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: messageController,
                    maxLength: 500,
                    maxLines: 5,
                    scrollPadding: const EdgeInsets.all(20),
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.orangeAccent,
                          width: 2.0,
                        ),
                      ),
                      counterStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      focusColor: Colors.white,
                      hintText: "write about your feelings..",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintMaxLines: 5,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                RadioEmojiSelection(
                  selectedEmoji: selectedEmoji,
                  onEmojiSelected: (emoji) {
                    setState(() => selectedEmoji = emoji);
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: Get.width * 0.45,
                      child: CustomButton(
                        text: "Back",
                        onPressed: () {
                          Get.back();
                        },
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.45,
                      child: Obx(
                        () => CustomButton(
                          isLoading: journalController.isLoading.value,
                          text: "Next",
                          onPressed: () async {
                            journalController.content.value =
                                messageController.text;
                            journalController.emotion.value = selectedEmoji;
                            journalController.date.value = date;
                            await journalController
                                .createJournal()
                                .then((value) {
                              if (value != null) {
                                Get.back();
                                Get.snackbar(
                                    "Success", "Journal created successfully!");
                              } else {
                                Get.snackbar(
                                  "Error",
                                  value.toString(),
                                );
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
    elevation: 1,
    backgroundColor: Colors.black54,
    enableDrag: true,
  );
}

void showDataBottomSheet(
    DateTime date, String content, AnimatedEmojiData emoji) {
  AnimatedEmojiData selectedEmoji = emoji;
  Get.bottomSheet(
    StatefulBuilder(
      builder: (context, setState) {
        return SizedBox(
          height: Get.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: AnimatedEmoji(
                    selectedEmoji,
                    errorWidget: Center(
                      child: Text(
                        selectedEmoji.toUnicodeEmoji(),
                        style: const TextStyle(
                          fontSize: 40,
                        ),
                      ),
                    ),
                    size: 50,
                  ),
                  title: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                    ),
                    title: Text(
                      "${date.day}/${date.month}/${date.year}",
                      style: TextStyle(
                        fontSize: Get.theme.textTheme.titleSmall!.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: const Text(
                      "how were you feeling? ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  trailing: IconButton(
                    splashColor: Colors.orangeAccent,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    content,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    ),
    elevation: 1,
    backgroundColor: Colors.black54,
    enableDrag: true,
  );
}

void showReportBottomSheet(Post post) {
  final PostController postController = Get.put(PostController());

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              "Report Post",
              style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          Row(
            children: [
              const Icon(
                CupertinoIcons.exclamationmark_triangle,
                color: Colors.red,
              ),
              SizedBox(width: Get.width * 0.02),
              Expanded(
                child: Text(
                  "Please provide a reason for reporting this post.",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.02),
          GridView.builder(
            itemCount: ReportType.values.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3,
            ),
            itemBuilder: (context, index) {
              return Obx(
                () => InkWell(
                  onTap: () {
                    postController.selectedReportType.value =
                        ReportType.values[index];
                  },
                  child: Container(
                    width: Get.width * 0.4,
                    decoration: BoxDecoration(
                      color: postController.selectedReportType.value ==
                              ReportType.values[index]
                          ? Colors.blue
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Get.theme.colorScheme.error,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        ReportType.values[index].toString().split('.').last,
                        style: GoogleFonts.aBeeZee(
                          fontSize: 16,
                          color: Colors.grey[200],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ); // Placeholder
            },
          ),
          SizedBox(height: Get.height * 0.02),
          Obx(
            () => postController.selectedReportType.value == ReportType.other
                ? Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          postController.reportBody.value = value;
                        },
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Enter your report here...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02),
                    ],
                  )
                : Container(),
          ),
          Obx(
            () => SizedBox(
              height: Get.height * 0.04,
              width: Get.width * 0.4,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Get.theme.colorScheme.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: postController.selectedReportType.value ==
                            ReportType.other &&
                        postController.reportBody.value.isEmpty
                    ? null
                    : () async {
                        await postController.reportPost(post);
                      },
                label: const Text(
                  "Submit Report",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: Get.height * 0.02),
        ],
      ),
    ),
    backgroundColor: Colors.white,
    isScrollControlled: true,
  );
}

void showMessageActionBottomSheet(Message message, String fid) {
  showModalBottomSheet(
    context: Get.context!,
    builder: (context) {
      return Container(
        color: Get.theme.scaffoldBackgroundColor.withOpacity(0.7),
        height: Get.height * 0.17,
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05,
          vertical: Get.height * 0.02,
        ),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(CupertinoIcons.delete),
              title: const Text("Delete Message"),
              onTap: () {
                chatController.deleteMessage(message, fid);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text("Copy Message"),
              onTap: () {
                Clipboard.setData(ClipboardData(text: message.message));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}

void showDatingFilterSheet() {
  Get.bottomSheet(Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Get.theme.scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Filter",
            style: GoogleFonts.aBeeZee(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    matchingController.filterGender.value = "gender.male";
                  },
                  child: Column(
                    children: [
                      Container(
                        width: Get.width * 0.25,
                        height: Get.width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color:
                              matchingController.filterGender == "gender.male"
                                  ? Get.theme.colorScheme.error
                                  : Colors.blueGrey,
                        ),
                        child: Icon(
                          Icons.male,
                          color: Colors.white,
                          size: Get.width * 0.2,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      Text(
                        "Male",
                        style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.bold,
                          color: matchingController.filterGender == Icons.male
                              ? Get.theme.colorScheme.error
                              : Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    matchingController.filterGender.value = "gender.female";
                  },
                  child: Column(
                    children: [
                      Container(
                        width: Get.width * 0.25,
                        height: Get.width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color:
                              matchingController.filterGender == "gender.female"
                                  ? Get.theme.colorScheme.error
                                  : Colors.blueGrey,
                        ),
                        child: Icon(
                          Icons.female,
                          color: Colors.white,
                          size: Get.width * 0.2,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      Text(
                        "Female",
                        style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.bold,
                          color: matchingController.filterGender == Icons.female
                              ? Get.theme.colorScheme.error
                              : Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    matchingController.filterGender.value = "gender.both";
                  },
                  child: Column(
                    children: [
                      Container(
                        width: Get.width * 0.25,
                        height: Get.width * 0.25,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          color:
                              matchingController.filterGender == "gender.both"
                                  ? Get.theme.colorScheme.error
                                  : Colors.blueGrey,
                        ),
                        child: Icon(
                          Icons.transgender,
                          color: Colors.white,
                          size: Get.width * 0.2,
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      Text(
                        "Both",
                        style: GoogleFonts.aBeeZee(
                          fontWeight: FontWeight.bold,
                          color: matchingController.filterGender ==
                                  Icons.transgender
                              ? Get.theme.colorScheme.error
                              : Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Age",
                style: GoogleFonts.aBeeZee(
                  fontSize: 20,
                ),
              ),
              RangeSlider(
                activeColor: Get.theme.colorScheme.error,
                min: 17,
                max: 45,
                divisions: 37,
                values: RangeValues(
                  matchingController.filterMinAge.value.toDouble(),
                  matchingController.filterMaxAge.value.toDouble(),
                ),
                onChanged: (RangeValues rv) {
                  matchingController.filterMinAge.value = rv.start.toInt();
                  matchingController.filterMaxAge.value = rv.end.toInt();
                },
              ),
              Text(
                "${matchingController.filterMinAge.value}-${matchingController.filterMaxAge.value}",
                style: GoogleFonts.aBeeZee(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          // const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: Get.width * 0.4,
                height: Get.height * 0.07,
                child: CustomButton(
                  color: Colors.blueGrey,
                  text: "Back",
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              SizedBox(
                width: Get.width * 0.4,
                height: Get.height * 0.07,
                child: CustomButton(
                  // fontSize: 10,
                  color: Get.theme.colorScheme.error,
                  text: "Find Your MoodMate",
                  onPressed: () async {
                    // await matchingController.startMatching(
                    //     profilePageController.userProfile.value!);
                    matchingController.findingMatchPerson();
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ));
}

void showDeleteCommentBottomSheet(
    {required Comment comment, required Post post}) {
  final commentController = Get.put(CommentController());
  // final postController = Get.put(PostController());

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Comment Options",
              style: GoogleFonts.aBeeZee(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 20),
          post.uid == FirebaseAuth.instance.currentUser!.uid ||
                  comment.uid == FirebaseAuth.instance.currentUser!.uid
              ? ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text("Delete"),
                  onTap: () async {
                    Get.back();
                    await commentController.deleteComment(comment).then((v) {
                      commentController.commentList.removeWhere(
                          (c) => c.id == comment.id && c.postId == post.id);
                    });
                  },
                )
              : Container(),
          comment.uid != FirebaseAuth.instance.currentUser!.uid
              ? ListTile(
                  leading:
                      const Icon(CupertinoIcons.eye_slash, color: Colors.red),
                  title: const Text("Hide"),
                  onTap: () async {
                    Get.back();
                    await commentController.deleteComment(comment).then((v) {
                      commentController.commentList.removeWhere(
                        (c) => c.id == comment.id && c.postId == post.id,
                      );
                      Get.back();
                      Get.snackbar(
                        "Success",
                        "Comment hidden successfully",
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                      );
                    });
                  },
                )
              : Container(),
          comment.uid != FirebaseAuth.instance.currentUser!.uid
              ? ListTile(
                  leading: const Icon(Icons.report, color: Colors.red),
                  title: const Text("Report"),
                  onTap: () async {
                    showReportBottomSheet(post);
                  },
                )
              : Container(),
        ],
      ),
    ),
  );
}

void showLikeCountBottomSheet(List<String> profileIds) async {
  final pdController = Get.put(PostDetailPageController());
  final homePageController = Get.put(HomeController());
  await pdController.getLikeProfileList(profileIds);

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.heart_fill,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Likes",
                      style: GoogleFonts.aBeeZee(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: pdController.likedProfileList.length,
                itemBuilder: (context, index) {
                  final profile =
                      pdController.likedProfileList[index][0] as Profile;
                  final friendStatus =
                      pdController.likedProfileList[index][1] as String;

                  return InkWell(
                    onTap: () async {
                      if (profile.uid ==
                          FirebaseAuth.instance.currentUser!.uid) {
                        Get.back();
                        homePageController.changeIndex(4);
                        // return;
                      } else {
                        Get.to(
                          () => OtherProfilePage(profile: profile),
                          transition: Transition.rightToLeft,
                        );
                      }
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                          child: CircleAvatar(
                        child: AvatarPlus("${profile.uid}${profile.name}"),
                      )),
                      title: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.name,
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: profile.color,
                                ),
                              ),
                              Container(
                                width: Get.width * 0.1,
                                decoration: BoxDecoration(
                                  color: profile.color.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      profile.genderIcon,
                                      size: 15,
                                      color: profile.color,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      profile.age.toString(),
                                      style: TextStyle(
                                        fontSize: Get.width * 0.025,
                                        color: profile.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: SizedBox(
                        width: Get.width * 0.1,
                        child: Center(
                          child: Text(
                            friendStatus == "none"
                                ? "You"
                                : friendStatus == "friend"
                                    ? "Friend"
                                    : "Not Friend",
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
