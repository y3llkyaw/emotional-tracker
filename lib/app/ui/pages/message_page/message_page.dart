import 'package:emotion_tracker/app/controllers/message_page_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagePage extends StatelessWidget {
  MessagePage({Key? key}) : super(key: key);
  final MessagePageController messagePageController = MessagePageController();

  @override
  Widget build(BuildContext context) {
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
          print(messagePageController.messagesStream.length);
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
                  "you have no notifications right now !",
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
