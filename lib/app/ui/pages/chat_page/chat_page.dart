import 'package:animated_emoji/animated_emoji.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:emotion_tracker/app/controllers/chat_controller.dart';
import 'package:emotion_tracker/app/data/models/message.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  ChatPage({Key? key, required this.profile}) : super(key: key);

  Profile profile;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatController chatController = Get.put(ChatController());
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    chatController.getUserMessages(widget.profile.uid);
    controller = TextEditingController(text: chatController.message.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: ListTile(
          leading: Stack(
            children: [
              AvatarPlus(
                widget.profile.uid.toString() + widget.profile.name,
                width: 40,
              ),
              const Positioned(
                right: 0,
                bottom: 0,
                child: CircleAvatar(
                  radius: 5,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
          title: Text(widget.profile.name),
          subtitle: const Text("online"),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: Get.width * 0.02),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(CupertinoIcons.info),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: Get.height * 0.03,
          ),
          Obx(
            () => Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  if (message.uid == FirebaseAuth.instance.currentUser!.uid &&
                      (message.read == false)) {
                    chatController.readMessage(message, widget.profile.uid);
                  }
                  if (chatController.messages[index].type == "sticker") {
                    return _buildStickerWidget(message, index);
                  }
                  return _buildMessageWidget(message, index);
                },
              ),
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            chatController.showEmoji.value =
                                !chatController.showEmoji.value;
                          },
                          icon: Icon(
                            chatController.showEmoji.value
                                ? CupertinoIcons.keyboard
                                : CupertinoIcons.smiley,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            chatController.showEmoji.value
                                ? CupertinoIcons.keyboard
                                : CupertinoIcons.photo,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          width: Get.width * 0.53,
                          padding: EdgeInsets.only(
                            left: Get.width * 0.03,
                            right: Get.width * 0.03,
                            bottom: Get.height * 0.01,
                          ),
                          margin: EdgeInsets.only(
                            top: Get.height * 0.03,
                          ),
                          child: TextField(
                            onTap: () {
                              chatController.showEmoji.value = false;
                            },
                            controller: controller,
                            maxLines: 2,
                            decoration: const InputDecoration(
                              hintText: "Type a message ",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                            ),
                            textInputAction: TextInputAction.send,
                            onChanged: (value) {
                              Get.find<ChatController>().setMessage(value);
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: chatController.message.value != ""
                              ? () {
                                  if (controller.text.isNotEmpty) {
                                    // Send message logic here
                                    chatController.setMessage(controller.text);
                                    chatController
                                        .sendMessage(widget.profile.uid)
                                        .then((v) {
                                      controller.clear();
                                      chatController.clearMessage();
                                    });
                                    // Clear both the text controller and GetX state
                                  }
                                }
                              : null,
                          icon: const Icon(CupertinoIcons.paperplane_fill),
                          color: Colors.blue,
                        ),
                      ],
                    ),
                    if (chatController.showEmoji.value)
                      Container(
                        color: Colors.white,
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
                                chatController.setMessage(controller.text);
                                chatController
                                    .sendSticker(widget.profile.uid,
                                        emoji.toUnicodeEmoji())
                                    .then((v) {
                                  controller.clear();
                                  chatController.clearMessage();
                                });
                                // print("object");
                                // Optionally close emoji picker
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
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Sticker widget
  _buildStickerWidget(Message message, int index) {
    if (message.message.toString() == "") {
      return Column();
    }
    return Column(
      crossAxisAlignment: message.uid != FirebaseAuth.instance.currentUser!.uid
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
                color: Colors.black12,
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
        Row(
          mainAxisAlignment:
              message.uid != FirebaseAuth.instance.currentUser!.uid
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
          children: [
            SizedBox(
              width: Get.width * 0.05,
            ),
            Text(
              timeago.format(
                chatController.messages[index].timestamp.toDate(),
                // locale:
                //     'en_short', // Optional: use short format like '5m' instead of '5 minutes ago'
              ),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black45,
              ),
            ),
            SizedBox(
              width: Get.width * 0.05,
            )
          ],
        ),
      ],
    );
  }

  // Message widget
  _buildMessageWidget(Message message, int index) {
    return InkWell(
      onLongPress: () {},
      onTap: () async {
        await chatController.readMessage(message, widget.profile.uid);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Get.height * .01),
        child: Column(
          crossAxisAlignment:
              message.uid != FirebaseAuth.instance.currentUser!.uid
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
          children: [
            BubbleNormal(
              onLongPress: () {},
              color: Colors.black12,
              isSender: chatController.messages[index].uid ==
                      FirebaseAuth.instance.currentUser!.uid
                  ? false
                  : true,
              // seen: message.read ? true : false,
              // delivered: false,
              text: chatController.messages[index].message,
            ),
            Container(
              margin: const EdgeInsets.only(right: 20, left: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.done_all,
                    size: Get.width * 0.03,
                    color: message.read ? Colors.green : Colors.black12,
                  ),
                  SizedBox(
                    width: Get.width * 0.014,
                  ),
                  Text(
                    timeago.format(
                      chatController.messages[index].timestamp.toDate(),
                      // locale:
                      //     'en_short', // Optional: use short format like '5m' instead of '5 minutes ago'
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
