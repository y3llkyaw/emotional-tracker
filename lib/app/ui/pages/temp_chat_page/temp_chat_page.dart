import 'dart:async';
import 'package:animated_emoji/emoji.dart';
import 'package:animated_emoji/emojis.g.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emotion_tracker/app/controllers/chat_controller.dart';
import 'package:emotion_tracker/app/controllers/matching_controller.dart';
import 'package:emotion_tracker/app/controllers/other_profile_page_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/controllers/temp_chat_controller.dart';
import 'package:emotion_tracker/app/data/models/message.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/ui/global_widgets/bottom_sheet.dart';
import 'package:emotion_tracker/app/ui/pages/review_profile_page/review_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;

class TempChatPage extends StatefulWidget {
  const TempChatPage({
    Key? key,
    // required this.chatRoomId,
    required this.users,
    required this.timestamp,
    required this.onExit,
  }) : super(key: key);
  final Function onExit;
  // final String chatRoomId;
  final Timestamp timestamp;
  final List<String> users;

  @override
  State<TempChatPage> createState() => _TempChatPageState();
}

int _calculateAge(DateTime dob) {
  final today = DateTime.now();
  int age = today.year - dob.year;
  if (today.month < dob.month ||
      (today.month == dob.month && today.day < dob.day)) {
    age--;
  }
  return age;
}

class _TempChatPageState extends State<TempChatPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final matchingController = Get.put(MatchingController());
  final profilePageController = Get.put(ProfilePageController());
  final chatController = Get.put(ChatController());
  final tempChatController = Get.put(TempChatController());
  final controller = Get.put(OtherProfilePageController());
  final messageController = TextEditingController();
  late Timer _countdownTimer;
  var otherId = "";
  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final targetTime =
          widget.timestamp.toDate().add(const Duration(minutes: 3));
      final difference = targetTime.difference(now);

      if (difference.isNegative) {
        timer.cancel();
        tempChatController.timeRemaining.value = "Time is up!";
        Get.back();
        matchingController.removeMatchingData();
        Get.to(
          () => ReviewProfilePage(uid: otherId),
          transition: Transition.downToUp,
        );
      } else {
        tempChatController.timeRemaining.value =
            "${difference.inMinutes} minutes and ${difference.inSeconds % 60} seconds left";
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startCountdown();
    final sorted = widget.users..sort();
    tempChatController.roomId.value = "${sorted[0]}_${sorted[1]}";
    for (var uid in widget.users) {
      if (uid != FirebaseAuth.instance.currentUser!.uid) {
        chatController.getUserMessages(uid);
      }
      if (uid != FirebaseAuth.instance.currentUser!.uid) {
        setState(() {
          otherId = uid;
        });
      }
    }
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    messageController.dispose();
    _controller.dispose();
    _countdownTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String otherUid = "hello";
    for (var uid in widget.users) {
      if (uid != FirebaseAuth.instance.currentUser!.uid) {
        otherUid = uid;
      }
    }
    return WillPopScope(
      onWillPop: _confirmExit,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Moodmate Chat"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: Get.height * 0.1,
                padding: EdgeInsets.symmetric(
                  vertical: Get.height * 0.01,
                ),
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: FutureBuilder(
                  future: profilePageController.getProfileByUid(otherUid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SpinKitCircle(
                        itemBuilder: (context, index) => DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven ? Colors.red : Colors.green,
                          ),
                        ),
                        size: 15.0,
                      );
                    } else if (snapshot.hasData) {
                      final profile = snapshot.data as Profile;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: Get.width * 0.2,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  child: AvatarPlus(
                                      "${profile.uid}${profile.name}"),
                                ),
                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Tooltip(
                                      triggerMode: TooltipTriggerMode.tap,
                                      message: "age",
                                      child: Text(
                                        profile.age.toString(),
                                        style: GoogleFonts.aBeeZee(
                                          fontWeight: FontWeight.bold,
                                          color: profile.color,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: Get.width * 0.015),
                                    Container(
                                      width: 1,
                                      height: 20,
                                      color: profile.color,
                                    ),
                                    SizedBox(width: Get.width * 0.015),
                                    Tooltip(
                                      triggerMode: TooltipTriggerMode.tap,
                                      message: profile.genderString,
                                      child: Icon(
                                        profile.genderIcon,
                                        color: profile.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.4,
                            child: Obx(
                              () => Text(
                                tempChatController.timeRemaining.value,
                                style: GoogleFonts.aBeeZee(
                                  fontSize: 15,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  height: Get.height * 0.035,
                                  child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStateProperty.all(
                                        Colors.redAccent.withOpacity(0.8),
                                      ),
                                    ),
                                    onPressed: () {},
                                    label: const Text(
                                      "report",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    icon: const Icon(
                                      CupertinoIcons.exclamationmark_bubble,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.01,
                                ),
                                buildFriendButton(profile),
                                // SizedBox(
                                //   height: Get.height * 0.035,
                                //   child: ElevatedButton.icon(
                                //     style: ButtonStyle(
                                //       backgroundColor: WidgetStateProperty.all(
                                //         Get.theme.colorScheme.error,
                                //       ),
                                //       // textStyle: TextStyle()
                                //     ),
                                //     onPressed: () {},
                                //     label: const Text(
                                //       "Like",
                                //       style: TextStyle(color: Colors.white),
                                //     ),
                                //     icon: const Icon(
                                //       CupertinoIcons.heart_fill,
                                //       color: Colors.white,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    reverse: true,
                    itemCount: chatController.messages.length,
                    itemBuilder: (context, index) {
                      final message = chatController.messages[index];

                      if (message.type == "text") {
                        return _buildMessageWidget(message, index, otherUid);
                      } else if (message.type == "sticker") {
                        return _buildStickerWidget(message, index, otherUid);
                      } else if (message.type == "system") {
                        return _buildSystemMessage(message);
                      }
                      return Container();
                    },
                  ),
                ),
              ),
              // const Spacer(),
              SizedBox(
                width: Get.width,
                height: Get.height * 0.06,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(CupertinoIcons.smiley),
                      color: Get.theme.colorScheme.onSurface,
                      onPressed: () {
                        if (!chatController.showEmoji.value) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                        chatController.showEmoji.value =
                            !chatController.showEmoji.value;
                      },
                    ),
                    SizedBox(
                      width: Get.width * 0.75,
                      child: TextField(
                        onTap: () {
                          chatController.showEmoji.value = false;
                        },
                        controller: messageController,
                        textInputAction: TextInputAction.send,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          hintText: "Message",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(CupertinoIcons.paperplane_fill),
                      color: Get.theme.colorScheme.onSurface,
                      onPressed: () async {
                        chatController.message.value = messageController.text;
                        await chatController
                            .sendMessage(otherUid, isRead: true)
                            .then((v) {});
                        messageController.clear();
                      },
                    ),
                  ],
                ),
              ),
              Obx(() {
                if (!chatController.showEmoji.value) {
                  return Container();
                }
                return Container(
                  color: Get.theme.scaffoldBackgroundColor,
                  height: Get.height * 0.3,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 8,
                      childAspectRatio: 1,
                    ),
                    itemCount: AnimatedEmojis.values.length,
                    itemBuilder: (context, index) {
                      final emoji = AnimatedEmojis.values[index];
                      return GestureDetector(
                        onTap: () {
                          // Update GetX controller
                          chatController.setMessage(messageController.text);
                          chatController
                              .sendSticker(otherUid, emoji.toUnicodeEmoji())
                              .then((v) {
                            messageController.clear();
                            chatController.clearMessage();
                          });

                          chatController.showEmoji.value = false;
                        },
                        child: Center(
                          child: Text(
                            emoji.toUnicodeEmoji(),
                            style: TextStyle(
                              fontSize: Get.width * 0.06,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmExit() async {
    var ouid = "";
    for (var uid in widget.users) {
      if (uid != FirebaseAuth.instance.currentUser!.uid) {
        ouid = uid;
        chatController.getUserMessages(uid);
      }
    }
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Exit Chat Room?"),
        content: const Text("Are you sure you wanna exit from the chat-room ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              matchingController.removeMatchingData();
              Get.off(
                () => ReviewProfilePage(
                  uid: ouid,
                ),
              );
            },
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  //Sticker widget
  Widget _buildStickerWidget(Message message, int index, String uid) {
    if (message.message.toString() == "") {
      return const Column();
    }
    return InkWell(
      onLongPress: () {
        showMessageActionBottomSheet(message, uid);
      },
      child: Column(
        crossAxisAlignment:
            message.uid != FirebaseAuth.instance.currentUser!.uid
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                message.uid != FirebaseAuth.instance.currentUser!.uid
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  // color: Colors.black12,
                  color: Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                        message.uid != FirebaseAuth.instance.currentUser!.uid
                            ? const Radius.circular(20)
                            : const Radius.circular(0),
                    bottomRight:
                        message.uid != FirebaseAuth.instance.currentUser!.uid
                            ? const Radius.circular(0)
                            : const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    topLeft: const Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.15,
                      width: Get.width * 0.3,
                      child: AnimatedEmoji(
                        AnimatedEmojis.fromEmojiString(
                          message.message,
                        )!, // Add null check operator to handle nullable AnimatedEmojiData
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(right: 20, left: 20),
            child: Row(
              mainAxisAlignment: chatController.messages[index].uid ==
                      FirebaseAuth.instance.currentUser!.uid
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                Text(
                  timeago.format(
                    chatController.messages[index].timestamp.toDate(),
                  ),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Get.width * 0.014,
                    ),
                    chatController.messages[index].uid ==
                            FirebaseAuth.instance.currentUser!.uid
                        ? Container()
                        : Icon(
                            Icons.done_all,
                            size: Get.width * 0.03,
                            color: message.read
                                ? Colors.green
                                : Get.theme.colorScheme.onSurface,
                          ),
                    SizedBox(
                      width: Get.width * 0.014,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Message widget
  Widget _buildMessageWidget(Message message, int index, String uid) {
    return InkWell(
      onLongPress: () {
        showMessageActionBottomSheet(message, uid);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Get.height * .005),
        child: Column(
          crossAxisAlignment:
              message.uid != FirebaseAuth.instance.currentUser!.uid
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            BubbleNormal(
              onLongPress: () {},
              color: Colors.grey.withOpacity(0.5),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              isSender: chatController.messages[index].uid ==
                      FirebaseAuth.instance.currentUser!.uid
                  ? false
                  : true,
              text: chatController.messages[index].message,
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                mainAxisAlignment: chatController.messages[index].uid ==
                        FirebaseAuth.instance.currentUser!.uid
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.end,
                children: [
                  Text(
                    timeago.format(
                      chatController.messages[index].timestamp.toDate(),
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.014,
                  ),
                  chatController.messages[index].uid ==
                          FirebaseAuth.instance.currentUser!.uid
                      ? Container()
                      : Icon(
                          Icons.done_all,
                          size: Get.width * 0.03,
                          color: message.read
                              ? Colors.green
                              : Get.theme.colorScheme.onSurface,
                        ),
                  SizedBox(
                    width: Get.width * 0.014,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemMessage(Message message) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message.message,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
            // style: Get.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }

  Widget buildFriendButton(Profile profile) {
    controller.friendStatusStream(profile.uid);
    return Obx(
      () {
        String buttonText = "Like";
        var buttonIcon = CupertinoIcons.heart_fill;
        Color btnColor = Colors.blue;
        var onClick = () async {
          await controller.addFriend(profile);
        };
        switch (controller.friendStatus.value) {
          case "friend":
            buttonIcon = CupertinoIcons.person_2_fill;
            buttonText = "friends";
            btnColor = Colors.grey;
            onClick = () async {};
            break;
          case "requested":
            buttonIcon = CupertinoIcons.heart_fill;
            buttonText = "Liked";
            btnColor = Colors.grey;
            onClick = () async {};
            break;
          case "pending":
            buttonIcon = CupertinoIcons.heart_fill;
            buttonText = "Like Back";
            btnColor = Colors.blueAccent;
            onClick = () async {
              await controller.confirmRequest(profile);
            };
            break;
          default:
        }

        ButtonStyle buttonStyle = ButtonStyle(
          backgroundColor: WidgetStateProperty.all(btnColor),
          iconColor: WidgetStateProperty.all(Colors.white),
        );

        return SizedBox(
          height: Get.height * 0.035,
          width: Get.width * 0.3,
          child: ElevatedButton.icon(
            style: buttonStyle,
            onPressed: onClick,
            label: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            icon: Icon(
              buttonIcon,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
