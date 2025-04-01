import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatInfoPage extends StatelessWidget {
  const ChatInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("chat info"),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {},
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: Get.width * 0.1),
              leading: Icon(
                CupertinoIcons.person_circle,
                size: Get.width * 0.1,
              ),
              title: const Text("Nickname"),
              subtitle: Text("data"),
            ),
          ),
        ],
      ),
    );
  }
}
