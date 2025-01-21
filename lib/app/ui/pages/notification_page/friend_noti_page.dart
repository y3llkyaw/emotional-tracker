import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/controllers/noti_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendNotiPage extends StatelessWidget {
  FriendNotiPage({Key? key}) : super(key: key);
  final NotiController nc = Get.put(NotiController());
  final ProfilePageController pc = Get.put(ProfilePageController());
  final FriendsController afc = Get.put(FriendsController());
  final ns = NotificationService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Friends Notifications"),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: nc.notifications.value,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<String> fr = [];
              var frAccept = [];
              var other = [];
              for (var element in snapshot.data!) {
                switch (element['type']) {
                  case "fr":
                    fr.add(element['uid']);
                    break;
                  case "fr-accept":
                    frAccept.add(element['uid']);
                    break;
                  case "other":
                    other.add(element['uid']);
                    break;
                }
              }
              return ListView.builder(itemBuilder: (context, index) {
                return ListTile(title: Text(fr.length.toString()),);
              });
            }

            return Container();
          }),
    );
  }
}
