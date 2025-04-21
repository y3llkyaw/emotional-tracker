import 'dart:developer';
import 'package:animated_emoji/animated_emoji.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/chat_controller.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/controllers/message_page_controller.dart';
import 'package:emotion_tracker/app/controllers/online_controller.dart';
import 'package:emotion_tracker/app/data/models/journal.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShareSheet extends StatefulWidget {
  const ShareSheet({Key? key, required this.journal}) : super(key: key);
  final Journal journal;
  @override
  State<ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends State<ShareSheet> {
  final MessagePageController messagePageController = MessagePageController();
  final FriendsController friendsController = Get.put(FriendsController());
  final OnlineController onlineController = Get.put(OnlineController());
  final ChatController chatController = Get.put(ChatController());
  var alreadyShard = false;

  @override
  void initState() {
    friendsController.getFriends();
    messagePageController.getFriendsMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform(
            transform: Matrix4.translationValues(0, -Get.height * 0.03, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  // backgroundColor: Colors.white,
                  radius: Get.height * 0.06,
                  child: AnimatedEmoji(
                    widget.journal.emotion,
                    size: Get.width * 0.2,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Text(
                      DateFormat('MMMM d, y').format(widget.journal.date),
                      style: TextStyle(
                        fontSize: Get.width * 0.04,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Share your emotions ",
                      style: TextStyle(
                        fontSize: Get.width * 0.045,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    CupertinoIcons.xmark,
                  ),
                ),
                const SizedBox()
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () {
                if (messagePageController.messages.isNotEmpty) {
                  List<MapEntry> messages =
                      messagePageController.messages.entries.toList();
                  // Sort messages by timestamp of latest message
                  messages.sort((a, b) {
                    final aTimestamp = a.value.first.timestamp;
                    final bTimestamp = b.value.first.timestamp;
                    return bTimestamp.compareTo(aTimestamp); // Descending order
                  });

                  // is message empty
                  var isMessageEmpty = true;
                  for (var element in messages) {
                    if (element.value.isNotEmpty) {
                      isMessageEmpty = false;
                    }
                  }
                  if (isMessageEmpty) {
                    return _noMessage();
                  }
                  // data widget
                  return _message(
                    messages,
                  );
                }
                return _noMessage();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _message(messages) {
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await messagePageController.getFriendsMessages();
        await friendsController.getFriends();
      },
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final friend = friendsController.friends.firstWhere(
            (e) => e.uid == messages[index].key,
            orElse: () => null, // Avoids errors if no match is found
          );

          if (friend != null && messages[index].value.isNotEmpty) {
            return ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: Get.width * 0.08),
              leading: CircleAvatar(
                child: AvatarPlus("${messages[index].key}${friend.name}"),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    friend.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              subtitle: Text(messages[index].value.first.message),
              // trailing: Text("data"),
              trailing: ElevatedButton.icon(
                iconAlignment: IconAlignment.end,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  iconColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: () {
                  chatController
                      .sendJournal(
                        friend.uid,
                        widget.journal,
                      )
                      .then((v) => {});
                },
                icon: const Icon(CupertinoIcons.paperplane_fill),
                label: const Text(
                  "send",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }
          log("returned null");
          // messagePageController.getFriendsMessages();
          return null;
        },
      ),
    );
  }

  Widget _noMessage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          CupertinoIcons.person_2_fill,
          color: Get.theme.colorScheme.onSecondary,
          size: Get.width * 0.5,
        ),
        Center(
          child: Text(
            "you have no friends yet to share your mood.",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Get.width * 0.036,
              color: Get.theme.colorScheme.onSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

void showShareSheet(Journal jid) {
  Get.bottomSheet(
    ShareSheet(
      journal: jid,
    ),
    elevation: 1,
    backgroundColor: Colors.white,
    enableDrag: true,
  );
}
