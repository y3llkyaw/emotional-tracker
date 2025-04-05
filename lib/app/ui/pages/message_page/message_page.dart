import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/chat_controller.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/controllers/message_page_controller.dart';
import 'package:emotion_tracker/app/controllers/online_controller.dart';
import 'package:emotion_tracker/app/ui/pages/chat_page/chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final MessagePageController messagePageController = MessagePageController();
  final FriendsController friendsController = Get.put(FriendsController());
  final OnlineController onlineController = Get.put(OnlineController());
  final ChatController chatController = Get.put(ChatController());
  @override
  void initState() {
    friendsController.getFriends();
    chatController.getUnreadMessageCount();
    messagePageController.getFriendsMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: const Row(
            children: [
              Text(
                "Messages",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  CupertinoIcons.chat_bubble_fill,
                ),
              )
            ],
          ),
        ),
      ),
      body: Obx(
        () {
          log("obx");
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
            log(isMessageEmpty.toString());

            if (isMessageEmpty) {
              return _noMessage();
            }

            // data widget
            return _message(messages);
          }
          return _noMessage();
        },
      ),
    );
  }

  Widget _message(messages) {
    return RefreshIndicator(
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
          int count = 0;
          final message = messages[index].value;
          for (var msg in message) {
            if (msg.uid == FirebaseAuth.instance.currentUser!.uid &&
                msg.read == false) {
              count++;
            }
          }

          if (friend != null && messages[index].value.isNotEmpty) {
            return InkWell(
              onTap: () {
                final player = AudioPlayer();
                player.play(AssetSource("audio/swoosh.mp3"));
                Get.to(
                  () => ChatPage(profile: friend),
                  transition: Transition.rightToLeft,
                );
              },
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: Get.width * 0.08),
                leading: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    CircleAvatar(
                      child: AvatarPlus("${messages[index].key}${friend.name}"),
                    ),
                  ],
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      friend.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                      child: Text(
                        messages[index].value.first.type == "journal"
                            ? "sent a mood."
                            : messages[index].value.first.type == "sticker"
                                ? "sent a sticker"
                                : messages[index].value.first.message,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      timeago.format(
                        onlineController.friendsOnlineStatus[friend.uid]
                                ?.toDate() ??
                            DateTime.now(),
                      ),
                      style: TextStyle(
                        fontSize: Get.width * 0.025,
                        color: Colors.green,
                      ),
                    ),
                    count == 0
                        ? const SizedBox.shrink()
                        : Container(
                            padding: EdgeInsets.all(Get.width * 0.001),
                            height: Get.width * 0.05,
                            width: Get.width * 0.04,
                            decoration: const BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: Center(
                              child: Text(
                                count.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  textBaseline: TextBaseline.ideographic,
                                  fontSize: Get.width * 0.03,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ],
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
          CupertinoIcons.chat_bubble_2_fill,
          color: Colors.black26,
          size: Get.width * 0.5,
        ),
        Center(
          child: Text(
            "you have no messages right now !",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: Get.width * 0.036,
              color: Colors.black26,
            ),
          ),
        ),
      ],
    );
  }
}
