import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/matching_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TempChatPage extends StatefulWidget {
  const TempChatPage({Key? key, required this.chatRoomId}) : super(key: key);
  final String chatRoomId;

  @override
  State<TempChatPage> createState() => _TempChatPageState();
}

class _TempChatPageState extends State<TempChatPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final matchingControllerRoom = Get.put(MatchingController());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    matchingControllerRoom.removeRoom(widget.chatRoomId);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            FirebaseAuth.instance.currentUser!.uid ==
                    widget.chatRoomId.split("_")[0].toString()
                ? CircleAvatar(
                    radius: 20,
                    child:
                        AvatarPlus(widget.chatRoomId.split("_")[0].toString()),
                  )
                : CircleAvatar(
                    radius: 20,
                    child:
                        AvatarPlus(widget.chatRoomId.split("_")[1].toString()),
                  ),
          ],
        ),
      ),
    );
  }
}
