import 'dart:developer';

import 'package:avatar_plus/avatar_plus.dart';
import 'package:emotion_tracker/app/controllers/friends_controller.dart';
import 'package:emotion_tracker/app/controllers/profile_page_controller.dart';
import 'package:emotion_tracker/app/data/models/profile.dart';
import 'package:emotion_tracker/app/ui/pages/profile_page/other_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendsRequestPage extends StatelessWidget {
  FriendsRequestPage({Key? key}) : super(key: key);
  final FriendsController friendsController = Get.put(FriendsController());
  final ProfilePageController profilePageController =
      Get.put(ProfilePageController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.grey,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Theme.of(context)
            .scaffoldBackgroundColor, // Ensure the background color remains the same
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Row(
            children: [
              const Text(
                "Friend Requests",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(width: Get.width * 0.03),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  const Icon(CupertinoIcons.person_fill),
                  Transform(
                    transform:
                        Matrix4.translationValues(Get.width * 0.02, 0, 0),
                    child: Icon(
                      CupertinoIcons.bell_fill,
                      size: Get.width * 0.03,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Obx(
        () {
          if (friendsController.friendRequest.isEmpty) {
            return SizedBox(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.person,
                      color: Colors.grey.withOpacity(0.4),
                      size: 150,
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Text(
                      "There is no Friend Requests",
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
            itemCount: friendsController.friendRequest.length,
            itemBuilder: (context, index) {
              final data = friendsController.friendRequest[index];

              return FutureBuilder(
                  future: profilePageController.getProfileByUid(data),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      log(snapshot.data.toString(), name: "fr-page");
                      final profile = snapshot.data as Profile;
                      friendsController.readFriendRequest(profile.uid);

                      return InkWell(
                        onTap: () {
                          Get.to(() => OtherProfilePage(profile: profile));
                        },
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                          leading: CircleAvatar(
                            radius: 20,
                            child: AvatarPlus(profile.uid + profile.name),
                          ),
                          title: Text(profile.name),
                          subtitle: const Text("requested you to be friend."),
                          trailing: SizedBox(
                            width: Get.width * 0.23,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await friendsController
                                        .acceptFriendRequest(profile);
                                  },
                                  icon: const Icon(
                                    CupertinoIcons
                                        .person_crop_circle_fill_badge_checkmark,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await friendsController
                                        .removeFriendRequest(profile);
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.delete_solid,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Text("data");
                  });
            },
          );
        },
      ),
    );
  }
}
