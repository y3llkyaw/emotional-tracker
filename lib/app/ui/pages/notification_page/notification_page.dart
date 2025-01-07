import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/controllers/noti_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final NotiController nc = Get.put(NotiController());
  final ProfilePageController pc = Get.put(ProfilePageController());
  final FriendsController afc = Get.put(FriendsController());

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
        padding: EdgeInsets.all(Get.width * 0.05),
        child: Obx(() {
          return StreamBuilder<List<Map<String, dynamic>>>(
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
                return Column(
                  children: [
                    _buildExpansionTile(
                      icon: CupertinoIcons.person_3_fill,
                      title: "Friends Requests",
                      children: [
                        ..._buildFriendRequests(fr),
                        ..._buildFriendAccepts(frAccept.cast<String>()),
                      ],
                    ),
                    _buildExpansionTile(
                      icon: Icons.more_horiz,
                      title: "Others",
                      children: _buildOtherNotifications(other.cast<String>()),
                    ),
                  ],
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        }),
      ),
    );
  }

  List<Widget> _buildFriendRequests(List<String> friendRequests) {
    return friendRequests.map((uid) {
      return FutureBuilder(
        future: pc.getProfileByUid(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _skeletonTile();
          } else if (snapshot.hasData) {
            var profile = snapshot.data as Profile?;
            return _buildFriendRequestTile(profile, uid);
          }
          return _skeletonTile();
        },
      );
    }).toList();
  }

  List<Widget> _buildFriendAccepts(List<String> friendAccepts) {
    return friendAccepts.map((uid) {
      return FutureBuilder(
        future: pc.getProfileByUid(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var profile = snapshot.data as Profile?;
            return _buildFriendAcceptTile(profile, uid);
          }
          return ListTile(title: Text(uid));
        },
      );
    }).toList();
  }

  List<Widget> _buildOtherNotifications(List<String> otherNotifications) {
    // Implement this method to build other notifications
    return [];
  }

  Widget _buildFriendRequestTile(Profile? profile, String uid) {
    return ListTile(
      leading: CircleAvatar(child: AvatarPlus("$uid${profile?.name}")),
      title: Text(
        profile?.name ?? 'Unknown',
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: Get.width * 0.01),
        child: Row(
          children: [
            InkWell(
              onTap: () async {
                await afc.confirmFriendRequest(profile!);
                setState(() {});
              },
              child: afc.isLoading.value
                  ? const CircularProgressIndicator()
                  : const Text(
                      "Accept",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
            ),
            SizedBox(width: Get.width * 0.05),
            InkWell(
              onTap: () {},
              child: const Text(
                "Decline",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendAcceptTile(Profile? profile, String uid) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.width * 0.002),
      child: ListTile(
        leading: CircleAvatar(child: AvatarPlus("$uid${profile?.name}")),
        title: Row(
          children: [
            Text(
              "${profile?.name}",
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(width: Get.width * 0.04),
            Icon(
              CupertinoIcons.check_mark_circled,
              size: Get.width * 0.04,
              color: Colors.green,
            ),
          ],
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: Get.width * 0.01),
          child: const Text("accepted your friend request"),
        ),
      ),
    );
  }

  Widget _buildExpansionTile({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      iconColor: Colors.black,
      leading: Icon(icon),
      title: Text(title),
      children: children,
    );
  }

  Widget _skeletonTile() {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
      ),
      title: Container(
        width: 100,
        height: 10,
        color: Colors.grey.shade300,
      ),
      subtitle: Container(
        width: 150,
        height: 10,
        color: Colors.grey.shade300,
      ),
    );
  }
}
