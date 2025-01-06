import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/add_friends_controller.dart';
import 'package:emotion_tracker/app/controllers/noti_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/profile.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotiController nc = Get.put(NotiController());
  final ProfilePageController pc = Get.put(ProfilePageController());
  final AddFriendsController afc = Get.put(AddFriendsController());

  @override
  Widget build(BuildContext context) {
    nc.getNotification();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Row(
            children: [
              const Text(
                "Notifications",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(width: Get.width * 0.03),
              const Icon(CupertinoIcons.bell_fill)
            ],
          ),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(
            Get.width * 0.05,
          ),
          child: Obx(() {
            var fr = [];
            var frAccept = [];

            var other = [];
            for (var element in nc.notifications) {
              if (element['type'] == "fr") {
                fr.add(element['uid']);
              }
              if (element['type'] == "fr-accept") {
                frAccept.add(element['uid']);
              }
              if (element['type'] == "other") {
                other.add(element['uid']);
              }
            }
            return Column(
              children: [
                ExpansionTile(
                  initiallyExpanded: true,
                  iconColor: Colors.black,
                  leading: const Icon(CupertinoIcons.person_3_fill),
                  title: const Text("Friends Requests"),
                  children: fr
                          .map((uid) => FutureBuilder(
                              future: pc.getProfileByUid(uid),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var profile = snapshot.data as Profile?;
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.04,
                                        vertical: Get.width * 0.04),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                          child: AvatarPlus(
                                              "$uid${profile?.name}")),
                                      title: Text(
                                        profile?.name ?? 'Unknown',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: EdgeInsets.only(
                                            top: Get.width * 0.01),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                await afc.confirmFriendRequest(
                                                    profile!);
                                                setState(() {});
                                              },
                                              child: const Text(
                                                "Accept",
                                                style: TextStyle(
                                                  color: Colors.blueAccent,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.05,
                                            ),
                                            InkWell(
                                              onTap: () {},
                                              child: const Text(
                                                "Decline",
                                                style: TextStyle(
                                                  color: Colors.redAccent,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return ListTile(title: Text(uid));
                              }))
                          .toList() +
                      frAccept
                          .map((uid) => FutureBuilder(
                              future: pc.getProfileByUid(uid),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  var profile = snapshot.data as Profile?;
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Get.width * 0.04,
                                        vertical: Get.width * 0.04),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        child:
                                            AvatarPlus("$uid${profile?.name}"),
                                      ),
                                      title: Row(
                                        children: [
                                          Text(
                                            "${profile?.name}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.04,
                                          ),
                                          Icon(
                                            CupertinoIcons.check_mark_circled,
                                            size: Get.width * 0.04,
                                            color: Colors.green,
                                          ),
                                        ],
                                      ),
                                      subtitle: Padding(
                                        padding: EdgeInsets.only(
                                            top: Get.width * 0.01),
                                        child: const Text(
                                            "accepted your friend request"),
                                      ),
                                    ),
                                  );
                                }
                                return ListTile(title: Text(uid));
                              }))
                          .toList(),
                ),
                const ExpansionTile(
                  iconColor: Colors.black,
                  leading: Icon(Icons.more_horiz),
                  title: Text("Others"),
                  children: [],
                ),
              ],
            );
          })),
    );
  }
}
