import 'package:animated_emoji/animated_emoji.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:chat_bubbles/bubbles/bubble_normal.dart';
import 'package:emotion_tracker/app/controllers/chat_controller.dart';
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
                  if (chatController.messages[index].type == "sticker") {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              margin: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.only(
                                  // topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.15,
                                    width: Get.width * 0.3,
                                    child: AnimatedEmoji(
                                      AnimatedEmojis.fromEmojiString(
                                          chatController.messages[index].message
                                              .toString())!,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      BubbleNormal(
                        color: Colors.black12,
                        isSender: chatController.messages[index].uid ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? false
                            : true,
                        // seen: true,
                        delivered: true,
                        text: chatController.messages[index].message,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 30),
                        child: Text(
                          timeago.format(
                            chatController.messages[index].timestamp.toDate(),
                            locale:
                                'en_short', // Optional: use short format like '5m' instead of '5 minutes ago'
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  );
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
                        Container(
                          width: Get.width * 0.73,
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
                          onPressed: () {
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
                          },
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
                                // Get current cursor position
                                final cursorPos =
                                    controller.selection.base.offset;

                                // Get current text
                                String text = controller.text;

                                // Insert emoji at cursor position
                                if (cursorPos >= 0) {
                                  String newText =
                                      text.substring(0, cursorPos) +
                                          emoji.toUnicodeEmoji() +
                                          text.substring(cursorPos);
                                  controller.text = newText;

                                  // Move cursor after emoji
                                  controller.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: cursorPos +
                                            emoji.toUnicodeEmoji().length),
                                  );
                                } else {
                                  // If no cursor position, add to end
                                  controller.text += emoji.toUnicodeEmoji();
                                }

                                // Update GetX controller
                                chatController.setMessage(controller.text);
                                chatController
                                    .sendSticker(widget.profile.uid)
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
                                  style: TextStyle(fontSize: Get.width * 0.06),
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
}
