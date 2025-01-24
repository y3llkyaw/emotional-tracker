import 'package:animated_emoji/animated_emoji.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.profile}) : super(key: key);
  final Profile profile;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  bool showEmoji = false;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
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
          const Expanded(
            child: SizedBox(),
          ),
          Center(
            child: Container(
              // width: Get.width * 0.94,

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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            showEmoji = !showEmoji;
                            FocusScope.of(context).unfocus();
                          });
                        },
                        icon: Icon(
                          showEmoji
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
                            setState(() {
                              showEmoji = false;
                            });
                          },
                          maxLines: 2,
                          controller: messageController,
                          decoration: const InputDecoration(
                            hintText: "Type a message ",
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                          ),
                          textInputAction: TextInputAction.send,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(CupertinoIcons.paperplane_fill),
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  if (showEmoji)
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
                              messageController.text += emoji.toUnicodeEmoji();
                              setState(() {
                                showEmoji = false;
                              });
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
        ],
      ),
    );
  }
}
