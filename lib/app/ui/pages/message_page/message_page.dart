import 'package:audioplayers/audioplayers.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/controllers/message_page_controller.dart';
import 'package:emotion_tracker/app/controllers/online_controller.dart';
import 'package:emotion_tracker/app/ui/pages/chat_page/chat_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessagePage extends StatelessWidget {
  MessagePage({Key? key}) : super(key: key);
  final MessagePageController messagePageController = MessagePageController();
  final FriendsController friendsController = Get.put(FriendsController());
  final OnlineController onlineController = Get.put(OnlineController());
  @override
  Widget build(BuildContext context) {
    friendsController.getFriends();
    messagePageController.getFriendsMessages();
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
          if (messagePageController.messages.isNotEmpty) {
            List<MapEntry> messages =
                messagePageController.messages.entries.toList();
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final friend = friendsController.friends.firstWhere(
                  (e) => e.uid == messages[index].key,
                  orElse: () => null, // Avoids errors if no match is found
                );

                return InkWell(
                  onTap: () {
                    final player = AudioPlayer();
                    player.play(AssetSource("audio/swoosh.mp3"));
                    Get.to(() => ChatPage(profile: friend));
                  },
                  child: ListTile(
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
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(messages[index].value.first.message),
                    // trailing: Text("data"),
                    trailing: Text(
                      timeago.format(
                        onlineController.friendsOnlineStatus[friend.uid]
                            .toDate(),
                      ),
                      style: TextStyle(
                        fontSize: Get.width * 0.03,
                        color: Colors.green,
                      ),
                    ),
                  ),
                );
              },
            );
          }
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
        },
      ),
    );
  }
}
